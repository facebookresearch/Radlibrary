# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


# About this file --------------------------------------------------------

# This file contains functions for dealing with fetching, storing, and retrieving
# access tokens.


# Functions ---------------------------------------------------------------

get_long_term_access_token <- function(app_secret, app_id, access_token) {
  # docs: https://developers.facebook.com/docs/facebook-login/access-tokens/refreshing
  params <- list(
    grant_type = "fb_exchange_token",
    client_id = app_id,
    client_secret = app_secret,
    fb_exchange_token = access_token
  )
  response <- graph_get("access_token", params, access_token)

  response_content <- content(response)
  token <- response_content[["access_token"]]
  expiry <- strftime(Sys.time() + as.numeric(response_content[["expires_in"]]), format = "%Y-%m-%d")
  long_term_token <- list(
    token = token,
    expiry = expiry
  )
  print(glue("Long-term token successfully obtained. Token expires {expiry}."))
  long_term_token
}


token_current <- function(appconfig = config_read()) {
  if (token_exists(appconfig)) {
    return(appconfig$token)
  } else {
    stop("No token saved. Run adlib_update_token to get a long-term token.")
  }
}

token_exists <- function(appconfig = config_read()) {
  !is.null(appconfig$token$token)
}

#' Obtain a long-term token.
#'
#' This function exchanges a short-term token for a long-term token.
#' The long-term token will expire in about 60 days. The token is
#' written to your .adlib_config.yml file.
#'
#' @return TRUE
#' @export
#'
adlib_update_token <- function() {
  adlib_config <- config_read()
  access_token <- stringr::str_trim(readline("Paste short-term access token from https://developers.facebook.com/tools/explorer/: "))
  long_term_token <- get_long_term_access_token(
    app_secret = adlib_config$app_secret,
    app_id = adlib_config$app_id,
    access_token = access_token
  )
  config_write(
    app_id = adlib_config$app_id, app_secret = adlib_config$app_secret,
    token = long_term_token
  )
}
