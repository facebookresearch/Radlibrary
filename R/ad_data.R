# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


#' Create a single row in the ad table
#'
#' @param row a single row in the response
#'
#' @return tibble with a single row
#'
ad_row <- function(row) {
  columns <- c("ad_creation_time", "ad_creative_body", "ad_creative_link_caption",
              "ad_creative_link_description", "ad_creative_link_title", "ad_delivery_start_time",
              "ad_delivery_stop_time", "currency", "funding_entity",
              "page_id", "page_name", "spend", "ad_id", 'impressions', 'ad_snapshot_url')
  for (field in columns) {
    if (is.null(row[[field]])) {
      row[[field]] <- NA
    }
  }
  row[['spend']] <- spend_label(row[['spend']])
  row[['ad_id']] <- ad_id_from_row(row)
  row[['impressions']] = impression_label(row[['impressions']])


  as_tibble(row[columns])
}

impression_label <- function(impression_row) {
  # turn the "impression" data into a single value
  if (is.na(impression_row[[1]])) {
    return(NA)
  }
  return(paste0(impression_row$lower_bound, '-', impression_row$upper_bound))
}

spend_label <- function(spend_row) {
  # turn the spend data into a single value
  if (is.na(spend_row[[1]])) {
    return(NA)
  }
  return(paste0(spend_row$lower_bound, '-', spend_row$upper_bound))
}

ad_id_from_row <- function(row) {
  # get ad id from URL
  httr::parse_url(row[["ad_snapshot_url"]])[['query']][['id']]
}

#' Create an ad_table from results
#'
#' @param results data from an ads_archive response
#' @param handle_dates if true, convert dates columns to date
#'
#' @return dataframe with one row per ad
#' @export
#' @importFrom lubridate ymd_hms
#' @importFrom dplyr mutate_at vars
ad_table <- function(results, handle_dates = TRUE) {
  res <- results %>%
    map(ad_row) %>%
    bind_rows()

  if (handle_dates) {
    res <- res %>%
      dplyr::mutate_at(vars(.data$ad_creation_time, .data$ad_delivery_start_time,
                            .data$ad_delivery_stop_time), list(lubridate::ymd_hms))
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
  demo_row <- result_row[['demographic_distribution']]
  id <- ad_id_from_row(result_row)
  demo_row %>%
    map_df(as_tibble) %>%
    mutate(ad_id = id) %>%
    mutate(percentage = as.numeric(.data$percentage))
}

demographic_table <- function(results) {
  results %>%
    map_df(demographic_row)
}

region_row <- function(result_row) {
  reg_row <- result_row[['region_distribution']]
  id <- ad_id_from_row(result_row)
  reg_row %>%
    map_df(as_tibble) %>%
    mutate(ad_id = id) %>%
    mutate(percentage = as.numeric(.data$percentage))
}

region_table <- function(results) {
  results %>%
    map_df(region_row)
}

#' Parse a response to create three tables
#'
#' @param response a response from adlib_get
#'
#' @return A list of three tables.
#' @export
#'
#' @details The result of this is three tables that can be joined to each other on ad_id.
#'1. The `ad_table` contains one row per ad from the response, contains data bout each ad such as when it started, who is paying for it, and how much they have spent, and how many impressions it has received.
#'2. The `demographic_table` contains a demographic breakdown of ad viewers, with one row per pair of (age bucket, gender), per ad.
#'3 The `region_table` contains a breakdown of where each ad was viewed, with one row per `ad_id` and `region`.
#'
adlib_response_to_tables <- function(response) {
  data <- content(response)[['data']]
  list(
    ad_table = ad_table(data),
    demographic_table = demographic_table(data),
    region_table = region_table(data)
  )
}


