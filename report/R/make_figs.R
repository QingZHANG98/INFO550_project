here::i_am('report/R/make_figs.R')
data <- read.csv(here::here('./data',"data.csv"),na.strings = "")
require(dplyr)

data <- data %>% mutate(Surgery_type = factor(Surgery_type,levels = c("Simple Mastectomy","Lumpectomy","Modified Radical Mastectomy","Other"))) %>%
  mutate(censor = as.numeric(factor(Patient_Status, levels = c("Alive","Dead"),labels = c(1,2)))) %>%
  mutate_at(vars(Tumour_Stage,Surgery_type,Histology),factor)

## subset for survival probability
Surv1Year <- data %>%
  filter(survdays <= 365.25)
Surv3Year <- data %>%
  filter(survdays <= 365.25 * 3)
Surv5Year <- data %>%
  filter(survdays <= 365.25 * 5)

############## correlation plot #############
corp <- data %>% select(Age,Protein1,Protein2,Protein3,Protein4)

png(filename = "./report/figs/corrplot.png")
corrplot::corrplot(cor(corp))
dev.off()


################## KM-plot #######
require(survminer)
require(ggplot2)

if(!require(survival)){
    install.packages('survival')
    require(survival)
  }

# grouped by quantile
data <- data %>% 
  mutate(AgeGroup = as.numeric(Age >= quantile(Age)[2]) +
           as.numeric(Age >= quantile(Age)[3])+
           as.numeric(Age >= quantile(Age)[4]),
         Pro4Group = as.numeric(Protein4 >= 0.5) 
)

KM_fit <- survfit(Surv(survdays,censor) ~ Pro4Group, data)
png(filename = "./report/figs/KM_fig1.png")
ggsurvplot(KM_fit,data,
           risk.table = T,
           pval = T,
           conf.int = T,
           xlab = "Time in days",
           legend.labs = c('standard Protein4 < 0.5','standard Protein4 >= 0.5')
) +
labs(title = "KM est grouped by protein 4")
dev.off()
# Because the sample size is small. we can see the trend of difference in survival proba, but it's not significant.

## surv ~ tumor stage
KM_fit2 <- survfit(Surv(survdays,censor) ~ Tumour_Stage , data)
png(filename = "./report/figs/KM_fig2.png")
ggsurvplot(KM_fit2,data,
           #risk.table.col = "Surgery type",
           #risk.table = T,
           pval = T,
           conf.int = T,
           xlab = "Time in days"
)+
labs(title = "KM est grouped by Tumour Stage")
dev.off()

## Histology
KM_fit3 <- survfit(Surv(survdays,censor) ~ Histology , data)
png(filename = "./report/figs/KM_fig3.png")
ggsurvplot(KM_fit3,data,
           pval = T,
           conf.int = T,
           xlab = "Time in days"
)+
labs(title = "KM est grouped by Histology")
dev.off()

# these lines are crossed, the log-rank test cannot find out the difference
KM_fit4 <- survfit(Surv(survdays,censor) ~ Histology , 
                   Surv1Year %>% filter(Histology %in% c('Infiltrating Ductal Carcinoma','Infiltrating Lobular Carcinoma')))
png(filename = "./report/figs/KM_fig4.png")
ggsurvplot(KM_fit4,Surv1Year,
           pval = T,
           conf.int = T,
           xlab = "Time in days"
)+
labs(title = "The first year KM est grouped by Histology")
dev.off()

##### objective 2 
table_stage <- data.frame(table(data$Surgery_type,data$Tumour_Stage))
colnames(table_stage) <- c("surgery","stage","Freq")

png(filename = "./report/figs/part2_fig1.png")
ggplot(table_stage,aes(x=stage,y=Freq,fill =surgery)) +
  geom_bar(position = "fill", stat="identity")
dev.off()

##### objective 2, fig2. one year survival in different group
fit_surgery <- glm(data = Surv1Year,-censor+2 ~ Tumour_Stage * Surgery_type + Protein4 + Histology,family = "binomial")
p1 <- sjPlot::plot_model(fit_surgery,mdrt.values = "meansd",type = "pred", 
                   terms = c("Surgery_type","Tumour_Stage")) +
  theme(axis.text.x = element_text(angle = 45)) +
  labs(title = "Predicted Probabilities of One-year Survival",
       y = "Survival probability")

png(filename = "./report/figs/part2_fig2.png")
p1
dev.off()