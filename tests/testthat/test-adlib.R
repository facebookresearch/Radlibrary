# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

test_that("build_query enforces argument requirements", {
  expect_error(adlib_build_query(ad_reached_countries = "US"), "At least one")
  expect_error(adlib_build_query(search_page_ids = 123), "missing")
  expect_error(adlib_build_query(search_terms = "asdf"), "missing")
})

test_that("build_query returns a list as expected", {
  expect_snapshot(
    adlib_build_query(
      ad_reached_countries = "US",
      search_terms = "Facebook",
      fields = c("id", "page_name", "estimated_audience_size")
    )
  )
  expect_snapshot(
    adlib_build_query(
      ad_reached_countries = "US",
      search_page_ids = "123",
      fields = c("id", "page_name", "estimated_audience_size")
    )
  )
})

test_that("fields works", {
  expect_equal(adlib_fields("ad_data"), "id,ad_creation_time,ad_creative_bodies,ad_creative_link_captions,ad_creative_link_descriptions,ad_creative_link_titles,ad_delivery_start_time,ad_delivery_stop_time,ad_snapshot_url,bylines,currency,estimated_audience_size,impressions,languages,page_id,page_name,publisher_platforms,spend")
  expect_equal(adlib_fields("demographic_data"), "id,demographic_distribution")
  expect_equal(
    suppressWarnings({
      adlib_fields(c("ad_snapshot_url", "ad_creative_link_titles", "ad_delivery_start_time"))
    }),
    "id,ad_snapshot_url,ad_creative_link_titles,ad_delivery_start_time"
  )
  expect_warning(adlib_fields(c("id", "dsafdas", "dfdsf")))
  expect_error(adlib_fields(c("demographic_data", "ad_data")))
  expect_setequal(ALL_FIELDS, c(
    "id", "ad_creation_time", "ad_creative_bodies", "ad_creative_link_captions",
    "ad_creative_link_descriptions", "ad_creative_link_titles", "ad_delivery_start_time", "ad_delivery_stop_time",
    "ad_snapshot_url", "age_country_gender_reach_breakdown", "beneficiary_payers", "bylines", "currency",
    "delivery_by_region", "demographic_distribution", "estimated_audience_size", "eu_total_reach", "impressions",
    "languages", "page_id", "page_name", "publisher_platforms", "spend", "target_ages", "target_gender",
    "target_locations"
  ))
})
