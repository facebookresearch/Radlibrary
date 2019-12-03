test_that("build_query enforces argument requirements", {
  expect_error(adlib_build_query(ad_reached_countries = "US"), "At least one")
  expect_error(adlib_build_query(search_page_ids = 123), "missing")
  expect_error(adlib_build_query(search_terms = "asdf"), "missing")
})

test_that("build_query returns a list as expected", {
  expect_equal(
    adlib_build_query("US", search_terms = "Facebook"),
    list(
      ad_active_status = "ACTIVE", ad_reached_countries = "['US']",
      ad_type = "POLITICAL_AND_ISSUE_ADS", bylines = NULL, impression_condition = "HAS_IMPRESSIONS_LIFETIME",
      publisher_platform = "['FACEBOOK']", search_page_ids = NULL,
      search_terms = "Facebook", fields = "ad_creation_time,ad_creative_body,ad_creative_link_caption,ad_creative_link_description,ad_creative_link_title,ad_delivery_start_time,ad_delivery_stop_time,ad_snapshot_url,currency,demographic_distribution,funding_entity,impressions,page_id,page_name,publisher_platforms,region_distribution,spend",
      limit = 5000
    )
  )
})
test_that("adlib_get works with saved token", {
  query <- adlib_build_query("US", search_terms = "Facebook", limit = 5)
  response <- adlib_get(params = query, token = token_get())
  expect_false(httr::http_error(response))
})
# test_that("adlib_get works with pasted", {
#   query <- adlib_build_query("US", search_terms = "Facebook", limit = 5)
#   response <- adlib_get(params = query, token = pasted_token)
#   expect_false(httr::http_error(response))
# }
# )

test_that("fields works", {
  expect_equal(adlib_fields("ad_data"), "ad_creation_time,ad_creative_body,ad_creative_link_caption,ad_creative_link_description,ad_creative_link_title,ad_delivery_start_time,ad_delivery_stop_time,currency,funding_entity,page_id,page_name,spend,impressions,ad_snapshot_url")
  expect_equal(adlib_fields("demographic_data"), "ad_snapshot_url,demographic_distribution")
  expect_equal(adlib_fields(c("ad_creative_link_title", "ad_delivery_start_time")), "ad_creative_link_title,ad_delivery_start_time")
  expect_error(adlib_fields("dsafdas"))
  expect_error(adlib_fields(c("demographic_data", "ad_data"))
)}


          )
