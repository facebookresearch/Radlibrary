# Radlibrary 0.4.1
* Fix some documentation issues
* Update the nested columns vignette

# Radlibrary 0.4.0
* New fields now supported including
  - ad_creative_bodies
  - ad_creative_link_captions
  - ad_creative_link_descriptions
  - delivery_by_region
  - languages
  - id
* Demographic and region delivery tables now create nested tibbles rather than having to create a completely new table
* Refactored the code that processes results to make it more extensible in case new columns are added
* Added a vignette on nested columns

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
