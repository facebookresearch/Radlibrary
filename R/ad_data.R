# Copyright (c) Meta Platforms, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


SENSITIVE_FIELDS <- c("ad_snapshot_url")

# Data Response Object and methods ----------------------------------------

adlib_data_response <- function(response) {
  extract_error_message(response)
  cont <- httr::content(response, as = "parsed")
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
#' @param x an adlib_data_response object returned by adlib_get
#' @param censor_access_token should access tokens be censored?
#' @param ... additional arguments to pass to conversion function
#'
#' @return a tibble
#' @export
#' @importFrom tibble as_tibble
#'
as_tibble.adlib_data_response <- function(x, censor_access_token = NULL, ...) {
  tbl <- list_of_aa_to_tibble(x$data)
  if (any(x$fields %in% SENSITIVE_FIELDS)) {
    if (is.null(censor_access_token) || censor_access_token) {
      if (is.null(censor_access_token)) {
        warning("Censoring access token. To disable this warning, set an explicit value for censor_access_token")
      }
      sensitive_fields <- intersect(names(tbl), SENSITIVE_FIELDS)
      for (field in sensitive_fields) {
        tbl[[field]] <- censor_access_token(tbl[[field]])
      }
    }
  }
  tbl
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

#' Convert a paginated response into a tibble
#' @param x a paginated response returned by adlib_get_paginated
#' @param censor_access_token should access tokens be censored from output?
#' @param ... other arguments to be passed on to as_tibble
#'
#'
#' @export
#'
as_tibble.paginated_adlib_data_response <- function(x, censor_access_token = NULL, ...) {
  resp <- purrr::discard(x$responses, purrr::is_empty)
  purrr::map_df(resp, as_tibble,
    censor_access_token = censor_access_token, ...
  )
}


na_pad <- function(x) {
  if (length(x) == 0) {
    return(NA)
  }
  x
}
