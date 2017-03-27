### Analysis
hse_joined = import_hse() %>% process_hse() %>% join_hse()

ct_merged = hse_joined$ct_merged

### Steps from Jan

## 1. Tenure - Newly created

## 2. Tenure - Confirmed GHA

## 3. Tenure - benefits tunure = GHA, GHA RTB, RTB Sasines

## 4. Tenure A




### Steps from Alan

## 1. If no owner data OR no schedule data -> tenure = Owner Occupier

## 2. If there is owner or schedule data AND its not HA, Council or MOD -> tenure = Private Landlord

## 3. If Owner name IS liable name -> tenure = Owner occupier UNLESS it has an unoccupied allowance

## 4. If it has an unoccupied allowance -> tenure = Private landlord (reasonable assumption)

## 5. Note- schedule accounts (education / social work) may be occupied by tenants but landlord names liable - because they pay for it

## 6. Tenure from benefits takes priority over all the above


### My steps

### Set up columns
ct_merged$hse_llr_tenure = NA
ct_merged$hse_ct_tenure = NA
ct_merged$hse_hb_tenure = NA
ct_merged$hse_final_tenure = NA

## 1. LLR - Are they on the landlords register? -> private let - 49,845
ct_merged = ct_merged %>% mutate(hse_llr_tenure = replace(hse_final_tenure, !is.na(LLR_registration_number), "pll"))

## 2. CT unoccupied allowance = y -> PLL - 8109
ct_merged = ct_merged %>% mutate(hse_ct_tenure = ifelse(CT_unoccupied_allowance == "y", "pll", hse_ct_tenure))

## 3. CT Owner name == liable name & unoccupied allowance == "n" -> "OO" - 36,615 total
ct_merged = ct_merged %>% mutate(hse_ct_tenure = ifelse((CT_lead_name == CT_owner_name & CT_unoccupied_allowance == "n"), "oo", hse_ct_tenure))

## 4. CT - no owner or schedule data from CT & no LLR code -> owner occupier - 98,944 (746 clashes with HB tenure field != owner occupier)
ct_merged = ct_merged %>% mutate(hse_ct_tenure = ifelse(is.na(CT_owner_code) & is.na(CT_schedule_code) & is.na(LLR_registration_number) & is.na(CT_owner_name) & is.na(CT_schedule_name), "oo", hse_ct_tenure))

## 5. CT - Use owner and schedule codes tenure, owner codes taking preference - 108,445 owner codes, 12,710 schedule, 3693 overlapping
ct_merged = ct_merged %>% mutate(hse_ct_tenure = ifelse(!is.na(CT_schedule_code), CT_schedule_code_tenure, hse_ct_tenure)) 
ct_merged = ct_merged %>% mutate(hse_ct_tenure = ifelse(!is.na(CT_owner_code), CT_owner_code_tenure, hse_ct_tenure)) 

## 6. HB tenure = Owner occupier -> owner occupier - 97,219 total
hb_list = list("ha" = "ha", "hac"="ha", "owner occupier" = "oo", "private landlord" = "pll", "vo-s"="vo-s")
ct_merged[!is.na(ct_merged$HB_tenure),] = ct_merged %>% filter(!is.na(HB_tenure)) %>% mutate(hse_hb_tenure = as.character(hb_list[HB_tenure]))

## 7. Merge them into final
ct_merged = ct_merged %>% mutate(hse_final_tenure = hse_hb_tenure) %>% mutate(hse_final_tenure = ifelse(is.na(hse_final_tenure), hse_ct_tenure, hse_final_tenure)) %>% mutate(hse_final_tenure = ifelse(is.na(hse_final_tenure), hse_llr_tenure, hse_final_tenure))

### other things to look at

### Where HB says private landlord but they are not on the landlord register

### HB says owner occupier but they are on the landlords register

### CT owner code exists
