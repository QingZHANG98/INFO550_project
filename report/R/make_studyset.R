############### INFO550 project ################
# 2021 Fall
# Author: Qing Zhang
# Update: New organization, Nov 7
# Dataset breast cancer
################################################

############ required packages ######################
if(!require(here)){
  install.packages("DataExplorer")
  require(here)
}

if(!require(renv)){
  install.packages("DataExplorer")
  require(renv)
}
# use renv to install the required packages with specific version
require(dplyr)

############ import the raw data ###################
# set the project root directory
here::i_am('INFO550_project/report/R/analysis.R')
raw_data <- read.csv(here::here('INFO550_project/raw_data',"BRCA.csv"),na.strings = "")
# drop incomplete rows
data <- raw_data[complete.cases(raw_data),]

############### inclusion criteria ############
# Gender == male are excluded
data <- data %>% 
  filter(Gender == 'FEMALE') %>%
# classified by receptors
# all ER/HER2 are positive. add labels
  mutate(receptor = (ifelse(ER.status=="Positive",yes = 2, no = 1)*
                     ifelse(PR.status=="Positive",yes = 3, no = 1)*
                     ifelse(HER2.status=="Positive",yes = 4, no = 1))
         ) %>%
  mutate(receptor = factor(receptor,levels = c(6,24),
                           labels = c("PR-", "PR+"))) %>%
  mutate(Date_of_Surgery = as.Date(Date_of_Surgery,format = "%d-%b-%y"),
         Date_of_Last_Visit = as.Date(Date_of_Last_Visit,format = "%d-%b-%y")) %>%
  ## add survival days
  mutate(survdays = as.numeric(Date_of_Last_Visit - Date_of_Surgery))

############## saving dataset
write.csv(data,here::here('INFO550_project/data',"data.csv"))