


test_that("Formatting tokens works", {
  expect_equal(format(token), "Facebook Graph API token with no stored expiry time.")
  expect_equal(format(token2), "Facebook Graph API token expiring 2020-01-27 21:09:14")
})

test_that("is_graph_api_token works", {
  expect_true(is_graph_api_token(token))
  expect_true(is_graph_api_token(token2))
  expect_false(is_graph_api_token("fdasfdas"))
}
)
