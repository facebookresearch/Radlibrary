# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


# About this file --------------------------------------------------------

# This file contains functions for dealing with fetching, storing, and retrieving
# access tokens.


# Token Class ---------------------------------------------------------------


graph_api_token <- function(token, expiry = NULL, retrieved = NULL) {
  token <- list(token = token, expiry = expiry, retrieved = retrieved)
  class(token) <- c("graph_api_token", "list")
  token
}

token_from_response <- function(response) {
  cont <- content(response, as = "parsed")
  if (is.null(cont[["access_token"]])) {
    stop("Response does not contain a token.")
  }
  date <- response[["date"]]
  expiry <- as.POSIXct(date) + cont[["expires_in"]]
  graph_api_token(cont[["access_token"]], expiry, retrieved = date)
}

token_expiry <- function(token) {
  return(token[["expiry"]])
}

format.graph_api_token <- function(token) {
  expiry <- token_expiry(token)
  glue::glue("Facebook Graph API token expiring {expiry}")
}

print.graph_api_token <- function(token) {
  cat(format(token))
}

token_to_json <- function(token) {
  jsonlite::toJSON(token, pretty = 2)
}

token_from_json <- function(blob) {
  token <- jsonlite::fromJSON(blob)
  graph_api_token(token = token[["token"]], expiry = token[["expiry"]], retrieved = token[["retrieved"]])
}


# Get token from API ------------------------------------------------------

get_long_term_access_token <- function(app_secret, app_id, access_token) {
  # docs: https://developers.facebook.com/docs/facebook-login/access-tokens/refreshing
  params <- list(
    grant_type = "fb_exchange_token",
    client_id = app_id,
    client_secret = app_secret,
    fb_exchange_token = access_token
  )
  response <- graph_get("access_token", params, access_token)
  token <- token_from_response(response)
  expiry <- token_expiry(token)
  message(glue("Long-term token successfully obtained. Token expires {expiry}."))
  return(token)
}


#' Set long term token
#'
#' @description Once you've entered your Application ID and App secret, you can
#' obtain a long-term token that will expire in about 60 days.
#' @export
#'
adlib_set_longterm_token <- function() {
  if (token_exists()) {
    if (menu(title = "A token is already saved. Get a new one?", choices = c("y", "n")) == 2) {
      return(invisible(FALSE))
    }
  }
  app_id <- secret_get(APP_ID)
  app_secret <- secret_get(APP_SECRET)
  short_term_token <- getPass::getPass("Enter token from https://developers.facebook.com/tools/explorer/")
  if (length(short_term_token) == 0) {
    stop("No short term token supplied.")
  }
  token <- get_long_term_access_token(app_secret, app_id, short_term_token)
  token_set(token)
}
