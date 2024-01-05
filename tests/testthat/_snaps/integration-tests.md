# searching by keyword works as expected

    Code
      dplyr::glimpse(search_by_keyword)
    Output
      Rows: 10
      Columns: 21
      $ id                            <chr> "1585169241848220", "227087796152525", "~
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
      $ languages                     <list> "en", "en", "en", "en", "en", "en", "en~
      $ page_id                       <chr> "123192635089", "123192635089", "1231926~
      $ page_name                     <chr> "GOP", "GOP", "GOP", "Rep. John Leavitt"~
      $ publisher_platforms           <list> "facebook", "facebook", "facebook", <"f~
      $ estimated_audience_size_lower <dbl> 1000001, 1000001, 1000001, 1000001, 5000~
      $ estimated_audience_size_upper <dbl> NA, NA, NA, NA, 1e+05, NA, NA, NA, NA, NA
      $ impressions_lower             <dbl> 5e+03, 4e+03, 4e+03, 0e+00, 0e+00, 4e+03~
      $ impressions_upper             <dbl> 5999, 4999, 4999, 999, 999, 4999, 14999,~
      $ spend_lower                   <dbl> 0, 0, 0, 0, 0, 0, 0, 1000, 0, 0
      $ spend_upper                   <dbl> 99, 99, 99, 99, 99, 99, 99, 1499, 99, 99

# searching by page_id as expected

    Code
      dplyr::glimpse(search_by_page)
    Output
      Rows: 10
      Columns: 21
      $ id                            <chr> "818493392655713", "1748030902223715", "~
      $ ad_creation_time              <chr> "2022-09-26", "2022-09-26", "2022-09-26"~
      $ ad_creative_bodies            <list> "We're making a huge investment in chip~
      $ ad_creative_link_captions     <list> "mlive.com", "gretchenwhitmer.com", "gr~
      $ ad_creative_link_descriptions <list> "“We’re showing the world what Michigan~
      $ ad_creative_link_titles       <list> "Whitmer Celebrates $300M Semiconductor~
      $ ad_delivery_start_time        <chr> "2022-09-26", "2022-09-26", "2022-09-26"~
      $ ad_delivery_stop_time         <chr> "2022-10-22", "2022-10-16", "2022-10-16"~
      $ ad_snapshot_url               <chr> "https://www.facebook.com/ads/archive/re~
      $ bylines                       <chr> "Gretchen Whitmer for Governor", "Gretch~
      $ currency                      <chr> "USD", "USD", "USD", "USD", "USD", "USD"~
      $ languages                     <list> "en", "en", "en", "en", "en", "en", "en~
      $ page_id                       <chr> "673117639774135", "673117639774135", "6~
      $ page_name                     <chr> "Gretchen Whitmer", "Gretchen Whitmer", ~
      $ publisher_platforms           <list> <"facebook", "instagram">, <"facebook",~
      $ estimated_audience_size_lower <dbl> 1000001, 1000001, 1000001, 100001, 10000~
      $ estimated_audience_size_upper <dbl> NA, NA, NA, 5e+05, NA, 5e+05, NA, NA, NA~
      $ impressions_lower             <dbl> 1000000, 250000, 1000000, 15000, 1000000~
      $ impressions_upper             <dbl> NA, 299999, NA, 19999, NA, 699999, 29999~
      $ spend_lower                   <dbl> 40000, 3500, 50000, 400, 50000, 10000, 3~
      $ spend_upper                   <dbl> 44999, 3999, 59999, 499, 59999, 14999, 3~

