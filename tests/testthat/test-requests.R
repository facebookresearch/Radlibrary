# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
#
# ~~~~~~~~~~~~~~~~~  IMPORTANT: PLEASE READ  ~~~~~~~~~~~~~~~~~~~
#
# For local testing just run token_add_to_env() before running the tests

q <- adlib_build_query(
  ad_reached_countries = "US",
  search_terms = "president", limit = 3
)

test_that("graph_get works", {
  skip_on_cran()
  skip_on_ci()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  resp <- graph_get("ads_archive", q, token)
  expect_equal(httr::status_code(resp), 200)
  expect_true("data" %in% names(httr::content(resp)))
  expect_equal(resp$request$options$useragent, "Radlibrary R Package")
})

test_that("adlib_get works", {
  skip_on_cran()
  skip_on_ci()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  resp <- adlib_get(q, token = token)
  expect_s3_class(resp, "adlib_data_response")
  resp_table <- tibble::as_tibble(resp, censor_access_token = FALSE)
  expect_true(tibble::is_tibble(resp_table))
})

test_that("access token censoring in tibbles works", {
  skip_on_cran()
  skip_on_ci()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  resp <- adlib_get(q, token = token)
  resp_table <- tibble::as_tibble(resp, censor_access_token = FALSE)
  expect_true(any(detect_access_token(resp_table$ad_snapshot_url)))
  resp_table <- tibble::as_tibble(resp, censor_access_token = TRUE)
  expect_false(any(detect_access_token(resp_table$ad_snapshot_url)))
  expect_warning(tibble::as_tibble(resp))
})

test_that("adlib_get_paginated works", {
  skip_on_cran()
  skip_on_ci()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  resp <- adlib_get_paginated(q, token = token, max_gets = 2)
  resp_table <- tibble::as_tibble(resp, censor_access_token = FALSE)
  expect_true(tibble::is_tibble(resp_table))
  expect_false(any(detect_access_token(tibble::as_tibble(resp, censor_access_token = TRUE)$ad_snapshot_url)))
  expect_true(any(detect_access_token(tibble::as_tibble(resp, censor_access_token = FALSE)$ad_snapshot_url)))
})

test_that("adlib_get works with no spend or impressions", {
  skip_on_cran()
  skip_on_ci()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  q <- adlib_build_query(
    ad_reached_countries = "US",
    search_terms = "america", limit = 10,
    fields = c("id", "ad_snapshot_url")
  )
  resp <- adlib_get(q, token = token)
  expect_s3_class(as_tibble(resp, censor_access_token = TRUE), "tbl_df")
})
