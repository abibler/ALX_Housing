library(jsonlite)
library(tidyverse)

rent_json <- fromJSON("https://api.census.gov/data/2019/acs/acs1?get=group(B25063)&for=us")
rent <- as.data.frame(t(rent_json[-1,]))
colnames(rent) <- t(rent_json[1,])

rent_ests <- rent %>% select(ends_with("E") & starts_with("B"))

x <- colnames(rent_ests)

cols <- ""

for (i in 1:length(x)) {
  if (i < length(x)) {
  cols <- paste0(cols, x[i], ",")
  }
  else {
    cols <- paste0(cols, x[i])
  }
}


min <- c(0, seq(100, 800, by = 50), 900, 1000,
          1250, 1500, 2000, 2500, 3000, 3500)

max <- c(99, seq(149, 799, by = 50), 899, 999,
          1249, 1499, 1999, 2499, 2999, 3499, 9999)

ptile <- as_tibble()


for (j in 1:nrow(rent_ests)) {
  tot <- 0
  med <- as.numeric(rent_ests[j,2]) * .5
  
  for (i in 3:length(colnames(rent_ests))) {
    tot <- tot + as.numeric(rent_ests[j,i])
    if (tot < med) {
  
    }
    else {
      diff <- med - (tot - as.numeric(rent_ests[j,i]))
      diff_share <- diff / as.numeric(rent_ests[j,i])
      ptile[j, 1] <- min[i-2] + diff_share * (max[i-2] - min[i-2])
      out_min <- min[i-2]
      out_max <- max[i-2]
      break
    }
  }
}

rent <- get_ACS(cols,"us",2016,2019)

rent_json19 <- fromJSON("https://api.census.gov/data/2019/acs/acs1?get=group(B25063)&for=us")
rent_json18 <- fromJSON("https://api.census.gov/data/2018/acs/acs1?get=group(B25063)&for=us")

