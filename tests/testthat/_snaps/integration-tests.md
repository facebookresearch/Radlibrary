# searching by keyword works as expected

    Code
      dplyr::glimpse(search_by_keyword)
    Output
      Rows: 10
      Columns: 21
      $ ad_creation_time              <chr> "2022-01-01", "2022-01-01", "2022-01-01"~
      $ ad_creative_bodies            <list> "🟢 𝗟𝗜𝗩𝗘 𝗣𝗢𝗟𝗟: 𝗗𝗼 𝘆𝗼𝘂 𝗮𝗽𝗽𝗿𝗼𝘃𝗲 𝗼𝗳 𝗝𝗼𝗲 𝗕𝗶~
      $ ad_creative_link_captions     <list> "gop.com", "gop.com", "gop.com", "Whats~
      $ ad_creative_link_descriptions <list> "RECORD YOUR RESPONSE NOW", "RECORD YOU~
      $ ad_creative_link_titles       <list> "RESPONSE REQUESTED", "RESPONSE REQUEST~
      $ ad_delivery_start_time        <chr> "2022-01-01", "2022-01-01", "2022-01-01"~
      $ ad_delivery_stop_time         <chr> "2022-01-01", "2022-01-01", "2022-01-02"~
      $ ad_snapshot_url               <chr> "https://www.facebook.com/ads/archive/re~
      $ bylines                       <chr> "REPUBLICAN NATIONAL COMMITTEE", "REPUBL~
      $ currency                      <chr> "USD", "USD", "USD", "USD", "USD", "USD"~
      $ estimated_audience_size_lower <dbl> 1000001, 1000001, 1000001, 1000001, 5000~
      $ estimated_audience_size_upper <dbl> NA, NA, NA, NA, 1e+05, NA, NA, NA, NA, NA
      $ id                            <chr> "1585169241848220", "227087796152525", "~
      $ impressions_lower             <dbl> 5e+03, 4e+03, 4e+03, 0e+00, 0e+00, 4e+03~
      $ impressions_upper             <dbl> 5999, 4999, 4999, 999, 999, 4999, 14999,~
      $ languages                     <list> "en", "en", "en", "en", "en", "en", "en"~
      $ page_id                       <chr> "123192635089", "123192635089", "123192~
      $ page_name                     <chr> "GOP", "GOP", "GOP", "Rep. John Leavitt"~
      $ publisher_platforms           <list> "facebook", "facebook", "facebook", <"fa~
      $ spend_lower                   <dbl> 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0
      $ spend_upper                   <dbl> 99, 99, 99, 99, 99, 99, 99, 1499, 99, 99

# searching by page_id as expected

    Code
      dplyr::glimpse(search_by_page)
    Output
      Rows: 20
      Columns: 21
      $ ad_creation_time              <chr> "2023-10-26", "2023-10-26", "2023-10-26"~
      $ ad_creative_bodies            <list> "Folks, you know I hate to ask, but her~
      $ ad_creative_link_captions     <list> "secure.actblue.com", "secure.actblue.c~
      $ ad_creative_link_descriptions <list> <NULL>, <NULL>, <NULL>, <NULL>, <NULL>,~
      $ ad_creative_link_titles       <list> "Pitch in to continue our progress", "P~
      $ ad_delivery_start_time        <chr> "2023-10-26", "2023-10-26", "2023-10-26"~
      $ ad_delivery_stop_time         <chr> "2023-11-01", "2023-10-31", "2023-10-31"~
      $ ad_snapshot_url               <chr> "https://www.facebook.com/ads/archive/re~
      $ bylines                       <chr> "BIDEN VICTORY FUND", "BIDEN VICTORY FUN~
      $ currency                      <chr> "USD", "USD", "USD", "USD", "USD", "USD"~
      $ estimated_audience_size_lower <dbl> 100001, 100001, 100001, 1000001, 1000001~
      $ estimated_audience_size_upper <dbl> 5e+05, 5e+05, 5e+05, NA, NA, NA, NA, NA,~
      $ id                            <chr> "856711792702297", "864847911928458", "3~
      $ impressions_lower             <dbl> 15000, 0, 0, 10000, 50000, 4000, 0, 1000~
      $ impressions_upper             <dbl> 19999, 999, 999, 14999, 59999, 4999, 999~
      $ languages                     <list> "en", "en", "en", "en", "en", "en", "en~
      $ page_id                       <chr> "7860876103", "7860876103", "7860876103"~
      $ page_name                     <chr> "Joe Biden", "Joe Biden", "Joe Biden", "~
      $ publisher_platforms           <list> <"facebook", "instagram">, <"facebook",~
      $ spend_lower                   <dbl> 800, 0, 0, 0, 600, 0, 0, 0, 100, 0, 0, 0~
      $ spend_upper                   <dbl> 899, 99, 99, 99, 699, 99, 99, 99, 199, 9~

