here::i_am("code/01_table_one.R")


data <- readRDS(
  file=here::here("output/f75_clean.rds")
)


library(dplyr)
library(gtsummary)
library(here)



# Prepare factors with labels
data <- data %>%
  mutate(
    arm_new = factor(arm_new, levels = c(0, 1),
                     labels = c("Standard F75", "Modified F75")),
    sex_group = factor(sex_group, levels = c(0, 1),
                       labels = c("Male", "Female")),
    weight_group = factor(weight_group, labels = c("< Median", "≥ Median")),
    oedema_new = factor(oedema_new, labels = c("0", "1", "2", "3")),
    diarrhoea_new = factor(diarrhoea_new, labels = c("No", "Yes")),
    kwas_new = factor(kwas_new, labels = c("No", "Yes")),
    hiv_new = factor(hiv_new, labels = c("Negative", "Positive"))
  )

# Create Table 1
table1 <- data %>%
  select(
    arm_new,
    agemons, age_tertile,
    sex_group, muac, weight, weight_group,
    height, oedema_new, diarrhoea_new,
    hiv_new, kwas_new
  ) %>%
  tbl_summary(
    by = arm_new,
    statistic = list(
      all_continuous() ~ "{median} ({p25}, {p75})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    missing = "no"
  ) %>%
  add_overall() %>%
  add_p() %>%
  bold_labels() %>%
  modify_spanning_header(
    starts_with("stat_") ~ "**Treatment Arm**"
  )

table1

library(gtsummary)
library(gt)

gtsave(as_gt(table1),
       filename = here::here("output", "table1.png"))
saveRDS(table1, file = here::here("output", "table1.rds"))
