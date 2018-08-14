dmy_or_ymd <- function(data){
  # Use dmy
  suppressWarnings(
    data_dmy <- lubridate::dmy(data)
  )
  # Use_ymd
  suppressWarnings(
    data_ymd <- lubridate::ymd(data)
  )
  # Combine resullts
  if(any(is.na(data_dmy)))
    data_dmy[is.na(data_dmy)] <- data_ymd[is.na(data_dmy)]
  # Check for NA
  if(any(is.na(data_dmy)))
    stop("Could not parse date with dmy and ymd")
  # Reuturn
  return(data_dmy)
}