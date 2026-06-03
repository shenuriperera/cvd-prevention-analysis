#creating the dataset
set.seed(16661)
if (!requireNamespace("truncnorm", quietly = TRUE)) {
  install.packages("truncnorm")
}
library(truncnorm)
n <- 1500
ID <- sprintf("CVD%03d", 1:n)
Age <- round(rtruncnorm(n, a = 25, b = 80, mean = 50, sd = 15))
Gender <- sample(c("Female", "Male"), size = n, replace = TRUE, prob = c(0.52, 0.48))
District <- sample(c("Colombo", "Kandy", "Galle"), size = n, replace = TRUE, prob = c(0.40, 0.35, 0.25))
Education <- character(n)
for (d in c("Colombo","Kandy","Galle")) {
  idx <- which(District == d)
  if (d == "Colombo") {
    Education[idx] <- sample(c("Primary","Secondary","Higher"), length(idx), replace = TRUE, prob = c(0.20,0.50,0.30))
  } else if (d == "Kandy") {
    Education[idx] <- sample(c("Primary","Secondary","Higher"), length(idx), replace = TRUE, prob = c(0.35,0.45,0.20))
  } else if (d == "Galle") {
    Education[idx] <- sample(c("Primary","Secondary","Higher"), length(idx), replace = TRUE, prob = c(0.45,0.40,0.15))
  }
}
Pre_Systolic_BP <- round(rtruncnorm(n, a = 110, b = 200, mean = 140, sd = 20))
Pre_BMI <- round(rtruncnorm(n, a = 18.5, b = 40, mean = 26.5, sd = 4.5), 1)

Smoking <- character(n)
for (i in seq_len(n)) {
  if (Gender[i] == "Male") {
    Smoking[i] <- ifelse(runif(1) < 0.35, "Yes", "No")
  } else {
    Smoking[i] <- ifelse(runif(1) < 0.08, "Yes", "No")
  }
}
Pre_Exercise_Days <- sample(0:4, size = n, replace = TRUE)
Diabetes <- ifelse(Age > 50,
                   ifelse(runif(n) < 0.25, "Yes", "No"),
                   ifelse(runif(n) < 0.12, "Yes", "No"))
                   
Participation_prob <- ifelse(District == "Colombo", 0.70,
                             ifelse(District == "Kandy", 0.60, 0.50))
Participated <- ifelse(runif(n) < Participation_prob, "Yes", "No")
Sessions_Attended <- ifelse(Participated == "Yes", sample(6:12, n, replace = TRUE), 0)
improvement_bp <- numeric(n)
for (i in seq_len(n)) {
  if (Participated[i] == "Yes") {
    improvement_bp[i] <- runif(1, min = 5, max = 20)
  } else {
    improvement_bp[i] <- runif(1, min = 0, max = 5)
  }
}
Post_Systolic_BP <- pmax(100, round(Pre_Systolic_BP - improvement_bp))

