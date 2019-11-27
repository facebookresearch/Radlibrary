# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


# About this file ---------------------------------------------------------

# This file contains the main functions that will be called by users of the
# adslibrary package.


# Functions ---------------------------------------------------------------

#' Build an Ad Library Query
#'
#' This will build a list that can be passed to adlib_get.
#' Visit https://developers.facebook.com/docs/marketing-api/reference/ads_archive/
#' for full API documentation.
#'
#' @param ad_reached_countries Vector of ISO country codes. Facebook delivered the ads in these countries.
#' @param ad_active_status Status of the ads. One of 'ACTIVE', 'INACTIVE', or 'ALL'.
#' @param ad_type The type of ad. One of 'ALL', 'POLITICAL_AND_ISSUE_ADS', 'HOUSING_ADS', 'NEWS_ADS', or 'UNCATEGORIZED_ADS'. Currently only 'POLITICAL_AND_ISSUE_ADS' is supported.
#' @param bylines Filter results for ads with a paid for by disclaimer byline, such as political ads that reference “immigration” paid for by “ACLU”.
#' @param impression_condition When the ad most recently had impressions. One of "HAS_IMPRESSIONS_LIFETIME", "HAS_IMPRESSIONS_YESTERDAY", "HAS_IMPRESSIONS_LAST_7_DAYS", "HAS_IMPRESSIONS_LAST_30_DAYS", "HAS_IMPRESSIONS_LAST_90_DAYS"
#' @param publisher_platform The platform on which the ads appeared. One or more of "FACEBOOK", "INSTAGRAM", "AUDIENCE_NETWORK", "MESSENGER", "WHATSAPP".
#' @param search_page_ids A vector of up to 10 page IDs to search.
#' @param search_terms A search string.
#'
#' @return A list of params
#' @export
#'
adlib_build_query <- function(ad_reached_countries,
                              ad_active_status = c("ACTIVE", "INACTIVE", "ALL"),
                              ad_type = c(
                                "ALL", "POLITICAL_AND_ISSUE_ADS", "HOUSING_ADS", "NEWS_ADS",
                                "UNCATEGORIZED_ADS"
                              ),
                              bylines = NULL,
                              impression_condition = c(
                                "HAS_IMPRESSIONS_LIFETIME", "HAS_IMPRESSIONS_YESTERDAY",
                                "HAS_IMPRESSIONS_LAST_7_DAYS", "HAS_IMPRESSIONS_LAST_30_DAYS",
                                "HAS_IMPRESSIONS_LAST_90_DAYS"
                              ),
                              publisher_platform = "FACEBOOK",
                              search_page_ids = NULL,
                              search_terms = NULL) {
  ad_active_status <- match.arg(ad_active_status)
  ad_type <- match.arg(ad_type)
  impression_condition <- match.arg(impression_condition)

  if (length(search_page_ids) > 10) {
    stop("Can only search 10 page IDs at a time.")
  }

  ad_reached_countries <- format_array(ad_reached_countries)
  if (!is.null(bylines)) bylines <- format_array(bylines)
  if (!is.null(search_page_ids)) search_page_ids <- format_array(search_page_ids)
  publisher_platform <- format_array(publisher_platform)


  return(list(
    ad_active_status = ad_active_status,
    ad_reached_countries = ad_reached_countries,
    ad_type = ad_type,
    bylines = bylines,
    impression_condition = impression_condition,
    publisher_platform = publisher_platform,
    search_page_ids = search_page_ids,
    search_terms = search_terms
  ))
}

adlib_get <- function(params, token = token_current()[["token"]]) {
  graph_get("ads_archive", params, token)
}


#' Format a vector as a json array
#'
#' @param items a vector of items to format
#'
#' @return a string
#' @importFrom glue glue
#'
format_array <- function(items) {
  if (is.numeric(items)) {
    out <- paste0("[", paste0(items, collapse = ","), "]")
  } else if (is.character(items)) {
    out <- paste0("[", paste0(shQuote(items), collapse = ","), "]")
  }
  else {
    dtype <- class(items)
    stop(glue("Don't know how to format array of class {dtype}"))
  }
  return(out)
}


#' Convert Ad Library response to tibble
#'
#' @param response a response form adlib_get
#'
#' @return tibble
#' @export
#'
#' @importFrom tibble as_tibble
#' @importFrom purrr map
adlib_data_frame <- function(response) {
  adlib_data <- content(response)[["data"]]
  return(map(adlib_data, as_tibble))
}
