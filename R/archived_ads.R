# Copyright (c) Meta Platforms, Inc. and affiliates.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.


# ArchivedAd fields -------------------------------------------------------
# see documentation at
# https://developers.facebook.com/docs/marketing-api/reference/archived-ad/

archived_ads_field_types <- list(
  "id" = "string",
  "ad_creation_time" = "string",
  "ad_creative_bodies" = "list",
  "ad_creative_link_captions" = "list",
  "ad_creative_link_descriptions" = "list",
  "ad_creative_link_titles" = "list",
  "ad_delivery_start_time" = "string",
  "ad_delivery_stop_time" = "string",
  "ad_snapshot_url" = "string",
  "age_country_gender_reach_breakdown" = "AgeCountryGenderReachBreakdownList",
  "beneficiary_payers" = "BeneficiaryPayerList",
  "bylines" = "string",
  "currency" = "string",
  "delivery_by_region" = "AudienceDistributionList",
  "demographic_distribution" = "AudienceDistributionList",
  "estimated_audience_size" = "InsightsRangeValue",
  "eu_total_reach" = "numeric",
  "impressions" = "InsightsRangeValue",
  "languages" = "list",
  "page_id" = "string",
  "page_name" = "string",
  "publisher_platforms" = "list",
  "spend" = "InsightsRangeValue",
  "target_ages" = "numericList",
  "target_gender" = "string",
  "target_locations" = "TargetLocationList"
)


#' Get the field type
#'
#' @param field_name the name of a field
#'
#' @return a string indicating the type of a field
#' @noRd
#'
lookup_aa_field_type <- function(field_name) {
  archived_ads_field_types[[field_name]]
}


#' Archived ad field processor
#'
#' @description
#' Each field type is processed by a field processor function as defined
#' below. This function determines which field processor function to use
#' for a given field name, and returns it as a function.
#'
#' @param field_name name of the field
#'
#' @return a function to process the field specified in field_name
#'
#' @noRd
aa_field_processor <- function(field_name) {
  get(paste0("aa_process_", lookup_aa_field_type(field_name)))
}


#' Process Archived Ads
#'
#' @param l a single list representing an Archived Ads object returned by the
#'   API
#'
#' @return a processed version suitable for conversion to tibble
#' @noRd
#'
aa_process <- function(l) {
  fields <- names(l)
  for (field in fields) {
    processor <- aa_field_processor(field)
    l <- processor(l, field)
  }
  l
}

#' Archived Ads to tibble row
#'
#' @param l a single list representing an Archived Ads object returned by the
#'   API
#'
#' @return a tibble row representing the archived ads object
#'
#' @noRd
#'
aa_to_tibble_row <- function(l) {
  tibble::as_tibble_row(aa_process(l))
}


#' Convert list of archived ads to tibble
#'
#' @param l a list where each element is a raw Archived Ads object returned
#'   by the API
#'
#' @description
#' This is the basic as_tibble functionality
#'
#' @return A tibble representing ads
#' @noRd
list_of_aa_to_tibble <- function(l) {
  purrr::map_df(l, aa_to_tibble_row)
}


# Field Processors --------------------------------------------------------
# These functions take a list that is returned by the API representing
# the ArchivedAds node type and a field name, and return a modified list
# where the field has been modified.

# Process fields of type string
aa_process_string <- function(l, field_name) {
  l
}

aa_process_numeric <- function(l, field_name) {
  l[[field_name]] <- as.numeric(l[[field_name]])
  l
}

aa_process_numericList <- function(l, field_name) {
  l[[field_name]] <- list(as.numeric(unlist(l[[field_name]])))
  l
}

# Process fields of type list<string>
aa_process_list <- function(l, field_name) {
  l[[field_name]] <- list(unlist(l[[field_name]]))
  l
}

aa_process_TargetLocationList <- function(l, field_name) {
  l[[field_name]] <- l[[field_name]] |>
    purrr::map(tibble::as_tibble) |>
    purrr::list_rbind() |>
    list()
  l
}

# Process fields of type list<AudienceDistributionList>
aa_process_AudienceDistributionList <- function(l, field_name) {
  process_aa_row <- function(x) {
    df <- tibble::as_tibble(x)
    df$percentage <- as.numeric(df$percentage)
    df
  }
  l[[field_name]] <- list(purrr::map_df(l[[field_name]], process_aa_row))
  l
}

#' Flatten an InsightsRangeValue
#'
#' @param l a named list as returned by the ads library API
#' @param field_name name of the InsightsRangeValue field contained in l
#'
#' @details See https://developers.facebook.com/docs/graph-api/reference/insights-range-value/
#' for documentation on the InsightsRangeValue data type
#'
#' @noRd
#'
#' @return a list with the `field_name` field replaced with upper and lower
#'   bounds
#'
aa_process_InsightsRangeValue <- function(l, field_name) {
  r <- l[[field_name]]
  l[field_name] <- NULL
  l[[paste(field_name, "lower", sep = "_")]] <- na_pad(as.numeric(r[["lower_bound"]]))
  l[[paste(field_name, "upper", sep = "_")]] <- na_pad(as.numeric(r[["upper_bound"]]))
  l
}

# process fields of type AgeCountryGenderReachBreakdownList
aa_process_AgeCountryGenderReachBreakdownList <- function(l, field_name) {
  agbr <- l[[field_name]]

  df <- purrr::map(agbr, \(x) {
    df <- process_agbr(x$age_gender_breakdowns)
    df$country <- x$country
    df
  }) |>
    purrr::list_rbind()
  l[[field_name]] <- list(df[, c("country", "age_range", "male", "female", "unknown")])


  l
}

aa_process_BeneficiaryPayerList <- function(l, field_name) {
  bp <- l[[field_name]]
  l[[field_name]] <- bp |>
    purrr::map(as_tibble) |>
    purrr::list_rbind() |>
    list()
  l
}

# process a single AgeCountryGenderReachBreakdown object
# used by aa_process_AgeCountryGenderReachBreakdownList
process_agbr <- function(x) {
  purrr::map(x, \(y) {
    tibble::tibble(
      age_range = y$age_range %||% character(),
      male = y$male %||% integer(),
      female = y$female %||% integer(),
      unknown = y$unknown %||% integer()
    )
  }) |>
    purrr::list_rbind()
}
