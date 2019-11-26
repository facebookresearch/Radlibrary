.onAttach <- function(libname, pkgname) {
  if (!adlib_check_for_token()) {
    warning("Looks like ther eis no token in the default location. Begin by running adlib_set_token()")
  }
}
