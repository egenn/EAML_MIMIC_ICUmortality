# MIMIC_ICUmortality_EAML
# 2019 Efstathios D. Gennatas egenn.github.io

# Libraries ====
library(rtemis)

# Data ====
# Read the 17 physiological features to predict ICU Mortality
dat <- read.csv("/Data/MIMIC-II_Mortality17.csv")

checkData(dat)

# RuleFeat ====
mimic.rulefeat <- s.RULEFEAT(dat)

