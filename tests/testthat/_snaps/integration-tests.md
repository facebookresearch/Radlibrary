# searching by keyword works as expected

    Code
      dplyr::glimpse(search_by_keyword)
    Output
      Rows: 10
      Columns: 15
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

# searching by page_id as expected

    Code
      dplyr::glimpse(search_by_page)
    Output
      Rows: 10
      Columns: 15
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