improvement_bmi <- numeric(n)
for (i in seq_len(n)) {
  if (Participated[i] == "Yes") {
    improvement_bmi[i] <- runif(1, min = 0.5, max = 3.0)
  } else {
    improvement_bmi[i] <- runif(1, min = 0.0, max = 1.0)
  }
}
Post_BMI <- round(pmax(18.5, Pre_BMI - improvement_bmi), 1)
Post_Smoking_Status <- Smoking
for (i in seq_len(n)) {
  if (Smoking[i] == "Yes") {
    if (Participated[i] == "Yes") {
      Post_Smoking_Status[i] <- ifelse(runif(1) < 0.30, "No", "Yes")
    } else {
      Post_Smoking_Status[i] <- ifelse(runif(1) < 0.10, "No", "Yes")
    }
  } else {
    Post_Smoking_Status[i] <- "No"
  }
}
Post_Exercise_Days <- integer(n)
for (i in seq_len(n)) {
  if (Participated[i] == "Yes") {
    inc <- sample(1:4, 1)
  } else {
    inc <- sample(0:1, 1)
  }
  Post_Exercise_Days[i] <- pmin(7, Pre_Exercise_Days[i] + inc)
}
base_prob <- 0.03
cvd_prob <- rep(base_prob, n)
cvd_prob <- cvd_prob + ifelse(Age > 60, 0.04, 0)
cvd_prob <- cvd_prob + ifelse(Gender == "Male", 0.03, 0)
cvd_prob <- cvd_prob + ifelse(Smoking == "Yes", 0.05, 0)       # using pre-program smoking
cvd_prob <- cvd_prob + ifelse(Diabetes == "Yes", 0.06, 0)
cvd_prob <- cvd_prob + ifelse(Pre_Systolic_BP > 160, 0.04, 0)
cvd_prob <- cvd_prob - ifelse(Participated == "Yes", 0.02, 0)
cvd_prob <- pmin(pmax(cvd_prob, 0), 1)
CVD_Event <- ifelse(runif(n) < cvd_prob, "Yes", "No")
dataset <- data.frame(ID,Age,Gender,District,Education,Pre_Systolic_BP,Post_Systolic_BP,Pre_BMI,Post_BMI,Smoking,Post_Smoking_Status,Pre_Exercise_Days,Post_Exercise_Days,Diabetes,Participated,Sessions_Attended,CVD_Event,CVD_Prob = round(cvd_prob, 4),stringsAsFactors = FALSE)
cat("Number of rows:", nrow(dataset), "\n")
cat("Participation counts:\n"); print(table(dataset$Participated))
cat("Smoking (pre) counts:\n"); print(table(dataset$Smoking))
cat("CVD event counts:\n"); print(table(dataset$CVD_Event))
write.csv(dataset, "synthetic_cvd_dataset_1500.csv", row.names = FALSE)
cat("Saved dataset to 'synthetic_cvd_dataset_1500.csv' in working directory.\n")
head(dataset, 8)

#summary of the dataset
summary(dataset)

#finding the counts
count_t_gender=table(Gender)
count_t_gender
count_t_district=table(District)
count_t_district
count_t_education=table(Education)
count_t_education
count_t_smoking=table(Smoking)
count_t_smoking
count_t_postsmoking=table(Post_Smoking_Status)
count_t_postsmoking
count_t_diabetes=table(Diabetes)
count_t_diabetes
count_t_participated=table(Participated)
count_t_participated
count_t_cvdevent=table(CVD_Event)
count_t_cvdevent

#proportions tables
prop_t_gender=table(Gender)/length(Gender)
prop_t_gender
prop_t_district=table(District)/length(District)
prop_t_district
prop_t_education=table(Education)/length(Education)
prop_t_education
prop_t_smoking=table(Smoking)/length(Smoking)
prop_t_smoking
prop_t_postsmoking=table(Post_Smoking_Status)/length(Post_Smoking_Status)
prop_t_postsmoking
prop_t_diabetes=table(Diabetes)/length(Diabetes)
prop_t_diabetes
prop_t_participated=table(Participated)/length(Participated)
prop_t_participated
prop_t_cvdevent=table(CVD_Event)/length(CVD_Event)
prop_t_cvdevent

#frequency tables
library(descriptr)
age_freq=ds_freq_table(dataset,Age,5)
age_freq
pre_bp_freq=ds_freq_table(dataset,Pre_Systolic_BP,5)
pre_bp_freq
post_bp_freq=ds_freq_table(dataset,Post_Systolic_BP,5)
post_bp_freq
pre_bmi_freq=ds_freq_table(dataset,Pre_BMI,5)
pre_bmi_freq
post_bmi_freq=ds_freq_table(dataset,Post_BMI,5)
post_bmi_freq
pre_ex_freq=ds_freq_table(dataset,Pre_Exercise_Days,5)
pre_ex_freq
post_ex_freq=ds_freq_table(dataset,Post_Exercise_Days,5)
post_ex_freq
session_freq=ds_freq_table(dataset,Sessions_Attended,5)
session_freq

