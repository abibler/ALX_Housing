get_ACS <- function(vars, geo, start_year, stop_year, vintage) {
  
  out_tibble <- tibble()
  
  years <- seq(from = start_year, to = stop_year)
  
  for (year in years) {
    query <- paste0("https://api.census.gov/data/",
                    year,
                    "/acs/acs",
                    vintage,
                    "?get=",
                    vars,
                    "&for=",
                    geo)
    myJSON <- fromJSON(query)
    myTibble <- as_tibble(myJSON)
    myTibble <- janitor::row_to_names(myTibble,1)
    myTibble <- myTibble %>% mutate(year = year)
    
    out_tibble <- rbind(out_tibble, myTibble)
  }
  
  return(out_tibble)
}

