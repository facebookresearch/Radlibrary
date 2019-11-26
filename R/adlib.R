# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

ADLIB_URL <- "https://graph.facebook.com/v5.0/ads_archive"
DEFAULT_TOKEN_PATH <- path.expand("~/.fb_adlib_token")


#' Set Token
#'
#' Sets the access token from Facebook. Go to https://developers.facebook.com/tools/explorer/
#' to find your token, run adlib_set_token(), and paste your token at the prompt.
#'
#' @param save_as path to token file.
#'
#' @return Returns TRUE
#' @export
#' @importFrom glue glue
#'
#' @examples
#' \dontrun{
#' adlib_set_token()
#' }
adlib_set_token <- function(save_as = DEFAULT_TOKEN_PATH) {
  if (file.exists(save_as)) {
    message(glue("A token exists at {save_as}. Overwrite? (y/n)"))
    overwrite <- "a"
    while (!(overwrite %in% c("y", "n"))) {
      overwrite <- readline()
      if (overwrite == "n") {
        return(invisible(FALSE))
      }
    }
  }
  token <- readline(prompt = "Paste token: ")
  readr::write_file(token, save_as)
}

#' Read the token
#'
#' @param path_to_token path to the token file
#'
#' @return returns True
#' @importFrom readr read_file
#'
adlib_read_token <- function(path_to_token = check_for) {
  if (!file.exists(path_to_token)) {
    stop("Token not set. Run adlib_set_token().")
  }
  readr::read_file(path_to_token)
}


#' Get results from Facebook ads library
#'
#' @param params a list of parameters build with adlib_build_params
#' @param token an access token from Facebook
#'
#' @return the raw response from Facebook Ads library
#' @export
#' @importFrom httr GET http_error
#'
adlib_get <- function(params, token = adlib_read_token(DEFAULT_TOKEN_PATH)) {
  params[["access_token"]] <- token
  response <- GET(ADLIB_URL, query = params)
  if (http_error(response)) {
    stop(extract_error_message(response))
  }
  response
}

#' Extract an error message from a response to pass as an R error
#'
#' @param response a response from the Ad Library API
#'
#' @return a character vector of length 1 containing an error message
#'
#' @importFrom jsonlite prettify
#' @importFrom httr content
extract_error_message <- function(response) {
  prettify(content(response, "text"))
}

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

#' Check whether a token has been set.
#'
#' @param path path to check for token
#'
#' @return TRUE if there is a token
#' @export
#'
#' @examples
#' adlib_check_for_token
adlib_check_for_token <- function(path = DEFAULT_TOKEN_PATH) {
  return(file.exists(path))
}

adlib_data_frame <- function(response) {
  adlib_data <- content(response)[["data"]]
  return(map(adlib_data, as_tibble))
}
