# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


# Data Response Object and methods ----------------------------------------

adlib_data_response <- function(response) {
  extract_error_message(response)
  cont <- content(response, as = "parsed")
  if ("data" %in% names(cont)) {
    return(structure(
      list(
        date = response[["date"]],
        data = cont[["data"]],
        has_next = !is.null(cont[["paging"]][["next"]]),
        next_page = cont[["paging"]][["next"]],
        fields = strsplit(
          httr::parse_url(response[["url"]])[["query"]][["fields"]], ","
        )[[1]]
      ),
      class = "adlib_data_response"
    ))
  } else {
    stop("Not a valid data response.")
  }
}


#' @export
length.adlib_data_response <- function(x) {
  length(x$data)
}

#' @export
format.adlib_data_response <- function(x, ...) {
  glue::glue("Data response object with {length(x)} entries.")
}

#' @export
print.adlib_data_response <- function(x, ...) {
  cat(format(x))
}

#' Convert a data response to tibble
#'
#' @param response an adlib_data_response object returned by adlib_get
#' @param type the type of table to output. One of c("ad", "demographic",
#' "region").
#' @param ... additional arguments to pass to conversion function
#'
#' @return a tibble
#' @export
#'
as_tibble.adlib_data_response <- function(response,
                                          type = c("ad", "demographic", "region"),
                                          censor_access_token = NULL,
                                          ...) {
  type <- match.arg(type)
  out <- switch(type,
    "ad" = ad_table(response,
                    censor_access_token = censor_access_token, ...),
    "demographic" = demographic_table(response),
    "region" = region_table(response)
  )

  out
}

censor_access_token <- function(x) {
  stringr::str_replace(x,
    pattern = "access_token=\\w+",
    replacement = "access_token={access_token}"
  )
}

detect_access_token <- function(x) {
  any(stringr::str_detect(x, pattern = "access_token=\\w+"))
}


# Paginated ad tables -----------------------------------------------------

paginated_adlib_data_response <- function(responses) {
  last_response <- responses[[length(responses)]]
  structure(
    list(
      responses = responses,
      has_next = last_response$has_next,
      next_page = last_response$next_page
    ),
    class = "paginated_adlib_data_response"
  )
}

#' Number of pages in a paginated response
#' @param x a paginated data response
#'
#' @export
n_responses <- function(x) {
  length(x$responses)
}

#' Number of records in a paginated response
#' @param x a paginated data response
#' @export
n_records <- function(x) {
  sum(sapply(x$responses, length))
}

#' @export
format.paginated_adlib_data_response <- function(x, ...) {
  glue::glue("Paginated data response object with {n_responses(x)} pages and {n_records(x)} records")
}

#' @export
print.paginated_adlib_data_response <- function(x, ...) {
  cat(format(x))
}

#' @export
as_tibble.paginated_adlib_data_response <- function(x,
  type = c("ad", "demographic", "region"), censor_access_token = NULL, ...) {
  type <- match.arg(type)
  if ((type == "ad") & is.null(censor_access_token)) {
    warning("Automatically censoring ad_snapshot_url to remove access_id.\n  To disable this warning, explicitly specify a value for `censor_access_token`.")
    censor_access_token <- TRUE
  }
  resp <- purrr::discard(x$responses, purrr::is_empty)
  purrr::map_df(resp, as_tibble, type = type,
                censor_access_token = censor_access_token, ...)
}


# Table conversion functions ----------------------------------------------



