# Radlibrary 0.5.0
* Added support for new fields available for ads delivered to the EU
  * `age_country_gender_reach_breakdown`: Demographic distribution of ads delivered to the EU by country, gender, and age
  * `beneficiary_payers`: Reported beneficiaries and payers for the ad
  * `eu_total_reach`: The estimated combined ad reach for all locations inside the European Union
  * `target_ages`: The age ranges selected for ad targeting in the EU.
  * `target_gender`: The genders selected for ad targeting in the EU.
  * `target_locations`: The locations included or excluded for ad targeting in the EU.
* Added support for controlling whether to include ads that are removed for community
  standards violations (`unmask_removed_content`)
* Various small bug fixes and updates and more tests

# Radlibrary 0.4.3
* Very minor bug fix to make R CMD Check pass
  * there has been a line that was checking whether something was an instance of a class in the wrong way

# Radlibrary 0.4.2
* Fixed an issue where searches by `page_id` were returning fewer than expected results.

# Radlibrary 0.4.1
* Fix some documentation issues
* Update the nested columns vignette

# Radlibrary 0.4.0

## New Fields

The [Ad Library API](https://www.facebook.com/ads/library/api/?source=nav-header) provides more data than it used to, and now `Radlibrary` can handle it. All of the current fields are supported, which at this time include:

-  id
-  ad_creation_time
-  ad_creative_bodies
-  ad_creative_link_captions
-  ad_creative_link_descriptions
-  ad_creative_link_titles
-  ad_delivery_start_time
-  ad_delivery_stop_time
-  ad_snapshot_url
-  bylines
-  currency
-  estimated_audience_size
-  impressions
-  languages
-  page_id
-  page_name
-  publisher_platforms
-  spend
-  demographic_distribution
-  delivery_by_region

## Nested Columns

The Ad Library API has evolved to return richer data for some fields which may be multi-valued. For instance, the `publisher_platform` field can contain multiple values: Facebook, Instagram, etc. Converting responses to a tibble now makes these into list columns.

Similarly, some values like `demographic_distribution` and `delivery_by_region` return very rich data. Previously, it was necessary to request this data separately as a `geo_table` or `demographic_table`. Now these values are converted into nested tibble columns. See `vignette("nested_columns")` for more.

## Other small-to-medium changes

- Ads now have a unique identifier simply called `id`. This is now the favored unique identifier rather than `ad_snapshot_url`, which was previously a required field in all calls to the API.
- Converting a data response to `tibble` will no longer create a whole bunch of unused columns for fields that weren't requested. Only the fields that were requested are included now.


# Radlibrary 0.3.0
* Added ability to filter for potential reach
* Added date filters
* Removed some deprecated fields
* Bug fixes

# Radlibrary 0.2.5
* Fixed an issue where ad tables couldn't be created when spend and impressions
were not requested
* Require ad_snapshot_url to be present in all queries

# Radlibrary 0.2.4
* Fixed getPass bug in Rstudio server
* Only warn once about environment variables on Linux
* fix typos in docs

# Radlibrary 0.2.3
* improve docs
* pass rhub windows build check

# Radlibrary 0.2.2
* bug fixes
* table types vignette

# Radlibrary 0.2.1
* tests and bugfixes
* improved documentation

# Radlibrary 0.2.0
* CI is set up and passes
* API Requests set the user agent to Radlibrary
* Access tokens are censored in URLs by default
* Spend and Impressions columns have numeric upper and lower bounds
* Documentation
* Bug fixes

# Radlibrary 0.1.0
* Secrets are stored securely in keychain
* Requests return data_objects that can be converted to tibbles
* Paginated API requests built
* A bunch of documentation

# Radlibrary 0.0.0.9001

* Added a `NEWS.md` file to track changes to the package.
