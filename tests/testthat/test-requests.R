token <- Sys.getenv("FB_GRAPH_API_TOKEN")
q <- adlib_build_query("US", search_terms = "president", limit = 3)

test_that("graph_get works", {
  resp <- graph_get("ads_archive", q, token)
  expect_equal(httr::status_code(resp), 200)
  expect_true("data" %in% names(httr::content(resp)))
})

test_that("adlib_get works", {
  resp <- adlib_get(q, token = token)
  expect_s3_class(resp, "adlib_data_response")
  resp_table <- tibble::as_tibble(resp)
  expect_true(tibble::is_tibble(resp_table))
})

test_that("adlib_get_paginated works", {
  resp <- adlib_get_paginated(q, token = token, max_gets = 2)
  resp_table <- tibble::as_tibble(resp)
  expect_true(tibble::is_tibble(resp_table))
}
)
