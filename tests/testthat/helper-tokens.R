# token_response <- readRDS("tests/testthat/token_response.rds")
# pasted_token <- readChar('shortterm_token.txt', 1e4)
token <- graph_api_token('abcd')
token2 <- structure(list(token = "efgh",
                         expiry = structure(1580159354, tzone = "GMT", class = c("POSIXct",
                                                                                 "POSIXt")), retrieved = structure(1574975354, class = c("POSIXct",
                                                                                                                                         "POSIXt"), tzone = "GMT")), class = c("graph_api_token",
                                                                                                                                                                               "list"))
