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
    stop("Parameter token must be a string or object of type 'graph_api_token'")
  }
  agent <- httr::user_agent("Radlibrary R Package")
  response <- RETRY("GET", graph_api_endpoint(service), agent, query = params,
<<<<<<< HEAD
                    quiet = FALSE, terminate_on = c(400, 500))
=======
                    quiet = FALSE)
>>>>>>> 4ddf6bec39d8a341dbce9e49825e22116f4f4e8b
  extract_error_message(response)
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
  if (http_error(response)) {
    out <- paste0("HTTP Error:\n", prettify(content(response, "text", encoding = "UTF-8"), indent = 2))
    stop(out)
  }
  invisible(response)
}

add_token_to_env <- function() {
  # only used for testing at the moment.
  Sys.setenv("FB_GRAPH_API_TOKEN" = token_get()$token)
}
