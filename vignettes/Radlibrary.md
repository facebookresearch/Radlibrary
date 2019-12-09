

---
title: "Getting started with `Radlibrary`"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Usage and migration}
  %\VignetteEngine{knitr::knitr}
  %\VignetteEncoding{UTF-8}
---

```
{r, include = FALSE, echo = FALSE}
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>")
```

## Introduction

This vignette serves two distinct, but related, purposes:

* It exhaustively documents the steps required to get started with the Facebook 
  Ad Library API. 
  
* It walks through getting started with the `Radlibrary` package to query, analyze, 
  and visualize data from the Facebook Ad Library API 

## Getting Setup 

There are three basic steps required to begin used the Facebook Ad Library API. 

1. Confirm your identity and location
2. Create a Facebook Developer account
3. Add a new app
 
 
### Confirm your identity and location with Facebook

Currently, accessing the Facebook Ads API utilizes the same verification process that is required to run ads about social issues, electioncs or politics. To complete this process, go to [the ID section of your Facebook settings](https://www.facebook.com/ID). To complete this process, you will need a form of national identification to confirm your identity. If you haven't already confirmed your ID, it typically takes 1-2 days to complete this step.

**Note**: You'll need a form of ID that matches the country(ies) you are interested in analyzing via the API. 

### Create a Facebook Developer account 

Visit [Facebook for Developers](https://developers.facebook.com/) and select Get Started. As part of account creation, you'll need to agree to our Platform Policy.

### Add a new App

Once you have an account, you'll need to create a new app. You'll need your `App ID` and `App Secret` in order to access the API. 

**Note**: The `App ID` and `App Secret` tokens allow anyone in possession of them to potentially access your personal Facebook account. Take caution to protect this information! The `Radlibrary` package contains support for the `keyring` package to facilitate more secure analysis. **Do not post your `App ID` and `App Secret` to Github**. 

## Getting Started 

To get started using the `Radlibrary` package, you'll want to take the following steps: 

1. Retrive and store your App token to access the API. 
2. Build a query. 
3. Submit the query. 
4. Analyze the results. 

### Retrieve and store your App token. 

There are two ways to do this: manually (**not recommended!**) or via the support for the `keychain` package within `Radlibrary`. The `keychain` package is a platform independent 'API' to access the operating system's credential store. It currently supports: 'Keychain' on 'macOS', Credential Store on 'Windows', the Secret Service 'API' on 'Linux'. **tl;dr** - this is the **preferred* method for analysis as it does not require you to place your API credentials into your code. We'll be focusing on the `keychain` method.

To begin: 

```
{r, include = FALSE}
library(Radlibrary)
adlib_setup()
```

If you've already stored an Application ID at this point, you'll receive a prompt as to whether or not you'd like to overwrite your previously stored Application ID. 

If you haven't - you'll receive the following prompt: 
```
Visit https://developers.facebook.com/ and navigate to your App's basic settings
to find your Application ID and App Secret.
These will be securely stored in your computer's credential store.
Press <Enter>
```

You'll then be asked via prompt to access and input your Application ID and your App Secret. Storing this will be sufficient
for analyis. If you'd like to set a longterm token for use up for up to sixty days, run the `adlib_set_longterm_token()` command and follow the prompts. 

### Build a query 

Let's build our first query! 

To begin, let's use an easy example. Let's look for all active ads within the United States that served impressions in the past 90 days and are related to health care. 

```{r, eval = false} 
query <- adlib_build_query(ad_reached_countries = 'US', 
ad_active_status = 'ACTIVE', 
impression_condition = 'HAS_IMPRESSIONS_LAST_90_DAYS', 
search_terms = "healthcare")
```

### Submit a query 

Let's submit the query from the previous section for analysis. 

```{r} 
response <- adlib_get(query, token = token_get())
```

The `adlib_get()` function will return an object type of "adlib_data_response" - the output of the API call. 
