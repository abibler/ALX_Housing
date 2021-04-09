library(jsonlite)
library(tidyverse)

alx_fam_income <- get_ACS("B19113_001E","county:510&in=state:51",2009,2019,1)
us_fam_income <- get_ACS("B19113_001E","us",2009,2019,1)

both <- inner_join(alx_fam_income, us_fam_income, by = "year")
both <- both %>% transmute(
                        year = year,
                        alx_income = as.numeric(B19113_001E.x), 
                        nat_income = as.numeric(B19113_001E.y),
                        alx_over_nat = alx_income / nat_income)
colnames(both)
