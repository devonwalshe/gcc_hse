### Joining up attributes from datasets

join_hse = function(hse_processed){
  hse_joined = hse_processed
  
  ### Add llr uid to finref lookup
  hse_joined$finref_uprn$llr_uid = hse_joined$llr_uprn$llr_uid_full[match(hse_joined$finref_uprn$UPRN, hse_joined$llr_uprn$uprn_2017)]
  
  ### Add benefits to ct
  hse_joined[["ct_merged"]] = merge(hse_joined$ct, hse_joined$benefits, by="property_ref", all.x=TRUE)
  
  ### Add uprn and prop ref to ct
  hse_joined$ct_merged = merge(hse_joined$ct_merged, hse_joined$finref_uprn, by.x="property_ref", by.y="FIN_REF", all.x=TRUE)
  
  ### add llr to ct
  hse_joined$ct_merged = merge(hse_joined$ct_merged, hse_joined$llr, by.x="llr_uid", by.y="uid_full", all.x=TRUE)
  
  ### rename and reorder columns
  colnames(hse_joined$ct_merged)[3:28] = paste("CT_", colnames(hse_joined$ct_merged)[3:28], sep="")
  colnames(hse_joined$ct_merged)[29:45] = paste("HB_", colnames(hse_joined$ct_merged)[29:45], sep="")
  colnames(hse_joined$ct_merged)[47:57] = paste("LLR_", colnames(hse_joined$ct_merged)[47:57], sep="")  
  
  hse_joined$ct_merged = hse_joined$ct_merged[,c(which(names(hse_joined$ct_merged) %in% c("llr_uid", "uid_truncated", "property_ref", "UPRN")), grep("CT", names(hse_joined$ct_merged)), grep("HB", names(hse_joined$ct_merged)), grep("LLR", names(hse_joined$ct_merged)))]
  
return(hse_joined)
}