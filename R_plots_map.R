library(rjson);library(RCurl);library(httr);
library(dplyr);  library(data.table); library(tidyverse)
library(stringi)

URL <- "https://covid19.patria.org.ve/api/v1/summary"

# create dataframe
x <- getURL(URL)
df <- data.frame(t(fromJSON(x) %>% as.data.frame))
setDT(df, keep.rownames = TRUE)[]
names(df)[]<- c('descrip', 'Count')

# subset
total <- df[1]
byAge <- df[2:11]
byGender <- df[12:13]
byState <- df[14:38]
Count <- df[39:41]

#State
byState$descrip <- str_remove(byState$descrip, "Confirmed.ByState.")
byState$descrip <- gsub("\\.", " ", byState$descrip)
byState$descrip <- gsub("\\La Guaira", "Vargas", byState$descrip)
byState$descrip <- stri_trans_general(byState$descrip, "Latin-ASCII")
#add latitude
stateLL<- read.csv(file = 'StateVzla.csv')
names(stateLL)[1]<- c('descrip')
# order
byState <- byState[order(descrip),]

data <- merge(byState, stateLL, by = "descrip")
names(data)[3:4]<- c('lat','lng')

library(leaflet)

bound <- data.frame(quantile(data$Count))
names(bound)[1] <- "quantile"

getColor <- function(bound) {
  sapply(bound$quantile, function(bound) {
    if(bound <= 5) {
      "green"
    } else if(bound <= 1060) {
      "orange"
    } else {
      "red"
    } })
}

icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = getColor(bound)
)


data %>%
  leaflet() %>%
  addTiles() %>% 
  addAwesomeMarkers(lat = data$lat, lng=data$lng,icon=icons, popup=as.character(data$Count))

