

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
 
 
### Confirm your identity and location (with Facebook) 

Currently, accessing the Facebook Ads API utilizes the same verification process that is required to run ads about social issues, electioncs or politics. To complete this process, go to [the ID section of your Facebook settings](https://www.facebook.com/ID). To complete this process, you will need a form of national identification to confirm your identity. If you haven't already confirmed your ID, it typically takes 1-2 days to complete this step.

**Note**: You'll need a form of ID that matches the country(ies) you are interested in analyzing via the API. 

### Create a Facebook Developer account 

Visit [Facebook for Developers](https://developers.facebook.com/) and select Get Started. As part of account creation, you'll need to agree to our Platform Policy.

### Add a new App

Once you have an account, you'll need to create a new app. You'll need your `App ID` and `App Secret` in order to access the API. 

**Note**: The `App ID` and `App Secret` tokens allow anyone in possession of them to potentially access your personal Facebook account. Take caution to protect this information! The `Radlibrary` package contains support for the `keyring` package to facilitate more secure analysis. **Do not post your `App ID` and `App Secret` to Github**. 

