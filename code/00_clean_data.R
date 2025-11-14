here::i_am(
  "code/00_clean_data.R"
)
f75 <- read.csv (here::here('f75_dataset/f75_interim.csv'))
#alive=1, died=0
f75$final_status <- ifelse(f75$discharged2 == "Yes", 1,
                            ifelse(f75$discharged2 == "No" & f75$withdraw2 == "died", 0,
                                   ifelse(f75$discharged2 == "No" & is.na(f75$withdraw2),"", 1)))
#Weight:categorized the groups (2 group)
median_wt <- median(f75$weight, na.rm = TRUE) #Median:6.5

f75$weight_group <- ifelse(f75$weight <= median_wt, 0, 1) # 0:<6.5kg, 1:>6.5kg

#Oedema: 0:None, 1:+, 2:++, 3:++
f75$oedema_new <- ifelse(f75$oedema == "+", 1,
                         ifelse(f75$oedema == "++", 2,
                                ifelse(f75$oedema == "+++", 3, 0)))
#agemons:categorized the groups (3 group)
quantile(f75$agemons, probs = c(0, 0.33, 0.66, 1), na.rm = TRUE)
f75$age_tertile <- cut(
  f75$agemons,
  breaks = quantile(f75$agemons, probs = c(0, 0.33, 0.66, 1), na.rm = TRUE),
  include.lowest = TRUE,
  labels = c("<12 months", "12-22 months", ">22 months")
)
#SEX Male=0, Female=1
f75$sex_group <- ifelse(f75$sex== "Male", 0, 1) 
#Exclude Unknown for hiv result and Negative is 0, Positive is 1
f75$hiv_new <- ifelse(f75$hiv_results == "Negative", 0,
                      ifelse(f75$hiv_results == "Positive", 1, NA))
f75 <- f75[f75$hiv_new != "Unknown", ]
#removed NA for muac and kwash
f75 <- f75[!is.na(f75$muac), ]
f75 <- f75[!is.na(f75$kwash), ]
#f75$kwas,No=0, Yes+1
f75$kwas_new <- ifelse(f75$kwas== "No", 0, 1) 
#f75$diarrhoea, No=0, Yes+1
f75$diarrhoea_new <- ifelse(f75$diarrhoea== "No", 0, 1) 
#arm, Standard F75=0, Modified F75 (intervention)=1
f75$arm_new <- ifelse(f75$arm=="Standard F75",0,1)
#keep necessary variables in a new and clean dataset
f75_clean <- f75[, c("subjid", "site", "agemons", "age_tertile", "sex_group", "caregiver",
                     "other_carer", "bfeeding", "muac", "weight", "weight_group",
                     "height", "hmeasure", "final_status","diarrhoea_new",
                     "oedema_new", "hiv_new",
                     "kwas_new", "arm_new")]
saveRDS(f75_clean, file = here::here("output", "f75_clean.rds"))



