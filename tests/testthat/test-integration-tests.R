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
  skip_if_not(token_exists_in_env())
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
  skip_if_not(token_exists_in_env())
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

test_that("Parsing responses works correctly", {
  skip_on_cran()
  skip_if_not(token_exists_in_env())
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  data_response <- adlib_build_query(
    ad_reached_countries = "US",
    search_terms = "Facebook",
    limit = 5
  ) %>%
    adlib_get(token)
  expect_equal(data_response$fields, c(
    "id", "ad_creation_time", "ad_creative_bodies", "ad_creative_link_captions",
    "ad_creative_link_descriptions", "ad_creative_link_titles", "ad_delivery_start_time",
    "ad_delivery_stop_time", "ad_snapshot_url", "bylines", "currency",
    "estimated_audience_size", "impressions", "languages", "page_id",
    "page_name", "publisher_platforms", "spend"
  ))
  expect_equal(length(data_response$data), 5)
})

test_that("Converting to ad table works", {
  skip_on_cran()
  skip_if_not(token_exists_in_env())
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  data_response <- adlib_build_query(
    ad_reached_countries = "US",
    search_terms = "Facebook",
    limit = 5
  ) %>%
    adlib_get(token)
  tbl <- as_tibble(data_response, censor_access_token = TRUE)
  expect_s3_class(tbl, "tbl_df")
  expect_equal(
    vctrs::vec_ptype(tbl),
    structure(list(
      id = character(0), ad_creation_time = character(0),
      ad_creative_bodies = list(), ad_creative_link_captions = list(),
      ad_creative_link_titles = list(), ad_delivery_start_time = character(0),
      ad_delivery_stop_time = character(0), ad_snapshot_url = character(0),
      bylines = character(0), currency = character(0), languages = list(),
      page_id = character(0), page_name = character(0), publisher_platforms = list(),
      estimated_audience_size_lower = numeric(0), estimated_audience_size_upper = numeric(0),
      impressions_lower = numeric(0), impressions_upper = numeric(0),
      spend_lower = numeric(0), spend_upper = numeric(0), ad_creative_link_descriptions = list()
    ), class = c(
      "tbl_df",
      "tbl", "data.frame"
    ), row.names = integer(0))
  )
})

test_that("Getting demographic data works", {
  skip_on_cran()
  skip_if_not(token_exists_in_env())
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  data_response <- adlib_build_query(
    ad_reached_countries = "US",
    search_terms = "Facebook",
    fields = c("id", "demographic_distribution"),
    limit = 5
  ) %>%
    adlib_get(token)
  expect_s3_class(data_response, "adlib_data_response")
  expect_equal(data_response$fields, c("id", "demographic_distribution"))
})

test_that("searching by language works", {
  skip_on_cran()
  skip_if_not(token_exists_in_env())
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  result <- adlib_build_query(
    ad_reached_countries = "BR",
    search_terms = "Facebook",
    fields = c("id", "languages", "delivery_by_region"),
    languages = c("en"),
    limit = 5
  ) %>%
    adlib_get(token) %>%
    as_tibble()
  expect_equal(vctrs::vec_ptype(result), structure(list(id = character(0), languages = list(), delivery_by_region = list()), class = c(
    "tbl_df",
    "tbl", "data.frame"
  ), row.names = integer(0)))
})

test_that("searching by region works", {
  skip_on_cran()
  skip_if_not(token_exists_in_env())
  token <- Sys.getenv("FB_GRAPH_API_TOKEN")
  result <- adlib_build_query(
    ad_reached_countries = "US",
    delivery_by_region = c("California", "New York"),
    search_terms = "Facebook",
    fields = c("id", "delivery_by_region"),
    limit = 5
  ) %>%
    adlib_get(token) %>%
    as_tibble()
  expect_equal(vctrs::vec_ptype(result), structure(list(id = character(0), delivery_by_region = list()), class = c(
    "tbl_df",
    "tbl", "data.frame"
  ), row.names = integer(0)))
})
