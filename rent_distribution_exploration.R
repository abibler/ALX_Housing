# Get the 2019 Rent distributions
rent19 <- get_ACS("group(B25063)","us",2019,2019)

# I want this table over time but the 2016 table has duplicate 
# values. So I extract the colnames
rent_vars_of_interest <- rent19 %>% select (NAME,
                                            (ends_with("E") & starts_with("B")))
  
x <- colnames(rent_vars_of_interest)

cols <- ""

for (i in 1:length(x)) {
  if (i < length(x)) {
    cols <- paste0(cols, x[i], ",")
  }
  else {
    cols <- paste0(cols, x[i])
  }
}

# Now get the time series passing the var names instead of
# the group option.
rent <- get_ACS(cols,"county:510&in=state:51",2015,2019,5)

min <- c(0, seq(100, 800, by = 50), 900, 1000,
         1250, 1500, 2000, 2500, 3000, 3500)

max <- c(99, seq(149, 799, by = 50), 899, 999,
         1249, 1499, 1999, 2499, 2999, 3499, 9999)

rent50 <- calc_ptile(rent, .5, min, max, 2)
rent25 <- calc_ptile(rent, .25, min, max, 2)

rent_ests <- cbind(select(rent, NAME, year), rent50, rent25)

# The older data has fewer columns
x <- colnames(rent_vars_of_interest[1:25])

cols <- ""

for (i in 1:length(x)) {
  if (i < length(x)) {
    cols <- paste0(cols, x[i], ",")
  }
  else {
    cols <- paste0(cols, x[i])
  }
}

rent <- get_ACS(cols,"county:510&in=state:51",2009,2014,5)

min <- c(0, seq(100, 800, by = 50), 900, 1000,
         1250, 1500, 2000)

max <- c(99, seq(149, 799, by = 50), 899, 999,
         1249, 1499, 1999, 9999)

rent50 <- calc_ptile(rent, .5, min, max, 2)
rent25 <- calc_ptile(rent, .25, min, max, 2)
rent_ests_old <- cbind(select(rent, NAME, year), rent50, rent25)
rent_ests <- rbind(rent_ests, rent_ests_old)

rent_ests <- rent_ests %>% mutate(med_over_25 = est_50p / est_25p)

save(rent_ests, file = "alx_rent_ests.Rda")
