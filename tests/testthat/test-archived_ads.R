# Copyright (c) Meta Platforms, Inc. and its affiliates.
# All rights reserved.

test_that("convert_range", {
  l <- list(hello = "hi", spend = list(lower_bound = "0", upper_bound = "20"))
  expect_equal(aa_process_InsightsRangeValue(l, "spend"), list(
    hello = "hi",
    spend_lower = 0,
    spend_upper = 20
  ))
  l <- list(hello = "hi", spend = list(lower_bound = NULL, upper_bound = "20"))
  expect_equal(
    aa_process_InsightsRangeValue(l, "spend"),
    list(hello = "hi", spend_lower = NA, spend_upper = 20)
  )
  l <- list(hello = "hi", spend = list(lower_bound = 0, upper_bound = NULL))
  expect_equal(
    aa_process_InsightsRangeValue(l, "spend"),
    list(hello = "hi", spend_lower = 0, spend_upper = NA)
  )
})

test_that("convert demographic_distribution", {
  dd <- list(
    list(percentage = "0.001389", age = "45-54", gender = "unknown"),
    list(percentage = "0.098611", age = "45-54", gender = "male"),
    list(percentage = "0.001389", age = "55-64", gender = "unknown"),
    list(percentage = "0.002778", age = "25-34", gender = "unknown"),
    list(percentage = "0.005556", age = "35-44", gender = "unknown"),
    list(percentage = "0.013889", age = "65+", gender = "male"),
    list(percentage = "0.023611", age = "18-24", gender = "female"),
    list(percentage = "0.127778", age = "35-44", gender = "male"),
    list(percentage = "0.111111", age = "55-64", gender = "female"),
    list(percentage = "0.079167", age = "55-64", gender = "male"),
    list(percentage = "0.027778", age = "65+", gender = "female"),
    list(percentage = "0.155556", age = "35-44", gender = "female"),
    list(percentage = "0.154167", age = "25-34", gender = "female"),
    list(percentage = "0.098611", age = "25-34", gender = "male"),
    list(percentage = "0.077778", age = "45-54", gender = "female"),
    list(percentage = "0.019444", age = "18-24", gender = "male"),
    list(percentage = "0.001389", age = "65+", gender = "unknown")
  )
  expect_snapshot(aa_process_AudienceDistributionList(list(dd = dd), "dd"))
})
