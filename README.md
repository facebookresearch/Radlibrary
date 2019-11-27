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
