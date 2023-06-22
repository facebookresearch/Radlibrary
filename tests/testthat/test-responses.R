# Copyright (c) Meta Platforms, Inc. and its affiliates.
# All rights reserved.

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
