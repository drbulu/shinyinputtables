# avoids issues with JSON processing that fail
# on numeric input!
decodeEventJSON <- function(eventJSON){
  eventData <- jsonlite::fromJSON(eventJSON)
  lapply(X = eventData, FUN = function(x){
    ifelse(is.finite(x), 
           as.numeric(utils::URLdecode(as.character(x))),
           utils::URLdecode(x))
  })
}

