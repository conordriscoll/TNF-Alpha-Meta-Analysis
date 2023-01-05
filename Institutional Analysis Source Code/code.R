library(forestplot)
library(gtsummary)
library(flextable)
library(survival)
library(labelled)
require("knitr")
require("kableExtra")
require("png")
require("readxl")
require("xlsx")
require("arsenal")
require("lubridate")
require("scales")
require("ggplot2")
require("tibble")
require("tidyr")
require("stringr")
require("dplyr")

dat_clean <- readRDS("clean-data-deidentified.RDS")
dat_filtered <- dat_clean$dat_clean %>% 
  filter(race != "Unknown", gender != "U", smoke_baseline != "Unknown")
cancer_types <- dat_clean$cancer_types

#### Descriptive Table

demo_dat <- dat_filtered %>% 
  mutate(drug_type_ = factor(drug_type_, 
                             levels = c("Etanercept", "Adalimumab", "Infliximab", 
                                        "Certolizumab", "Exposed-Other", "Unexposed")), 
         any_drug = factor(ifelse(any_drug, "Yes", "No"), levels = c("Yes", "No")), 
         first_cancer_ = factor(ifelse(first_cancer_ == "", 
                                       "No cancer", first_cancer_), 
                                levels = c(cancer_types, "No cancer")), 
         race = factor(race, levels = c("White", "Black", "Other")), 
         gender = factor(case_when(gender == "F" ~ "Female", 
                                   gender == "M" ~ "Male"), 
                         levels = c("Female", "Male")), 
         smoke_baseline = factor(smoke_baseline, 
                                 levels = c("Current", "Former", "Never")), 
         Number_of_transrectal_diagnostic_ultrasounds_cat = 
           factor(Number_of_transrectal_diagnostic_ultrasounds_cat, 
                  levels = c("0", "1+", "Missing"))) %>% 
  set_variable_labels(drug_type_ = paste0("TNF-", "\U03B1", "-I Type"), 
                      any_drug = paste0("TNF-", "\U03B1", "-I"), 
                      first_cancer_ = "Cancer Type", 
                      age = "Age", 
                      race = "Race", 
                      gender = "Gender", 
                      smoke_baseline = "Smoking at Baseline", 
                      Number_of_transrectal_diagnostic_ultrasounds_cat = 
                        "Number of Transrectal Diagnostic Ultrasounds Category", 
                      RA = "Rheumatoid Arthritis", 
                      UC = "Ulcerative Colitis", 
                      CD = "Crohn’s Disease", 
                      ps_psa = "Ps/PsA", 
                      as_sda = "As/SdA",
                      hidradenitis_suppurativa = "Hidradenitis Suppurativa",
                      uveitis = "Uveitis") %>% 
  dplyr::select(any_drug, age, race, gender, smoke_baseline, 
                Number_of_transrectal_diagnostic_ultrasounds_cat, 
                first_cancer_, RA, UC, CD, ps_psa, as_sda, 
                hidradenitis_suppurativa, uveitis, drug_type_) 
tab1 <- demo_dat[, -15] %>% tbl_summary(by = any_drug) 
tab2 <- demo_dat[, -c(1, 15)] %>% tbl_summary()
list(tab1, tab2) %>% 
  tbl_merge(tab_spanner = c(paste0("TNF-", "\U03B1", "-I"), "Total")) %>% 
  bold_labels() %>% 
  as_flex_table() %>% 
  fontsize(size = 9) %>% 
  width(j = 1:4, width = c(1.5, 1.2, 1.2, 1.2)) 

#### Cox regressions

dat_overall <- rbind(data.frame(start = 0, 
                                end = dat_filtered$fu_time,
                                drug = 0, 
                                event = dat_filtered$any_cancer, 
                                dat_filtered)[dat_filtered$any_drug == 0, ],
                     data.frame(start = 0,
                                end = dat_filtered$fu_time1, 
                                drug = 0, 
                                event = 0, 
                                dat_filtered)[dat_filtered$any_drug == 1, ], 
                     data.frame(start = dat_filtered$fu_time1,
                                end = dat_filtered$fu_time1 + dat_filtered$fu_time2, 
                                drug = 1, 
                                event = dat_filtered$any_cancer, 
                                dat_filtered)[dat_filtered$any_drug == 1, ]) %>% subset(end > 0)

mod0 <- coxph(Surv(start, end, event) ~ drug + age + race + gender + smoke_baseline + # fu_time +
                RA + CD + UC + ps_psa + as_sda + hidradenitis_suppurativa + uveitis +
                Number_of_transrectal_diagnostic_ultrasounds_cat,
              data = dat_overall, id = id)

res <- data.frame(cancer_type = "Any_cancer", 
                  coef_name = names(coefficients(mod0)), 
                  odds_ratio = exp(coefficients(mod0)), 
                  odds_ratio_lower = exp(coefficients(mod0) - 1.96*sqrt(diag(vcov(mod0)))), 
                  odds_ratio_upper = exp(coefficients(mod0) + 1.96*sqrt(diag(vcov(mod0)))), 
                  odds_ratio_pval = (1 - pnorm(abs(coefficients(mod0)/sqrt(diag(vcov(mod0))))))*2)

