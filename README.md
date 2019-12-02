# adlibrary

<!-- badges: start -->
<!-- badges: end -->

The `adslibrary` package is for querying the Facebook Ad Library API.

## Installation

Use devtools to install with

``` r
devtools::install_github("path/to/repo")
```

## Setup

There are a few steps you need to complete in order to use the Facebook Ad Library API. These
steps are described [here](https://www.facebook.com/ads/library/api/?source=archive-landing-page).

Once you've completed these steps, you can constuct a query like this.


## Examples

You can construct a query to the API using adlib_build_query()

``` r
library(adslibrary)
## get all ads that mention "mark" or "zuckerberg" that had impressions yesterday in the US and are currently active
query <- adlib_build_query(ad_reached_countries = 'US', ad_active_status = 'ACTIVE', impression_condition = 'HAS_IMPRESSIONS_YESTERDAY', search_terms = "mark zuckerberg")
```

To send your query to the API, use adlib_get. You'll need an access token.

```
token <- "PASTED VALUE FROM https://developers.facebook.com/tools/explorer/"
result <- adlib_get(query, token = token)
```

By default, this will return up to 5000 rows containing all available ad data matching the query. The function `adlib_response_to_tables` can turn the API response into a list of tables.

1. The `ad_table` contains one row per ad from the response, contains data bout each ad such as when it started, who is paying for it, and how much they have spent, and how many impressions it has received.
2. The `demographic_table` contains a demographic breakdown of ad viewers, with one row per pair of (age bucket, gender), per ad.
3. The `region_table` contains a breakdown of where each ad was viewed, with one row per `ad_id` and `region`.

``` r
> adlib_response_to_tables(result) %>% map(head)
# $ad_table
# # A tibble: 6 x 15
#   ad_creation_time    ad_creative_body ad_creative_lin… ad_creative_lin… ad_creative_lin… ad_delivery_start_… ad_delivery_stop_t…
#   <dttm>              <chr>            <chr>            <chr>            <chr>            <dttm>              <dttm>             
# 1 2019-10-22 20:36:32 "Breaking news:… my.elizabethwar… It’s time to br… Mark Zuckerberg… 2019-10-22 20:36:32 NA                 
# 2 2019-10-22 20:36:32 "Breaking news:… my.elizabethwar… It’s time to br… Mark Zuckerberg… 2019-10-22 20:36:32 NA                 
# 3 2019-10-22 20:36:32 "Breaking news:… my.elizabethwar… It’s time to br… Mark Zuckerberg… 2019-10-22 20:36:32 NA                 
# 4 2019-10-22 20:36:32 "Breaking news:… my.elizabethwar… It’s time to br… Mark Zuckerberg… 2019-10-22 20:36:32 NA                 
# 5 2019-10-22 20:36:32 "Breaking news:… my.elizabethwar… It’s time to br… Mark Zuckerberg… 2019-10-22 20:36:32 NA                 
# 6 2019-10-22 20:36:32 "Breaking news:… my.elizabethwar… It’s time to br… Mark Zuckerberg… 2019-10-22 20:36:32 NA                 
# # … with 8 more variables: currency <chr>, funding_entity <chr>, page_id <chr>, page_name <chr>, spend <chr>, ad_id <chr>,
# #   impressions <chr>, ad_snapshot_url <chr>
# 
# $demographic_table
# # A tibble: 6 x 4
#   percentage age   gender  ad_id          
#        <dbl> <chr> <chr>   <chr>          
# 1    0.0810  45-54 female  392500995026671
# 2    0.0688  35-44 male    392500995026671
# 3    0.00166 45-54 unknown 392500995026671
# 4    0.00122 55-64 unknown 392500995026671
# 5    0.00259 35-44 unknown 392500995026671
# 6    0.00497 25-34 unknown 392500995026671
# 
# $region_table
# # A tibble: 6 x 3
#   percentage region        ad_id          
#        <dbl> <chr>         <chr>          
# 1   0.000006 Unknown       392500995026671
# 2   0.0337   Pennsylvania  392500995026671
# 3   0.0139   Nevada        392500995026671
# 4   0.00331  New Hampshire 392500995026671
# 5   0.0205   New Jersey    392500995026671
# 6   0.00978  New Mexico    392500995026671

```
