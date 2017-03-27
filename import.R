### Import 

import_hse = function(){
  
  cat("Importing benefits \n")
  benefits = read.csv("../data/import/benefits_live_2017_02_07.csv", fileEncoding="latin1", stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("", "^\\s+$", "N/A", "N / A", "na", "n/a", "n / a"))
  cat("Importing ctax \n")
  ct = read.csv("../data/import/ctax_live_2017_02_03.csv", stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("", "^\\s+$", "N/A", "N / A", "na", "n/a", "n / a"))
  cat("Importing llr \n")
  llr = read.csv("../data/import/full_landlord_register_2017_02_02.csv", stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("", "^\\s+$", "N/A", "N / A", "na", "n/a", "n / a"))
  cat("Importing llr_uprn \n")
  llr_uprn = read.csv("../data/import/louise_gprop_2017_02_22.csv", stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("", "^\\s+$", "N/A", "N / A", "na", "n/a", "n / a"))
  cat("Importing finref_uprn \n")
  finref_uprn = read.csv("../data/import/academy_uprn_lookup_2017_02_06.csv", stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("", "^\\s+$", "N/A", "N / A", "na", "n/a", "n / a"))
  cat("Importing schedule and owner_codes")
  schedule_codes = read.csv("../data/import/schedule_codes.csv", stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("", "^\\s+$", "N/A", "N / A", "na", "n/a", "n / a"))
  owner_codes = read.csv("../data/import/owner_codes.csv", stringsAsFactors = FALSE, strip.white = TRUE, na.strings = c("", "^\\s+$", "N/A", "N / A", "na", "n/a", "n / a"))
  
  return(list(benefits = benefits, ct=ct, llr=llr, llr_uprn=llr_uprn, finref_uprn = finref_uprn, schedule_codes=schedule_codes, owner_codes=owner_codes))
  
}