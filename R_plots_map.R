#install.packages("ggplot2")
#install.packages("rjson")
#install.packages("jsonlite")
#install.packages("RCurl")
#install.packages("httr")
#install.packages("data.table")
#install.packages("tidyverse")
#install.packages("stringi")

library(rjson);library(jsonlite);library(RCurl)
library(dplyr); library(httr); library(data.table); library(tidyverse)
library(ggplot2); library(tidyr);library(stringi)

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

str(df)