############### INFO550 project ################
# 2021 Fall
# Author: Qing Zhang
# Update: New organization, Nov 7
# Dataset breast cancer
################################################

############ import the raw data ###################
# set the project root directory
here::i_am('INFO550_project/report/R/analysis.R')
raw_data <- read.csv(here::here('raw_data',"BRCA.csv"),na.strings = "")

############### missing values ################
require(naniar)
## looking at the missing values and their location
vis_miss(raw_data)
## they concentrate on several rows, so just drop the incomplete rows
data <- raw_data[complete.cases(raw_data),]
cat(length(raw_data$Patient_ID) - length(data$Patient_ID),
    "/",length(raw_data$Patient_ID)," incomplete data are dropped")

############### inclusion criteria ############
# Gender == male are excluded
require(dplyr)
data <- data %>% filter(Gender == 'FEMALE') %>%
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
## save data
write.csv(data,here::here('data',"data.csv"))

##### formatting for analysis ####
# make factors
## reorder the levels, put "other" to the last
## alive = 1, dead = 2
data <- data %>% mutate(Surgery_type = factor(Surgery_type,levels = c("Simple Mastectomy","Lumpectomy","Modified Radical Mastectomy","Other"))) %>%
  mutate(censor = as.numeric(factor(Patient_Status, levels = c("Alive","Dead"),labels = c(1,2)))) %>%
  mutate_at(vars(Tumour_Stage,Surgery_type,Histology),factor)

################ make table 1 #################
require(gtsummary)
table_1 <- data %>%
  select(Age,Protein1,Protein2,Protein3,Protein4,Tumour_Stage,receptor,Histology,Surgery_type,
         Patient_Status,survdays) %>%

  ## make table
  tbl_summary(label = list(Tumour_Stage ~ "Tumor Stage",
                           receptor ~ "Progesterone Receptors",
                           Patient_Status ~ "Patient Status",
                           Surgery_type ~ "Surgery Type",
                           survdays ~ "Observed Survival Days"
                           )
              )
table_1

######  Objective 1 : find the risk factor of death#######
Surv1Year <- data %>%
  filter(survdays <= 365.25)
Surv3Year <- data %>%
  filter(survdays <= 365.25 * 3)
Surv5Year <- data %>%
  filter(survdays <= 365.25 * 5)
############## Add some survival analysis ############
# univ analysis
## fit coxph model
require(finalfit)
require(knitr)
OverallSurv <- "Surv(survdays,censor)"
UnivCovs <- c("Age","Protein1","Protein2","Protein3","Protein4",
              "Tumour_Stage","receptor","Surgery_type","Histology")
### fit models
univ_analysis <- data %>%
  finalfit(OverallSurv,UnivCovs) %>%
  kableExtra::kable()
univ_analysis

### protein2, protein4, tumor stage, surgery type ~ association
### protein1 ~ potential interaction
corp <- data %>% select(Age,Protein1,Protein2,Protein3,Protein4)
corrplot::corrplot(cor(corp))

#linear model
fit_linear <- lm(survdays ~ Age * Protein4 + Tumour_Stage + receptor + Surgery_type + Histology,data)
tbl_regression(fit_linear)

# re-group the age 
# by 10 years
# labs <- c(paste(29,"-",39, sep = ""),paste(seq(40, 60, by = 10), seq(40 + 10 - 1, 80 - 1, by = 10), sep = "-"), paste(80, "+", sep = ""))
# data$AgeGroup <- cut(as.integer(data$Age),breaks = c(seq(29, 80, by = 10), Inf), labels = labs, right = T)
# by quantile
data <- data %>% 
  mutate(AgeGroup = as.numeric(Age >= quantile(Age)[2]) +
           as.numeric(Age >= quantile(Age)[3])+
           as.numeric(Age >= quantile(Age)[4]),
         Pro4Group = as.numeric(Protein4 >= 0.5) 
)


# KM-plot
require(survminer)
require(survival)
require(ggplot2)
# five year survival
KM_fit <- survfit(Surv(survdays,censor) ~ Pro4Group, data)
ggsurvplot(KM_fit,data,
           risk.table = T,
           pval = T,
           conf.int = T,
           xlab = "Time in days",
           legend.labs = c('standard Protein4 < 0.5','standard Protein4 >= 0.5')
)
# Because the sample size is small. we can see the trend of difference in survival proba, but it's not significant.

## surv ~ tumor stage
KM_fit2 <- survfit(Surv(survdays,censor) ~ Tumour_Stage , data)
ggsurvplot(KM_fit2,data,
           #risk.table.col = "Surgery type",
           #risk.table = T,
           pval = T,
           conf.int = T,
           xlab = "Time in days"
           #legend.labs = c('standard Protein4 < 0.5','standard Protein4 >= 0.5')
)   

## Histology
KM_fit3 <- survfit(Surv(survdays,censor) ~ Histology , data)
ggsurvplot(KM_fit3,data,
           pval = T,
           conf.int = T,
           xlab = "Time in days"
)

# these lines are crossed, the log-rank test cannot find out the difference
KM_fit4 <- survfit(Surv(survdays,censor) ~ Histology , 
                   Surv1Year %>% filter(Histology %in% c('Infiltrating Ductal Carcinoma','Infiltrating Lobular Carcinoma')))
ggsurvplot(KM_fit4,Surv1Year,
           pval = T,
           conf.int = T,
           xlab = "Time in days"
)
## compare the 1 year survival of the Ductal Carcinoma and Lobular Carcinoma
Histo1Year <- data %>% filter(survdays <=365) %>%
  filter(Histology %in% c('Infiltrating Ductal Carcinoma','Infiltrating Lobular Carcinoma')) %>%
  mutate(Lobular = as.numeric(Histology=='Infiltrating Lobular Carcinoma'))

coxph(Surv(survdays,censor) ~ Lobular,data = Histo1Year) %>%
  tbl_regression(exp = TRUE,label = list(Lobular ~ 'Infiltrating Lobular Carcinoma')) %>%
  modify_caption('One year survival, Infiltrating Lobular Carcinoma vs Infiltrating Ductal Carcinoma') %>%
  bold_labels()

### final coxph model
multi_analysis <- data %>%
  finalfit(OverallSurv,c('Protein4','Tumour_Stage','Histology','Protein2')) %>%
  htmlTable::htmlTable()
multi_analysis

## Although in the first year, the lobular patients would have better experience, 
## the tumor could develop in a long time
## I guess it could be associated with patients' age/treatment/tumor stage. 
### let's have a test

########## Objective 2: find the treatment and the expectation #######
## other factors
### first, the treatment could be different because of the tumor stage
chisq.test(data$Surgery_type,data$Tumour_Stage)
table_stage <- data.frame(table(data$Surgery_type,data$Tumour_Stage))
colnames(table_stage) <- c("surgery","stage","Freq")

ggplot(table_stage,aes(x=stage,y=Freq,fill =surgery)) +
  geom_bar(position = "fill", stat="identity")

## adjusted model
# 1 year survival prob
fit_surgery <- glm(data = Surv1Year,-censor+2 ~ Tumour_Stage * Surgery_type + Protein4 + Histology,
                  family = "binomial")
summary(fit_surgery)
## No significant difference
## marginal means
p1 <- sjPlot::plot_model(fit_surgery,mdrt.values = "meansd",type = "pred", 
                   terms = c("Surgery_type","Tumour_Stage")) +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Predicted Probabilities of One-year Survival",
       y = "Survival probability")
p1

corrplot::corrplot(cor(corp)) %>%
  
                   