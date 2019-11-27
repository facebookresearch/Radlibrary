# # Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

.onAttach <- function(libname, pkgname) {
  if (!config_exists()) {
    packageStartupMessage("
You do not have a config file set up. The config file lets you store
a long term access token.

Set one up by running adlib_config_setup()

You'll need your Application ID and App Secret,
which you can get from your Application's Basic Settings page.

Get more information by running ?adlib_config.") # TODO: make this work
  } else if (!token_exists()) {
    packageStartupMessage("
No access token set up. Visit https://developers.facebook.com/tools/explorer/ to
obtain a short-term access token, and then run adlib_update_token() to exchange
it for a long-term access token.
")
  } else {
    expiry <- token_current()$expiry
    packageStartupMessage(glue(
      "Current access token expires {expiry}."
    ))
  }
}
