calc_ptile <- function(data, ptile, min, max, tot_column) {
  
  rent_ests <- data %>% select(ends_with("E") & starts_with("B"))
  
  out_tibble <- as_tibble()
  start_col <- tot_column + 1
  
    for (j in 1:nrow(rent_ests)) {
      tot <- 0
      med <- as.numeric(rent_ests[j, tot_column]) * ptile
      
      for (i in start_col:length(colnames(rent_ests))) {
        tot <- tot + as.numeric(rent_ests[j,i])
        if (tot < med) {
        }
        else {
          diff <- med - (tot - as.numeric(rent_ests[j,i]))
          diff_share <- diff / as.numeric(rent_ests[j,i])
          out_tibble[j, 1] <- min[i-tot_column] + diff_share * (max[i-tot_column] - min[i-tot_column])
          out_min <- min[i-tot_column]
          out_max <- max[i-tot_column]
          break
        }
      }
    }
  colnames(out_tibble) <- c(paste0("est_", ptile * 100,"p"))
  return(out_tibble)
}


