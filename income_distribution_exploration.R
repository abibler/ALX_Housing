
income <- get_ACS("group(B25118)","county:510&in=state:51",2009,2019,5)
renter_income <- income[,53:105]

min <- c(seq(0, 25000, by = 5000), 35000, 50000, 75000, 100000, 150000)
max <- c(seq(4999, 24999, by = 5000), 34999, 49999, 74999, 99999, 149999, 999999)

income50 <- calc_ptile(renter_income, .5, min, max, 1)
income25 <- calc_ptile(renter_income, .25, min, max, 1)

income_ests <- cbind(select(income, NAME, year), income50, income25)

income_rent <- full_join(income_ests, rent_ests, by = c("NAME","year"))
income_rent <- rename(income_rent, income_50p = est_50p.x,
                income_25p = est_25p.x,
                rent_50p = est_50p.y,
                rent_25p = est_25p.y)

income_rent <- income_rent %>% mutate(monthly_rent_inc_50 = rent_50p/(income_50p/12),
                                      monthly_rent_inc_25 = rent_25p/(income_25p/12))

ggplot(data = income_rent, aes(x = year)) +
  geom_line(aes(y = monthly_rent_inc_50)) +
  geom_line(aes(y = monthly_rent_inc_25))
write.csv(income_rent, file = "alx_income_rent.csv")
