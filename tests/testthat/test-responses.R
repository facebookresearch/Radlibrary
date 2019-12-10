# Copyright (c) Facebook, Inc. and its affiliates.
# All rights reserved.
test_that("Parsing responses works correctly", {
  expect_equal(data_response$fields, c(
    "ad_creation_time", "ad_creative_body", "ad_creative_link_caption",
    "ad_creative_link_description", "ad_creative_link_title", "ad_delivery_start_time",
    "ad_delivery_stop_time", "currency", "funding_entity", "page_id",
    "page_name", "spend", "impressions", "ad_snapshot_url"
  ))
})

test_that("Converting to ad table works", {
  ad_table <- ad_table(data_response)
  example_adtable <- readRDS("sample_adtable.rds")
  expect_equal(ad_table, example_adtable)
})

test_that("ad_row works when spend and impressions hit upper bound", {
  # upper exists for both
  dr <- data_response$data[[1]]
  row <- ad_row(dr)
  expect_equal(row$spend_lower, 0)
  expect_equal(row$spend_upper, 99)
  expect_equal(row$impressions_lower, 0)
  expect_equal(row$impressions_upper, 999)

  # upper gone for spend
  dr$spend$upper_bound <- NULL
  row <- ad_row(dr)
  expect_equal(row$spend_upper, as.numeric(NA))

  # upper gone for impressions
  dr$impressions$upper_bound <- NULL
  row <- ad_row(dr)
  expect_equal(row$impressions_upper, as.numeric(NA))
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
