### process

process_hse = function(hse_raw){
  ### Local HSE list
  hse_processed = hse_raw
  
  ### Trim and tolower everything
  hse_processed = lapply(hse_processed, function(x) import_string_normalize(x))
  cat("*** All Datasets string normalized \n")
  
  ### Process them
  cat("Processing schedule and owner codes \n")
  hse_processed = process_codes(hse_processed)
  
  cat("Processing benefits \n")
  benefits_processed = process_benefits(hse_processed$benefits)
  cat("Processing ctax \n")
  ct_processed = process_ct(hse_processed$ct)
  cat("Processing llr \n")
  llr_processed = process_llr(hse_processed$llr)
  cat("Processing llr_uprn \n")
  llr_uprn_processed = process_llr_uprn(hse_processed$llr_uprn)
  cat("Processing uprn_finref \n")
  finref_uprn_processed = process_finref_uprn(hse_processed$finref_uprn)

  
  cat("Finished processing HSE datasets \n")
  return(list(benefits = benefits_processed, ct=ct_processed, llr = llr_processed, llr_uprn = llr_uprn_processed, finref_uprn=finref_uprn_processed))
}

process_benefits = function(benefits){
  benefits_processed = benefits
  
  return(benefits_processed)  
}

process_ct = function(ct){
  ct_processed = ct
  

  
  ### Seperate street number
  street_n_filter = ""
  street_n_select = ""
  flat_cols = regex_filter_and_extract()
  
  ### Colnames
  colnames(ct_processed) = c("property_ref", "lead_name", "street", "addr1", "addr2", "addr3", "addr4", "postcode", "owner_code", "owner_name", "owner_addr1", "owner_addr2", "owner_addr3", "owner_addr4", "owner_postcode", "schedule_code", "schedule_name", "schedule_addr1", "schedule_addr2", "schedule_addr3", "schedule_addr4", "schedule_postcode", "unoccupied_allowance", "disc_type", "allowance", "owner_code_tenure", "schedule_code_tenure")
  
  
  return(ct_processed)  
}

process_llr = function(llr){
  llr_processed = llr
  
  #Colnames
  colnames(llr_processed) = c("registration_number", "registration_status", "renewal_status", "id", "prop_number", "address1", "address2", "address3", "town", "postcode")
  
  ### Add UIDs for registration number
  llr_processed$uid_full = paste(llr_processed$registration_number, llr_processed$id)
  llr_processed$uid_truncated = paste(gsub("\\/\\d+$", "", llr_processed$registration_number), llr_processed$id)
  
  return(llr_processed)  
}

process_llr_uprn = function(llr_uprn){

  llr_uprn_processed = llr_uprn
  
  ### remove unneeded cols -> Taken out a lot of the finance ones and the matching criteria from address base. 
  llr_uprn_processed = llr_uprn_processed %>% select(-match(c("OID_"), names(llr_uprn_processed)))
  
  ### colnames
  colnames = c("registration_number", "registration_status", "id", "address1", "address2", "address3", "town", "postcode", "uprn_2016", "uprn_2017")
  colnames(llr_uprn_processed) = colnames
  
  ### convert uprn_2017 to string
  llr_uprn_processed$uprn_2017 = as.character(llr_uprn_processed$uprn_2017)
  
  ### Add uid
  llr_uprn_processed$llr_uid_full = paste(llr_uprn_processed$registration_number, llr_uprn_processed$id)
  llr_uprn_processed$llr_uid_truncated = paste(gsub("\\/\\d+$", "", llr_uprn_processed$registration_number), llr_uprn_processed$id)
  
  
  return(llr_uprn_processed)
  
}

process_finref_uprn = function(finref_uprn){
  finref_uprn_processed = finref_uprn
  
  ### string uprn
  finref_uprn_processed[,c("FIN_REF", "UPRN")] = lapply(finref_uprn_processed[,c("FIN_REF", "UPRN")], function(x) as.character(x))
  
  return(finref_uprn_processed)  
}

process_codes = function(hse_processed){
  
  ### Add schedule and owner tenure to ct
  
  ### Owner code tenure
  hse_processed$ct$owner_code_tenure = hse_processed$owner_codes$Tenure[match(hse_processed$ct$owner_code, hse_processed$owner_codes$Owner.Code)]
  
  ### Schedule code tenure 
  hse_processed$ct$schedule_code_tenure = hse_processed$schedule_codes$Tenure[match(hse_processed$ct$schedule_code, hse_processed$schedule_codes$Code)]
  
  ## Return 
  return(hse_processed)
}