# Parsing responses works correctly

    Code
      data_response$fields
    Output
       [1] "id"                            "ad_creation_time"             
       [3] "ad_creative_bodies"            "ad_creative_link_captions"    
       [5] "ad_creative_link_descriptions" "ad_creative_link_titles"      
       [7] "ad_delivery_start_time"        "ad_delivery_stop_time"        
       [9] "ad_snapshot_url"               "bylines"                      
      [11] "currency"                      "estimated_audience_size"      
      [13] "impressions"                   "languages"                    
      [15] "page_id"                       "page_name"                    
      [17] "publisher_platforms"           "spend"                        

# Converting to ad table works

    Code
      names(tbl)
    Output
       [1] "id"                            "ad_creation_time"             
       [3] "ad_creative_bodies"            "ad_creative_link_captions"    
       [5] "ad_creative_link_descriptions" "ad_creative_link_titles"      
       [7] "ad_delivery_start_time"        "ad_delivery_stop_time"        
       [9] "ad_snapshot_url"               "currency"                     
      [11] "languages"                     "page_id"                      
      [13] "page_name"                     "publisher_platforms"          
      [15] "estimated_audience_size_lower" "estimated_audience_size_upper"
      [17] "impressions_lower"             "impressions_upper"            
      [19] "spend_lower"                   "spend_upper"                  
      [21] "bylines"                      

# searching by language works

    Code
      names(as_tibble(data_response))
    Output
      [1] "id"                 "languages"          "delivery_by_region"

# searching by region works

    Code
      names(as_tibble(data_response))
    Output
      [1] "id"                 "delivery_by_region"

