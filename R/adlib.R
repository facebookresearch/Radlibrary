# Copyright (c) Meta Platforms, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


# About this file ---------------------------------------------------------

# This file contains the main functions that will be called by users of the
# Radlibrary package.


# Constants ---------------------------------------------------------------


AD_DATA_FIELDS <- c(
  "id",
  "ad_creation_time",
  "ad_creative_bodies",
  "ad_creative_link_captions",
  "ad_creative_link_descriptions",
  "ad_creative_link_titles",
  "ad_delivery_start_time",
  "ad_delivery_stop_time",
  "ad_snapshot_url",
  "bylines",
  "currency",
  "estimated_audience_size",
  "impressions",
  "languages",
  "page_id",
  "page_name",
  "publisher_platforms",
  "spend"
)

DEMOGRAPHIC_DATA_FIELDS <- c(
  "id",
  "demographic_distribution"
)

REGION_DATA_FIELDS <- c(
  "id",
  "delivery_by_region"
)

ALL_FIELDS <- c(
  AD_DATA_FIELDS, DEMOGRAPHIC_DATA_FIELDS[2],
  REGION_DATA_FIELDS[2]
)


POTENTIAL_REACH_MAX_VALUES <- c(
  1000, 5000, 10000, 50000, 100000,
  500000, 1000000
)

POTENTIAL_REACH_MIN_VALUES <-
  c(100, 1000, 5000, 10000, 50000, 100000, 500000, 1000000)

# Functions ---------------------------------------------------------------

