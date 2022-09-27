# build_query returns a list as expected

    Code
      adlib_build_query(ad_reached_countries = "US", search_terms = "Facebook",
        fields = c("id", "page_name", "estimated_audience_size"))
    Output
      $ad_active_status
      [1] "ALL"
      
      $ad_delivery_date_max
      NULL
      
      $ad_delivery_date_min
      NULL
      
      $ad_reached_countries
      [1] "['US']"
      
      $ad_type
      [1] "POLITICAL_AND_ISSUE_ADS"
      
      $bylines
      NULL
      
      $delivery_by_region
      NULL
      
      $estimated_audience_size_max
      NULL
      
      $estimated_audience_size_min
      NULL
      
      $languages
      NULL
      
      $media_type
      NULL
      
      $publisher_platforms
      NULL
      
      $search_page_ids
      NULL
      
      $search_terms
      [1] "Facebook"
      
      $search_type
      NULL
      
      $limit
      [1] 1000
      
      $fields
      [1] "id,page_name,estimated_audience_size"
      

---

    Code
      adlib_build_query(ad_reached_countries = "US", search_page_ids = "123", fields = c(
        "id", "page_name", "estimated_audience_size"))
    Output
      $ad_active_status
      [1] "ALL"
      
      $ad_delivery_date_max
      NULL
      
      $ad_delivery_date_min
      NULL
      
      $ad_reached_countries
      [1] "['US']"
      
      $ad_type
      [1] "POLITICAL_AND_ISSUE_ADS"
      
      $bylines
      NULL
      
      $delivery_by_region
      NULL
      
      $estimated_audience_size_max
      NULL
      
      $estimated_audience_size_min
      NULL
      
      $languages
      NULL
      
      $media_type
      NULL
      
      $publisher_platforms
      NULL
      
      $search_page_ids
      [1] "['123']"
      
      $search_terms
      NULL
      
      $search_type
      NULL
      
      $limit
      [1] 1000
      
      $fields
      [1] "id,page_name,estimated_audience_size"
      