for(c_type in cancer_types) {
  
  dat_filtered_c <- dat_filtered[dat_filtered$first_cancer_ %in% c(c_type, ""), ]
  dat_filtered_c$first_cancer_ <- (dat_filtered_c$first_cancer_ == c_type)*1
  
  dat_c <- rbind(data.frame(start = 0, 
                            end = dat_filtered_c[, paste0(tolower(c_type), "_fu_time")],
                            drug = 0, 
                            event = dat_filtered_c$first_cancer_, 
                            dat_filtered_c)[dat_filtered_c$any_drug == 0, ],
                 data.frame(start = 0,
                            end = dat_filtered_c[, paste0(tolower(c_type), "_fu_time1")], 
                            drug = 0, 
                            event = 0, 
                            dat_filtered_c)[dat_filtered_c$any_drug == 1, ], 
                 data.frame(start = dat_filtered_c[, paste0(tolower(c_type), "_fu_time1")],
                            end = dat_filtered_c[, paste0(tolower(c_type), "_fu_time1")] + 
                              dat_filtered_c[, paste0(tolower(c_type), "_fu_time2")], 
                            drug = 1, 
                            event = dat_filtered_c$first_cancer_, 
                            dat_filtered_c)[dat_filtered_c$any_drug == 1, ]) %>% subset(end > 0)
  
  if(c_type %in% c("Prostate")) dat_c <- dat_c[dat_c$gender == "M", ]
  if(c_type %in% c("Breast", "Ovarian", "Uterine", "Cervical")) dat_c <- dat_c[dat_c$gender == "F", ]
  if(c_type %in% c("Prostate", "Breast", "Ovarian", "Uterine", "Cervical")) {
    
    mod0 <- coxph(Surv(start, end, event) ~ drug + age + race + smoke_baseline + # fu_time +
                    RA + CD + UC + ps_psa + as_sda + hidradenitis_suppurativa + uveitis +
                    Number_of_transrectal_diagnostic_ultrasounds_cat,
                  data = dat_c, id = id)
  } else {
    
    mod0 <- coxph(Surv(start, end, event) ~ drug + age + race + gender + smoke_baseline + # fu_time +
                    RA + CD + UC + ps_psa + as_sda + hidradenitis_suppurativa + uveitis +
                    Number_of_transrectal_diagnostic_ultrasounds_cat,
                  data = dat_c, id = id)
  }
  
  res <- rbind(res, 
               data.frame(cancer_type = c_type, 
                          coef_name = names(coefficients(mod0)), 
                          odds_ratio = exp(coefficients(mod0)), 
                          odds_ratio_lower = exp(coefficients(mod0) - 1.96*sqrt(diag(vcov(mod0)))), 
                          odds_ratio_upper = exp(coefficients(mod0) + 1.96*sqrt(diag(vcov(mod0)))), 
                          odds_ratio_pval = (1 - pnorm(abs(coefficients(mod0)/sqrt(diag(vcov(mod0))))))*2))
}

#### Forest plot

res_f <- res[res$coef_name == "drug", ]
res_f$odds_ratio[res_f$odds_ratio_lower == 0 | res_f$odds_ratio_upper == Inf] <- NA
res_f$odds_ratio_lower[res_f$odds_ratio_lower == 0 | res_f$odds_ratio_upper == Inf] <- NA
res_f$odds_ratio_upper[res_f$odds_ratio_lower == 0 | res_f$odds_ratio_upper == Inf] <- NA
res_f$odds_ratio_pval[is.na(res_f$odds_ratio)] <- NA
forestplot(
  cbind(c("Cancer Type", res_f$cancer_type), 
        c("HR*", ifelse(is.na(res_f$odds_ratio), "NA", 
                        paste0(round(res_f$odds_ratio, 2), " (", 
                               round(res_f$odds_ratio_lower, 2), ", ", 
                               round(res_f$odds_ratio_upper, 2), ")"))), 
        c("P-value", ifelse(is.na(res_f$odds_ratio), "-", 
                            round(res_f$odds_ratio_pval, 3)))), 
  mean = c(1, res_f$odds_ratio), 
  lower = c(1, res_f$odds_ratio_lower), 
  upper = c(1, res_f$odds_ratio_upper), 
  lwd.ci = 2, ci.vertices = TRUE, ci.vertices.height = 0.1, 
  boxsize = 0.2, 
  hrzl_lines = list("2" = gpar(lwd = 1, lty = 1, lineend = "butt", columns = 1:3, col = "black")), 
  is.summary = c(TRUE, rep(FALSE, dim(res_f)[1])),
  clip = c(0.17, 6), 
  xlog = TRUE 
)



Footer
© 2023 GitHub, Inc.
Footer navigation
Terms
Privacy
Security
Status
Docs
Contact GitHub
Pricing
API
Training
Blog
About
