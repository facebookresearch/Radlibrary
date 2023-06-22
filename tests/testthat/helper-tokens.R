# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
token <- graph_api_token("abcd")
token2 <- structure(list(
  token = "efgh",
  expiry = structure(1580159354, tzone = "GMT", class = c(
    "POSIXct",
    "POSIXt"
  )), retrieved = structure(1574975354, class = c(
    "POSIXct",
    "POSIXt"
  ), tzone = "GMT")
), class = c(
  "graph_api_token",
  "list"
))
