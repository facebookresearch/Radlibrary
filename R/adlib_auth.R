ADLIB_CONFIG_FILE <- path.expand('~/.adlib_config.yaml')
GET_LT_TOKEN_URL <- "https://graph.facebook.com/v5.0/oauth/access_token"

adlib_auth_config <- function(config_file = ADLIB_CONFIG_FILE) {
  if(file.exists(config_file)) {
    cfg <- jsonlite::fromJSON()
  }
}

get_long_term_access_token <- function(app_secret, app_id, access_token) {
  params <- list(
    grant_type = "fb_exchange_token",
    client_id = app_id,
    client_secret = app_secret,
    fb_exchange_token = access_token
  )
  response <- (httr::GET(GET_LT_TOKEN_URL, query = params))
  if (http_error(response)) {
    stop(extract_error_message(response))
  }

  long_term_key <- content(response)
  expiry <- strftime(Sys.time() + as.numeric(long_term_key[['expires_in']]), format = '%Y-%m-%d')
  long_term_key[["expiry"]] <- expiry
  long_term_key
}

read_adlib_config <- function(config = ADLIB_CONFIG_FILE) {
  app_config <- yaml::yaml.load_file(ADLIB_CONFIG_FILE)
  app_config
}

adlib_current_token <- function() {
  if (!file.exists(ADLIB_CONFIG_FILE)) {
    stop("No Ad Library config set up. Run adlib_config_init().")
  }
  appconfig <- read_adlib_config()
  if (is.null(appconfig$token)) {
    stop("No current token. Run adlib_update_token().")
  }
  return(appconfig$token)
}

adlib_update_token <- function() {
  adlib_config <- read_adlib_config()
  access_token <- readline("Paste short-term access token: ")
  long_term_token <- get_long_term_access_token(app_secret = adlib_config$app_secret,
                                                app_id = adlib_config$app_id,
                                                access_token = access_token)
  adlib_config$token <- long_term_token
  yaml::write_yaml(adlib_config, file = ADLIB_CONFIG_FILE)
}

adlib_config_init <- function() {
  if (file.exists(ADLIB_CONFIG_FILE)) {
    message(str_glue("Ad Library config file exists. If you just want to update your long term token,\nrun adlib_update_token(). Overwrite config? (y/n)"))
    overwrite <- "a"
    while (!(overwrite %in% c("y", "n"))) {
      overwrite <- readline()
      if (overwrite == "n") {
        return(invisible(FALSE))
      }
    }
  }
  app_id <- readline("Paste your Application ID: ")
  app_secret <- readline("Paste your App secret: ")
  yaml::write_yaml(list(app_id = app_id, app_secret = app_secret, token = NULL),
                   file = ADLIB_CONFIG_FILE)
  message(str_glue("Ad Library config file written to {ADLIB_CONFIG_FILE}.\nRun adlib_update_token() to obtain a long-term access token."))
  return(invisible(TRUE))
}
