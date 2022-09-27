integration_test <- function(token, ...) {
  fields <- c(
    "id", "ad_creation_time", "ad_creative_bodies", "ad_creative_link_captions",
    "ad_creative_link_descriptions", "ad_creative_link_titles", "ad_delivery_start_time",
    "ad_delivery_stop_time", "ad_snapshot_url", "bylines", "currency",
    "languages", "page_id", "page_name", "publisher_platforms", "estimated_audience_size_lower",
    "estimated_audience_size_upper", "impressions_lower", "impressions_upper",
    "spend_lower", "spend_upper"
  )
  adlib_build_query(..., fields = fields) %>%
    adlib_get(token = token) %>%
    as_tibble(censor_access_token = TRUE)
}

test_that("searching by keyword works as expected", {
  skip_on_cran()
  skip_on_ci()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  search_by_keyword <- integration_test(token,
    ad_reached_countries = "US",
    ad_delivery_date_min = "2022-01-01",
    ad_delivery_date_max = "2022-01-01",
    search_terms = "biden",
    limit = 10
  )
  expect_snapshot(dplyr::glimpse(search_by_keyword))
})

test_that("searching by page_id as expected", {
  skip_on_cran()
  skip_on_ci()
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  search_by_page <- integration_test(token,
    ad_reached_countries = "US",
    ad_delivery_date_min = "2022-09-01",
    ad_delivery_date_max = "2022-09-26",
    search_page_ids = "673117639774135",
    limit = 10
  )
  expect_snapshot(dplyr::glimpse(search_by_page))
})
