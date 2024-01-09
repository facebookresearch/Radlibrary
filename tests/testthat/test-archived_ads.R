# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.

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


test_that("age_country_gender_reach_breakdown", {
  example_archived_ad <- list(
    id = "872228774116748",
    age_country_gender_reach_breakdown = list(list(
      country = "DE",
      age_gender_breakdowns = list(
        list(
          age_range = "18-24",
          male = 270L,
          female = 57L,
          unknown = 4L
        ),
        list(
          age_range = "25-34",
          male = 1020L,
          female = 283L,
          unknown = 3L
        )
      )
    ))
  )

  expect_equal(
    process_agbr(
      example_archived_ad$age_country_gender_reach_breakdown[[1]]$age_gender_breakdowns
    ),
    tibble::tibble(
      age_range = c("18-24", "25-34"),
      male = c(270L, 1020L),
      female = c(57L, 283L),
      unknown = c(4L, 3L)
    )
  )
  expect_equal(
    aa_process_AgeCountryGenderReachBreakdownList(example_archived_ad, "age_country_gender_reach_breakdown"),
    list(
      id = "872228774116748",
      age_country_gender_reach_breakdown = list(tibble::tibble(
        country = c("DE", "DE"),
        age_range = c("18-24", "25-34"),
        male = c(270L, 1020L),
        female = c(57L, 283L),
        unknown = c(4L, 3L)
      ))
    )
  )
})

test_that("beneficiary_payers", {
  aa <- list(id = "313132487749670", beneficiary_payers = list(list(payer = "European Committee of the Regions",
                                                                    beneficiary = "European Committee of the Regions", current = TRUE)))
  expect_equal(aa_process_BeneficiaryPayerList(aa, 'beneficiary_payers'),
               list(id = "313132487749670",
                    beneficiary_payers = list(
                      tibble::tibble(payer = "European Committee of the Regions",
                             beneficiary = "European Committee of the Regions",
                             current = TRUE)
                    )
               )
  )

}
)
