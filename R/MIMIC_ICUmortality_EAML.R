# MIMIC_ICUmortality_EAML
# 2019 Efstathios D. Gennatas egenn.github.io

# Libraries ====
remotes::install_github("egenn/rtemis")
library(rtemis)

# Data ====
# Read the 17 physiological features to predict ICU Mortality
dat <- read.csv("/Data/MIMIC-II_Mortality17.csv")

# '- Check data ====
checkData(dat)

# '- Split train and test ====
train <- resample(dat,
                  n.resamples = 1,
                  resampler = "strat.sub",
                  train.p = .7,
                  seed = 4221)
mimic2.train <- dat[train$Resample1, ]
mimic2.test <- dat[-train$Resample1, ]

# RuleFeat ====
mimic2.ruleFeat <- s.RULEFEAT(mimic2.train, mimic2.test,
                              outdir = "./MIMIC2_ICUmortality_ruleFeat500/")
rules <- mimic2.ruleFeat$mod$rules.selected

# Physician assessments ====
phys <- openxlsx::read.xlsx("./PhysicianAssessment.xlsx")

# MIMIC2 ridge ====
mimic2.train.cxr <- matchCasesByRules(mimic2.train, rules)
mimic2.ridge <- s.GLMNET(mimic2.train.cxr, mimic2.train$HospitalMortality,
                         alpha = 0,
                         outdir = "./Results/AllRules")

# MIMIC2 ridge with rule subsets ===
for (i in 4:1) {
  mimic2.ridge.subset <- s.GLMNET(mimic2.train.cxr, mimic2.train$HospitalMortality,
                                  alpha = 0,
                                  outdir = paste0("./Results/Subset", i))
}