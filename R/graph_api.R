# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


# About this file ---------------------------------------------------------

# This contains generic functions for calls to graph api.


# Functions ---------------------------------------------------------------


#' API endpoints
#'
#' @param api which API to return the end point for. Currently two endpoints are supported:
#' "ads_archive", for querying the Ad Library, and "access_token", for requesting
#' long-term access tokens.
#' @param version the version of the API to use.
#' @export
#'
#' @return the endpoint URL
#'
graph_api_endpoint <- function(api = c("ads_archive", "access_token"), version = "v5.0") {
  api <- match.arg(api)
  switch(api,
    "ads_archive" = glue::glue("https://graph.facebook.com/{version}/ads_archive"),
    "access_token" = glue::glue("https://graph.facebook.com/{version}/oauth/access_token")
  )
}

response_has_more_pages <- function(response) {
  !is.null(response_next_page(response))
}

response_next_page <- function(response) {
  content(response)[["paging"]][["next"]]
}

#' Get results from Facebook Ad library
#'
#' @param service the graph API endpoint to send a request to
#' @param params a list of parameters build with adlib_build_params
#' @param token an access token from Facebook
#'
#' @return the raw response from Facebook Ad library
#' @export
#' @importFrom httr RETRY http_error stop_for_status
#'
graph_get <- function(service, params, token = token_get()) {
  if (is_graph_api_token(token)) {
    params[["access_token"]] <- token_string(token)
  } else if ((class(token) == "character") & length(token) == 1) {
    params[["access_token"]] <- token
  } else {
    stop("Parameter token must be a string or object of time 'graph_api_token'")
  }
  response <- RETRY("GET", graph_api_endpoint(service), query = params, quiet = FALSE)
  extract_error_message(response)
  response
}

# TODO: make this fail gracefully
graph_get_with_pagination <- function(service, params, token = token_get()[["token"]],
                                      max_gets = 1000, retries = 3) {
  out <- vector("list", max_gets)
  response <- graph_get(service, params, token)
  cont <- content(response)
  out[[1]] <- response
  gets <- 1
  while ((!is.null(cont[["paging"]])) & (gets < max_gets)) {
    query <- httr::parse_url(cont[["paging"]][["next"]])[["query"]]
    response <- graph_get(service, params = query, token)
    gets <- gets + 1
    out[[gets]] <- response
  }
  return(out[1:gets])
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
  if (http_error(response)) {
    out <- paste0("HTTP Error:\n", prettify(content(response, "text", encoding = "UTF-8"), indent = 2))
    stop(out)
  }
  invisible(response)
}
