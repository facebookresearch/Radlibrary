# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#
# .onAttach <- function(libname, pkgname) {
#   if (!is_set_up()) {
#     packageStartupMessage("
# You do not have any App data saved. Run adlib_setup() to save your App data
# securely to your password store in order to obtain a long-term access token.
#
# You'll need your Application ID and App Secret,
# which you can get from your Application's Basic Settings page.
#
# Get more information by running ?adlib_setup") # TODO: make this work
#   } else if (!token_exists()) {
#     packageStartupMessage("
# No access token set up. Visit https://developers.facebook.com/tools/explorer/ to
# obtain a short-term access token, and then run adlib_set_longterm_token() to exchange
# it for a long-term access token.
# ")
#   } else {
#     expiry <- token_expiry(token_get())
#     packageStartupMessage(glue(
#       "Current access token expires {expiry}."
#     ))
#   }
# }
