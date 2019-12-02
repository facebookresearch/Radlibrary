ad_row <- function(row) {
  columns <- c("ad_creation_time", "ad_creative_body", "ad_creative_link_caption",
              "ad_creative_link_description", "ad_creative_link_title", "ad_delivery_start_time",
              "ad_delivery_stop_time", "currency", "funding_entity",
              "page_id", "page_name", "spend", "ad_id", 'impressions')
  for (field in fields) {
    if (is.null(row[[field]])) {
      row[[field]] <- NA
    }
  }
  row[['spend']] <- spend_label(row[['spend']])
  row[['ad_id']] <- ad_id_from_row(row)
  row[['impressions']] = impression_label(row[['impressions']])


  as_tibble(row[columns])
}

impression_label <- function(impression_row) {
  if (is.na(impression_row[[1]])) {
    return(NA)
  }
  return(paste0(impression_row$lower_bound, '-', impression_row$upper_bound))
}

spend_label <- function(spend_row) {
  if (is.na(spend_row[[1]])) {
    return(NA)
  }
  return(paste0(spend_row$lower_bound, '-', spend_row$upper_bound))
}

ad_id_from_row <- function(row) {
  parse_url(row[["ad_snapshot_url"]])[['query']][['id']]
}

ad_table <- function(results, handle_dates = TRUE) {
  res <- results %>%
    map(ad_row) %>%
    bind_rows()

  res
}

demographic_row <- function(result_row) {
  demo_row <- result_row[['demographic_distribution']]
  id <- ad_id_from_row(result_row)
  demo_row %>%
    map_df(as_tibble) %>%
    mutate(ad_id = id) %>%
    mutate(percentage = as.numeric(percentage))
}

demographic_table <- function(results) {
  results %>%
    map_df(demographic_row)
}

region_row <- function(result_row) {
  reg_row <- result_row[['region_distribution']]
  id <- ad_id_from_row(result_row)
  reg_row %>%
    map_df(as_tibble) %>%
    mutate(ad_id = id) %>%
    mutate(percentage = as.numeric(percentage))
}

region_table <- function(results) {
  results %>%
    map_df(region_row)
}

adlib_response_to_tables <- function(response) {
  data <- content(response)[['data']]
  list(
    ad_table = ad_table(data),
    demographic_table = demographic_table(data),
    region_table = region_table(data)
  )
}


