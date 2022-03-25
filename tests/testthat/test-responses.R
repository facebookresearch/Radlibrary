# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
fields <- c(
  "ad_snapshot_url", "ad_creation_time", "ad_creative_body",
  "ad_creative_link_caption", "ad_creative_link_description", "ad_creative_link_title",
  "ad_delivery_start_time", "ad_delivery_stop_time", "currency",
  "funding_entity", "page_id", "page_name", "spend", "impressions",
  "potential_reach"
)

test_that("Parsing responses works correctly", {
  skip_on_cran()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  data_response <- adlib_build_query(
      ad_reached_countries = "US",
      search_terms = "Facebook",
      limit = 5) %>%
    adlib_get(token)
  expect_snapshot(data_response$fields)
})

test_that("Converting to ad table works", {
  skip_on_cran()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  data_response <- adlib_build_query(
    ad_reached_countries = "US",
    search_terms = "Facebook",
    limit = 5) %>%
    adlib_get(token)
  tbl <- as_tibble(data_response, censor_access_token = T)
  expect_s3_class(tbl, "tbl_df")
  expect_snapshot(names(tbl))
})

test_that("Getting demographic data works", {
  skip_on_cran()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  data_response <- adlib_build_query(
    ad_reached_countries = "US",
    search_terms = "Facebook",
    fields = c('id', 'demographic_distribution'),
    limit = 5) %>%
    adlib_get(token)
  expect_s3_class(data_response, "adlib_data_response")
  expect_equal(data_response$fields, c("id", "demographic_distribution"))
})

test_that("searching by language works", {
  skip_on_cran()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  data_response <- adlib_build_query(
    ad_reached_countries = "BR",
    search_terms = "Facebook",
    fields = c('id', 'languages', "delivery_by_region"),
    languages = c('en'),
    limit = 5) %>%
    adlib_get(token)
  expect_snapshot(names(as_tibble(data_response)))
})

test_that("searching by region works", {
  skip_on_cran()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  data_response <- adlib_build_query(
    ad_reached_countries = "US",
    delivery_by_region = c('California', 'New York'),
    search_terms = "Facebook",
    fields = c('id', 'delivery_by_region'),
    languages = c('en'),
    limit = 5) %>%
    adlib_get(token)
  expect_snapshot(names(as_tibble(data_response)))
})

test_that("Access token censoring", {
  expect_equal(
    censor_access_token(c(
      "https://www.facebook.com/ads/archive/render_ad/?id=524408398417058&access_token=abc123",
      "https://www.facebook.com/ads/archive/render_ad/?id=458130611506266&access_token=abc123"
    )),
    c(
      "https://www.facebook.com/ads/archive/render_ad/?id=524408398417058&access_token={access_token}",
      "https://www.facebook.com/ads/archive/render_ad/?id=458130611506266&access_token={access_token}"
    )
  )
  expect_equal(censor_access_token("access_token={access_token}"), "access_token={access_token}")
})

test_that("Access token detecting", {
  expect_true(detect_access_token(c(
    "https://www.facebook.com/ads/archive/render_ad/?id=524408398417058&access_token=abc123",
    "https://www.facebook.com/ads/archive/render_ad/?id=458130611506266&access_token=abc123"
  )))
  expect_false(detect_access_token(c(
    "https://www.facebook.com/ads/archive/render_ad/?id=524408398417058&access_token={access_token}",
    "https://www.facebook.com/ads/archive/render_ad/?id=458130611506266&access_token={access_token}"
  )))
})