#descriptive plots
pie(count_t_gender,main="Pie chart of Gender",col=c("pink","grey"))
barplot(count_t_district,main="Bar chart of district",xlab="District",ylab="Frequency",col=c("pink","grey","lightblue"))
barplot(count_t_education,main="Pie chart of education",xlab="Education",ylab="Frequency",col=c("pink","grey","lightblue"))
pie(count_t_smoking,main="Pie chart of smoking",col=c("pink","grey"))
pie(count_t_postsmoking,main="Pie chart of post smoking",col=c("pink","grey"))
pie(count_t_diabetes,main="Pie chart of diabetes",col=c("pink","grey"))
pie(count_t_participated,main="Pie chart of participation",col=c("pink","grey"))
pie(count_t_cvdevent,main="Pie chart of having a CVD event",col=c("pink","grey"))
Table1=table(District,Education)
table2=prop.table(Table1,2)
table2
barplot(table2,legend.text=row.names(Table1),main="Compound barplot of District vs Education",xlab="Education",ylab="District",col=c("pink","grey","lightblue"))
table3=table(Participated, District)
table4=prop.table(table3,2)
table4
barplot(table4,legend.text=row.names(table3),main="Compound barplot of Participated vs District",xlab="District",ylab="Participated",col=c("pink","lightblue"))

hist(Age,col="lightblue")
boxplot(dataset$Pre_Systolic_BP, dataset$Post_Systolic_BP,names = c("Pre BP", "Post BP"), col = c("lightblue", "lightgreen"),main = "Pre vs Post Systolic BP",
        ylab = "Systolic BP (mmHg)")
boxplot(dataset$Pre_BMI, dataset$Post_BMI,names = c("Pre BMI", "Post BMI"), col = c("lightblue", "lightgreen"),main = "Pre vs Post Systolic BMI",
        ylab = "BMI")
boxplot(dataset$Pre_Exercise_Days, dataset$Post_Exercise_Days,names = c("Pre Exercise", "Post Exercise"), col = c("lightblue", "lightgreen"),main = "Pre vs Post Exercise",
        ylab = "Exercise Days")

#shapiro test
shapiro.test(Pre_Systolic_BP)
shapiro.test(Post_Systolic_BP)
shapiro.test(Pre_BMI)
shapiro.test(Post_BMI)
shapiro.test(Pre_Exercise_Days)
shapiro.test(Post_Exercise_Days)

#nonparametric tests
wilcox.test(Post_Systolic_BP,Pre_Systolic_BP,mu=0,alternative="less",paired=T,exact=F,conf.int=T,conf.level=0.95)
wilcox.test(Post_BMI,Pre_BMI,mu=0,alternative="less",paired=T,exact=F,conf.int=T,conf.level=0.95)
wilcox.test(Post_Exercise_Days,Pre_Exercise_Days,mu=0,alternative="greater",paired=T,exact=F,conf.int=T,conf.level=0.95)
dataset$BP_Improvement <- dataset$Pre_Systolic_BP - dataset$Post_Systolic_BP
kruskal.test(dataset$BP_Improvement~District)
dataset$BMI_Improvement <- dataset$Pre_BMI - dataset$Post_BMI
kruskal.test(dataset$BMI_Improvement~District)
dataset$Exercise_Improvement <- dataset$Post_Exercise_Days - dataset$Pre_Exercise_Days
kruskal.test(dataset$Exercise_Improvement~District)
dataset$AgeGroup <- cut(dataset$Age,breaks = c(0, 40, 50, 60, 100),labels = c("≤40", "41–50", "51–60", "61+"),right = TRUE)
kruskal.test(dataset$BP_Improvement~dataset$AgeGroup)
kruskal.test(dataset$BMI_Improvement~dataset$AgeGroup)
kruskal.test(dataset$Exercise_Improvement~dataset$AgeGroup)
wilcox.test(dataset$BP_Improvement~Gender, mu = 0, alternative = "two.sided",conf.int = T,Conf.level =0.95,exact = F,correct = T)
wilcox.test(dataset$BMI_Improvement~Gender, mu = 0, alternative = "two.sided",conf.int = T,Conf.level =0.95,exact = F,correct = T)
wilcox.test(dataset$Exercise_Improvement~Gender, mu = 0, alternative = "two.sided",conf.int = T,Conf.level =0.95,exact = F,correct = T)

#checking correlations
table5=table(Diabetes,CVD_Event)
chisq.test(table5,correct=T)
table7=table(Participated,CVD_Event)
chisq.test(table7,correct = T)
table8=table(Post_Smoking_Status,CVD_Event)
chisq.test(table8,correct=T)

#getting an excel file
install.packages("openxlsx")
library(openxlsx)
write.xlsx(dataset, file = "CVD_Dataset.xlsx")
getwd()

