# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


SERVICE <- "facebook_adlibrary"
TOKEN <- "fb_adlib_token"
APP_ID <- "fb_adlib_app_id"
APP_SECRET <- "fb_adlib_app_secret"


is_set_up <- function() {
  return(secret_exists(TOKEN) & secret_exists(APP_ID) & secret_exists(APP_SECRET))
}

secret_set <- function(secret = c(TOKEN, APP_ID, APP_SECRET), value) {
  secret <- match.arg(secret)
  keyring::key_set_with_value(service = SERVICE, username = secret, password = value)
}

secret_get <- function(secret = c(TOKEN, APP_ID, APP_SECRET)) {
  secret <- match.arg(secret)
  if (secret_exists(secret)) {
    return(keyring::key_get(service = SERVICE, username = secret))
  }
  stop(glue::glue("Secret {secret} does not exist in keychain."))
}

#' Clear saved settings
#' @description
#' This clears your saved token, app ID, and app secret.
#'
#' @export
#'
adlib_clear_setup <- function() {
  for (secret in c(TOKEN, APP_ID, APP_SECRET)) {
    if (secret_exists(secret)) {
      secret_delete(secret)
    }
  }
}

secret_delete <- function(secret = c(TOKEN, APP_ID, APP_SECRET)) {
  secret <- match.arg(secret)
  keyring::key_delete(service = SERVICE, username = secret)
}

token_set <- function(token) {
  token_string <- token_to_json(token)
  secret_set(TOKEN, token_string)
}

#' Retrieve a stored access token
#'
#' @return The stored access token
#' @export
#'
token_get <- function() {
  if (token_exists()) {
    token_string <- secret_get(TOKEN)
    return(token_from_json(token_string))
  }
  stop("Token doesn't exist.")
}

token_exists <- function() {
  secret_exists(TOKEN)
}

#' Delete your stored token
#'
#' @return TRUE (invisibly) if the token was deleted.
#' @export
token_delete <- function() {
  if (token_exists()) {
    secret_delete(TOKEN)
    return(invisible(TRUE))
  } else {
    invisible(warning("No token was stored, so none was deleted!"))
  }
}


secret_exists <- function(secret = c(TOKEN, APP_ID, APP_SECRET)) {
  secret <- match.arg(secret)
  secret %in% keyring::key_list(service = SERVICE)[["username"]]
}

#' Set up application ID and app secret.
#'
#' This lets you store your application ID and app secret securely
#' in your system's credential store (using the keyring package).
#'
#' The application ID and app secret are used to obtain a long-term
#' access token.
#' @export
#' @seealso \code{\link{adlib_set_longterm_token}} for obtaining a
#' long-term access token.
#'
#' @importFrom utils menu
adlib_setup <- function() {
  get_id <- TRUE
  if (secret_exists(APP_ID)) {
    get_id <- menu(c("y", "n"), title = "Application ID already set. Overwrite? (y/n)") == 1
  }
  if (get_id) {
    message("Visit https://developers.facebook.com/ and navigate to your App's basic settings
to find your Application ID and App Secret.
These will be securely stored in your computer's credential store.")
    readline("Press <Enter> ")
    app_id <- getPass::getPass("Enter your Application ID", noblank = T, forcemask = F)
    secret_set(APP_ID, app_id)
  }

  get_secret <- TRUE
  if (secret_exists(APP_SECRET)) {
    get_secret <- menu(c("y", "n"), title = "App secret already set. Overwrite? (y/n)") == 1
  }
  if (get_secret) {
    app_secret <- getPass::getPass("Enter your App secret", noblank = T, forcemask = F)
    secret_set(APP_SECRET, app_secret)
  }
  message("Application ID and App secret set. Run adlib_set_longterm_token() to save a long term access token.")
}
