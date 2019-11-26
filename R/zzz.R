# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

.onAttach <- function(libname, pkgname) {
  if (!adlib_check_for_token()) {
    warning("Looks like ther eis no token in the default location. Begin by running adlib_set_token()")
  }
}
