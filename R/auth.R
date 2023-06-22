# Copyright (c) Meta Platforms, Inc. and affiliates.
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

is_graph_api_token <- function(obj) {
  all(identical(class(obj), c("graph_api_token", "list")))
}

token_string <- function(token) {
  return(token$token)
}

token_from_response <- function(response) {
  cont <- httr::content(response, as = "parsed")
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

token_expires <- function(token) {
  return(!is.null(token_expiry(token)))
}

format.graph_api_token <- function(token) {
  if (!token_expires(token)) {
    return("Facebook Graph API token with no stored expiry time.")
  }
  expiry <- token_expiry(token)
  glue::glue("Facebook Graph API token expiring {expiry}")
}

print.graph_api_token <- function(token) {
  cat(format(token))
}

token_to_json <- function(token) {
  jsonlite::toJSON(token, pretty = 2, null = "null", auto_unbox = TRUE)
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
  message(glue::glue("Long-term token successfully obtained. Token expires {expiry}."))
  return(token)
}


#' Set long term token
#'
#' @description Once you've entered your Application ID and App secret, you can
#' obtain a long-term token that will expire in about 60 days. This will be stored
#' in your operating system's secrets manager.
#' @export
#'
#' @seealso \code{\link{adlib_setup}} for storing your App ID and App Secret.
#'
adlib_set_longterm_token <- function() {
  if (token_exists()) {
    if (menu(title = "A token is already saved. Get a new one?", choices = c("y", "n")) == 2) {
      return(invisible(FALSE))
    }
  }
  app_id <- secret_get(APP_ID)
  app_secret <- secret_get(APP_SECRET)
  message("Visit https://developers.facebook.com/tools/explorer/ to obtain a short-term access token.\nIt will be exchanged for a long-term access token that will be securely stored in your computer's credential store.")
  readline("Press <Enter>")
  short_term_token <- get_pass("Enter token")
  if (length(short_term_token) == 0) {
    stop("No short term token supplied.")
  }
  token <- get_long_term_access_token(app_secret, app_id, short_term_token)
  token_set(token)
}
