# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.



# About This FIle ---------------------------------------------------------

# This file handles saving and loading the config file. The
# purpose of the config file is mainly to store the user's
# app id, app secret, and a long term key.


# Functions ---------------------------------------------------------------

config_file_path <- function() {
  fs::path_home(".fb_adlib_config.yaml")
}

config_exists <- function() {
  fs::file_exists(config_file_path())
}

config_read <- function() {
  if (!config_exists()) {
    stop("No config file set. Run adlib_config_setup().")
  }
  return(yaml::yaml.load_file(config_file_path()))
}

config_write <- function(app_id, app_secret, token = NULL) {
  config_list = list(app_id = app_id, app_secret = app_secret, token = token)
  yaml::write_yaml(config_list, config_file_path())
  return(invisible(TRUE))
}

#' Remove the token from your config file.
#'
#' Your access token can provide full access to your Facebook account. For this reason, you
#' may wish to remove it when you're finished working. Use this file to delete your access
#' token from your config file.
#'
#' @return TRUE
#' @export
#'
config_clear_token <- function() {
  cfg <- config_read()
  config_write(app_id = cfg[['app_id']], app_secret = cfg[['app_secret']])
}



#' Delete your config file
#'
#' @return The deleted config file path (invisibly).
#' @export
#'
config_delete <- function() {
  fs::file_delete(config_file_path())
}


#' Initialize the configuration file.
#'
#' This is where you tell adslibrary the details about your app
#' so that it can fetch long-term access tokens for you. You'll need:
#'
#' - Your Application ID
#' - Your App secret
#'
#' These are both located in your app's Basic Settings, which you can find
#' by signing into developers.facebook.com.
#'
#' This will save a file called .fb_adlib_config.yaml to your home directory
#' containing your App ID, App secret, and eventually a token.
#'
#' @return True
#' @export
#'
#' @examples
#' \dontrun{
#' adlib_config_setup()
#'
#' }
#'
#' @importFrom utils menu
adlib_config_setup <- function() {
  if (config_exists()) {
    message("Ad Library config file exists. If you just want to update your long term token,\nrun adlib_update_token(). Overwrite config? (y/n)")
    user_in <- menu(c("y", "n"))
    if (user_in != 1) {
      return(FALSE)
    }
  }
  message("Visit your app's Basic Settings to find your Application ID and App secret.")
  app_id <- stringr::str_trim(readline("Paste your Application ID: "))
  app_secret <- stringr::str_trim(readline("Paste your App secret: "))
  config_write(app_id = app_id, app_secret = app_secret)
  message(glue("Ad Library config file saved.\nRun adlib_update_token() to obtain a long-term access token."))
  return(invisible(TRUE))
}
