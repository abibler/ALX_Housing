library(jsonlite)
library(tidyverse)

years <- seq(from = 2005, to = 2019)
out_tibble <- tibble()

for (year in years) {

  # query <- paste0("https://api.census.gov/data/",year,"/acs/acs1?get=group(B25064),GEOCOMP&for=county:510&in=state:51")
  query <- paste0("https://api.census.gov/data/",year,"/acs/acs1?get=NAME,B25064_001E,B25064_001M,B25119_003E,B25119_003M,GEOCOMP&for=county:510&in=state:51")
  
  myJSON <- fromJSON(query)
  
  myTibble <- as_tibble(myJSON)
  myTibble <- janitor::row_to_names(myTibble,1)
  myTibble <- myTibble %>% mutate(year = year)
  
  out_tibble <- rbind(out_tibble, myTibble)
}

rent_income_alx <- out_tibble %>% 
  mutate(rent_to_income = as.numeric(B25064_001E) / (as.numeric(B25119_003E)/12))

for (year in years) {
  
  # query <- paste0("https://api.census.gov/data/",year,"/acs/acs1?get=group(B25064),GEOCOMP&for=county:510&in=state:51")
  query <- paste0("https://api.census.gov/data/",year,"/acs/acs1?get=NAME,B25064_001E,B25064_001M,B25119_003E,B25119_003M,GEOCOMP&for=us")
  
  myJSON <- fromJSON(query)
  
  myTibble <- as_tibble(myJSON)
  myTibble <- janitor::row_to_names(myTibble,1)
  myTibble <- myTibble %>% mutate(year = year)
  
  out_tibble <- rbind(out_tibble, myTibble)
}

rent_income_us <- out_tibble %>% 
  mutate(rent_to_income = as.numeric(B25064_001E) / (as.numeric(B25119_003E)/12))