#' Create a single row in the ad table
#'
#' @param row a single row in the response
#'
#' @return tibble with a single row
#'
ad_row <- function(row) {
  columns <- c(
    "ad_creation_time", "ad_creative_body", "ad_creative_link_caption",
    "ad_creative_link_description", "ad_creative_link_title",
    "ad_delivery_start_time", "ad_delivery_stop_time", "currency",
    "funding_entity", "page_id", "page_name", "spend_lower", "spend_upper",
    "ad_id", "impressions_lower", "impressions_upper", "ad_snapshot_url"
  )
  for (field in columns) {
    if (is.null(row[[field]])) {
      row[[field]] <- NA
    }
  }
  row[["spend_lower"]] <- as.numeric(row[["spend"]][["lower_bound"]])
  row[["spend_upper"]] <- as.numeric(na_pad(row[["spend"]][["upper_bound"]]))
  row[["ad_id"]] <- ad_id_from_row(row)
  row[["impressions_lower"]] <- as.numeric(row[["impressions"]][["lower_bound"]])
  row[["impressions_upper"]] <- as.numeric(na_pad(row[["impressions"]][["upper_bound"]]))
  row[columns]
}

na_pad <- function(x) {
  if (length(x) == 0) {
    return(NA)
  }
  x
}


ad_id_from_row <- function(row) {
  # get ad id from URL
  httr::parse_url(row[["ad_snapshot_url"]])[["query"]][["id"]]
}

#' Create an ad_table from results
#'
#' @param results data from an ads_archive response
#' @param handle_dates if true, convert dates columns to date
#' @param censor_access_token if true, the ad_snapshot_url will be censored
#'
#' @return dataframe with one row per ad
#' @export
#' @importFrom lubridate ymd_hms
#' @importFrom dplyr mutate_at vars
ad_table <- function(results, handle_dates = TRUE, censor_access_token = NULL) {
  res <- results$data %>%
    map(ad_row) %>%
    purrr::transpose() %>%
    map(unlist) %>%
    as_tibble()


  if (handle_dates) {
    res <- res %>%
      dplyr::mutate_at(vars(
        .data$ad_creation_time, .data$ad_delivery_start_time,
        .data$ad_delivery_stop_time
      ), list(lubridate::ymd_hms))
  }

  # censor access tokens
  if (is.null(censor_access_token)) {
    censor <- TRUE
  } else {
    censor <- censor_access_token
  }

  any_raw_tokens <- any(detect_access_token(res$ad_snapshot_url))
  if (is.null(censor_access_token) & any_raw_tokens) {
    warning("Automatically censoring ad_snapshot_url to remove access_id.\n  To disable this warning, explicitly specify a value for `censor_access_token`.")
  }

  if (("ad_snapshot_url" %in% names(res)) & censor) {
    res$ad_snapshot_url <- censor_access_token(res$ad_snapshot_url)
  }

  res
}

#' Result Row
#'
#' @param result_row demographic data for a single ad
#'
#' @return a dateframe with one row
#'
#' @importFrom purrr map_df
#' @importFrom dplyr mutate
#' @importFrom rlang .data
demographic_row <- function(result_row) {
  demo_row <- result_row[["demographic_distribution"]]
  id <- ad_id_from_row(result_row)
  demo_row %>%
    map_df(as_tibble) %>%
    mutate(ad_id = id) %>%
    mutate(percentage = as.numeric(.data$percentage))
}

#' Turn data from the data field in response content into a demographics table
#'
#' @param results the data field of a valid response
#'
#' @return a dataframe
#' @export
#'
demographic_table <- function(results) {
  if (!("demographic_distribution" %in% results$fields)) {
    stop("\"region_distribution\" must be one of the fields returned in order to
construct region table.")
  }
  results$data %>%
    map_df(demographic_row)
}

region_row <- function(result_row) {
  reg_row <- result_row[["region_distribution"]]
  id <- ad_id_from_row(result_row)
  reg_row %>%
    map_df(as_tibble) %>%
    mutate(ad_id = id) %>%
    mutate(percentage = as.numeric(.data$percentage))
}

#' Region Table
#'
#' @param results the data field of response content
#'
#' @return a dataframe
#' @export
#'
region_table <- function(results) {
  if (!("region_distribution" %in% results$fields)) {
    stop("\"region_distribution\" must be one of the fields returned in order to
construct region table.")
  }
  results$data %>%
    map_df(region_row)
}