#' Build an Ad Library Query
#'
#' This will build a list that can be passed to adlib_get. Visit
#' https://developers.facebook.com/docs/marketing-api/reference/ads_archive/ for
#' full API documentation.
#'
#' @param ad_active_status Status of the ads. One of 'ACTIVE', 'INACTIVE', or
#'   'ALL'
#' @param ad_delivery_date_max character. Search for ads delivered before the
#'   date (inclusive) you provide. The date format should be YYYY-mm-dd.
#' @param ad_delivery_date_min character. Search for ads delivered after the
#'   date (inclusive) you provide. The date format should be YYYY-mm-dd.
#' @param ad_reached_countries Vector of ISO country codes. Facebook delivered
#'   the ads in these countries.
#' @param ad_type The type of ad. One of 'ALL', 'POLITICAL_AND_ISSUE_ADS',
#'   'HOUSING_ADS', 'NEWS_ADS', or 'UNCATEGORIZED_ADS'. Currently only
#'   'POLITICAL_AND_ISSUE_ADS' is supported.
#' @param bylines Filter results for ads with a paid for by disclaimer byline,
#'   such as political ads that reference “immigration” paid for by “ACLU”.
#' @param delivery_by_region Character vector of region names. View ads by the
#'   region (such as state or province) where people live or were located when
#'   they saw them.
#' @param estimated_audience_size_max Search for ads with a maximum estimated
#'   audience size. Must be one of these range boundaries:
#'   1000, 5000, 10000, 50000, 100000, 500000, 1000000,
#'   or leave empty for no maximum boundary.
#' @param estimated_audience_size_min Search for ads with a minimum estimated
#'   audience size. Must be one of these range boundaries: 100, 1000, 5000,
#'   10000, 50000, 100000, 500000, 1000000.
#' @param languages a character vector of languages that the ad appears in
#' @param media_type Search for ads based on whether they contain a specific
#'   type of media such as an image or video.
#' @param publisher_platforms The platforms on which the ads appeared. One or
#'   more of "FACEBOOK", "INSTAGRAM", "AUDIENCE_NETWORK", "MESSENGER",
#'   "WHATSAPP".
#' @param search_page_ids A vector of up to 10 page IDs to search.
#' @param search_terms A search string.
#' @param search_type The type of search to use for search_terms field.
#'   KEYWORD_EXACT_PHRASE will return results that contain an exact match for
#'   the search term. Multiple search terms separated by commas can be used to
#'   retrieve results that contain an exact match for each phrase.
#'   KEYWORD_UNORDERED will return results that contain the word in the search
#'   term in any order. By default this is set to KEYWORD_UNORDERED.
#' @param limit The maximum number of results to return
#' @param fields the fields to include in the response. See details for values.
#'
#' @details Preset groups of fields can be specified by "ad_data",
#'   "demographic_data", or "region_data". Otherwise, you can pick and choose
#'   fields. The only *required* field when picking and choosing is id, since
#'   that's the unique identifier for each ad.
#'
#'
#'
#'   \itemize{ \item ad_data \item \item ad_creation_time \item
#'   ad_creative_bodies \item ad_creative_link_captions \item
#'   ad_creative_link_descriptions \item ad_creative_link_titles \item
#'   ad_delivery_start_time \item ad_delivery_stop_time \item ad_snapshot_url
#'   \item bylines \item currency \item estimated_audience_size \item
#'   impressions \item languages \item page_id \item page_name \item
#'   publisher_platforms \item spend \item demographic_distribution \item
#'   delivery_by_region }
#'
#' @return A list of params
#' @export
#' @importFrom utils setTxtProgressBar txtProgressBar
#'
adlib_build_query <- function(ad_active_status = c("ALL", "ACTIVE", "INACTIVE"),
                              ad_delivery_date_max = NULL,
                              ad_delivery_date_min = NULL,
                              ad_reached_countries,
                              ad_type = c(
                                "POLITICAL_AND_ISSUE_ADS", "HOUSING_ADS",
                                "NEWS_ADS", "UNCATEGORIZED_ADS", "ALL"
                              ),
                              bylines = NULL,
                              delivery_by_region = NULL,
                              estimated_audience_size_max = NULL,
                              estimated_audience_size_min = NULL,
                              languages = NULL,
                              media_type = NULL,
                              publisher_platforms = NULL,
                              search_page_ids = NULL,
                              search_terms = NULL,
                              search_type = c("KEYWORD_UNORDERED", "KEYWORD_EXACT_PHRASE"),
                              limit = 1000,
                              fields = "ad_data") {
  ad_active_status <- match.arg(ad_active_status)
  ad_type <- match.arg(ad_type)

  # when search_terms is null, we can't include search_type in the request
  if (is.null(search_terms)) {
    search_type <- NULL
  } else {
    search_type <- match.arg(search_type)
  }

  if (length(search_page_ids) > 10) {
    stop("Can only search 10 page IDs at a time.")
  }

  if (is.null(search_page_ids) & is.null(search_terms)) {
    stop("At least one of search_page_ids or search_terms must be supplied.")
  }

  if (!is.null(estimated_audience_size_max) && !(estimated_audience_size_max %in% POTENTIAL_REACH_MAX_VALUES)) {
    if (estimated_audience_size_max < 1000) {
      stop("estimated_audience_size_max must be at least 1000.")
    } else if (estimated_audience_size_max > 1000000) {
      stop("estimated_audience_size_max can be at most 1,000,000.
           Leave estimated_audience_size_max as NULL to accept any potential reach.")
    } else {
      estimated_audience_size_max <- POTENTIAL_REACH_MAX_VALUES[which(sort(c(POTENTIAL_REACH_MAX_VALUES, estimated_audience_size_max)) == estimated_audience_size_max) - 1]
      warning(glue::glue("estimated_audience_size_max must be one of {paste(as.character(POTENTIAL_REACH_MAX_VALUES), collapse = ', ')}.\n Rounding down to {estimated_audience_size_max}."))
    }
  }

  if (!is.null(estimated_audience_size_min) && !(estimated_audience_size_min %in% POTENTIAL_REACH_MIN_VALUES)) {
    if (estimated_audience_size_min < 100) {
      stop("estimated_audience_size_min must be at least 100.")
    } else if (estimated_audience_size_min > 1000000) {
      stop("estimated_audience_size_min can be at most 1,000,000.")
    } else {
      estimated_audience_size_min <- POTENTIAL_REACH_MIN_VALUES[which(sort(c(POTENTIAL_REACH_MIN_VALUES, estimated_audience_size_min)) == estimated_audience_size_min)]
      warning(glue::glue("estimated_audience_size_min must be one of {paste(as.character(POTENTIAL_REACH_MIN_VALUES), collapse = ', ')}.\n Rounding up to {estimated_audience_size_min}."))
    }
  }

  if (!is.null(estimated_audience_size_max) && !is.null(estimated_audience_size_min) && estimated_audience_size_max <= estimated_audience_size_min) {
    stop("estimated_audience_size_min must be less than estimated_audience_size_max") # the API won't let them be equal
  }

  ad_reached_countries <- format_array(ad_reached_countries)
  bylines <- format_array(bylines)
  search_page_ids <- format_array(search_page_ids)
  delivery_by_region <- format_array(delivery_by_region)
  publisher_platforms <- format_array(publisher_platforms)
  languages <- format_array(languages)

  fields <- adlib_fields(fields)

  list(
    ad_active_status = ad_active_status,
    ad_delivery_date_max = ad_delivery_date_max,
    ad_delivery_date_min = ad_delivery_date_min,
    ad_reached_countries = ad_reached_countries,
    ad_type = ad_type,
    bylines = bylines,
    delivery_by_region = delivery_by_region,
    estimated_audience_size_max = estimated_audience_size_max,
    estimated_audience_size_min = estimated_audience_size_min,
    languages = languages,
    media_type = media_type,
    publisher_platforms = publisher_platforms,
    search_page_ids = search_page_ids,
    search_terms = search_terms,
    search_type = search_type,
    limit = limit,
    fields = fields
  )
}

adlib_fields <- function(fields = c("ad_data", "demographic_data", "region_data", ALL_FIELDS)) {
  fields <- match.arg(fields, several.ok = TRUE)
  if (length(fields) == 1) {
    if (fields == "ad_data") {
      fields <- AD_DATA_FIELDS
    } else if (fields == "demographic_data") {
      fields <- DEMOGRAPHIC_DATA_FIELDS
    } else if (fields == "region_data") {
      fields <- REGION_DATA_FIELDS
    }
  } else if (("ad_data" %in% fields) |
    ("demographic_data" %in% fields) |
    ("region_data" %in% fields)) {
    stop("Fields should be exactly one of ad_data, demographic_data, or region_data")
  }
  if (!("id" %in% fields)) {
    warning("Adding 'id' to fields.")
    fields <- c("id", fields)
  }
  paste0(fields, collapse = ",")
}

#' Query the Ad Library API
#'
#' @param params a query built by adlib_build_query
#' @param token an access_token.
#'
#' @description This function sends a request to the Ad Library API.
#' The `params` argument should be a list that is built with adlib_build_query().
#' The `token` argument can be a short-term token pasted from
#' https://developers.facebook.com/tools/explorer/,
#' or a long-term token stored in your password store. By default it will look
#' for a token in your password store.
#'
#' @return an http response
#' @export
#'
adlib_get <- function(params, token = token_get()) {
  response <- graph_get("ads_archive", params, token)
  return(adlib_data_response(response))
}

#' Paginated query to the ad library API
#'
#' @param query an Ad Library query
#' @param token an access_token
#' @param max_gets The maximum number of calls to adlib_get that this will
#' generate
#'
#' @return a paginated_adlib_data_response object. The response has the
#' following attributes.
#' \itemize{
#'   \item responses - The list of individual responses
#'   \item has_next - A boolean value indicating whether there are still
#'   pages
#'   \item next_page - The URL to call the next page of responses
#' }
#' @export
#'
adlib_get_paginated <- function(query, max_gets = 100, token = token_get()) {
  out <- vector("list", max_gets)
  get_next <- TRUE
  gets <- 0
  pb <- txtProgressBar(0, max_gets, 1, style = 3)
  while (get_next) {
    tryCatch(
      {
        response <- adlib_get(params = query, token = token)
        gets <- gets + 1
        out[[gets]] <- response
        get_next <- response$has_next & (gets < max_gets)
        if (get_next) {
          query <- httr::parse_url(response$next_page)$query
          setTxtProgressBar(pb, gets)
        }
      },
      error = function(e) {
        warning("Most recent call produced an error. Returning last available results.")
        warning(e)
        get_next <<- FALSE
      }
    )
  }
  setTxtProgressBar(pb, max_gets)
  close(pb)
  if (gets == 0) {
    stop("No results returned")
  }
  return(paginated_adlib_data_response(out[1:gets]))
}


#' Format a vector as a json array
#'
#' @param items a vector of items to format
#'
#' @return a string
#' @importFrom glue glue
#' @noRd
format_array <- function(items) {
  if (is.numeric(items)) {
    out <- paste0("[", paste0(items, collapse = ","), "]")
  } else if (is.character(items)) {
    out <- paste0("[", paste0(shQuote(items, type = "sh"), collapse = ","), "]")
  } else if (is.null(items)) {
    out <- NULL
  } else {
    stop(glue::glue("Don't know how to format array of class {class(items)}"))
  }
  out
}


#' @export
#' @importFrom tibble as_tibble
tibble::as_tibble
