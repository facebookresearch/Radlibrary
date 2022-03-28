# Copyright (c) Facebook, Inc. and its affiliates.
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
  "bylines" = "string",
  "currency" = "string",
  "delivery_by_region" = "AudienceDistributionList",
  "demographic_distribution" = "AudienceDistributionList",
  "estimated_audience_size" = "InsightsRangeValue",
  "impressions" = "InsightsRangeValue",
  "languages" = "list",
  "page_id" = "string",
  "page_name" = "string",
  "publisher_platforms" = "list",
  "spend" = "InsightsRangeValue"
)

# Lookup ArchivedAds field type
lookup_aa_field_type <- function(field_name) {
  archived_ads_field_types[[field_name]]
}

# Get the processor function for an ArchivedAds field
aa_field_processor <- function(field_name) {
  get(paste0("aa_process_", lookup_aa_field_type(field_name)))
}


# Field Processors --------------------------------------------------------
# These functions take a list that is returned by the API representing
# the ArchivedAds node type and a field name, and return a modified list
# where the field has been modified.

# Process fields of type string
aa_process_string <- function(l, field_name) {
  l
}

# Process fields of type string
aa_process_list <- function(l, field_name) {
  l[[field_name]] <- list(unlist(l[[field_name]]))
  l
}

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

aa_process <- function(l) {
  fields <- names(l)
  for (field in fields) {
    processor <- aa_field_processor(field)
    l <- processor(l, field)
  }
  l
}

aa_to_tibble_row <- function(l) {
  tibble::as_tibble_row(aa_process(l))
}

list_of_aa_to_tibble <- function(l) {
  purrr::map_df(l, aa_to_tibble_row)
}
