test_that("Parsing responses works correctly", {
  expect_equal(data_response$fields, c(
    "ad_creation_time", "ad_creative_body", "ad_creative_link_caption",
    "ad_creative_link_description", "ad_creative_link_title", "ad_delivery_start_time",
    "ad_delivery_stop_time", "ad_snapshot_url", "currency", "demographic_distribution",
    "funding_entity", "impressions", "page_id", "page_name", "publisher_platforms",
    "region_distribution", "spend"
  ))
})

test_that("Converting to ad table works", {
  ad_table <- ad_table(data_response)
  example_adtable <- readRDS("sample_adtable.rds")
  expect_equal(ad_table, example_adtable)
})
