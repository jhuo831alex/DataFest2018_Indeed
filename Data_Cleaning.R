library(readr)
library(dplyr)
library(lubridate)
library(mlr)
library(caret)

####Data Subsetting####
IndeedData <- read_csv("~/Desktop/2018 DataFest/datafest2018-Updated-April12.csv")
dat1 <-  subset(IndeedData,country=="US")
job_zero <- dat1$jobId[dat1$jobAgeDays == 0]
dat2 <- dat1[dat1$jobId %in% job_zero, ]

#####Data Cleaning#####
final_dat1 <- dat2 %>% group_by(jobId) %>% summarise(maxjobagedays = max(jobAgeDays),clicks=sum(clicks),localClicks = sum(localClicks))
final_dat2 <- merge(final_dat1,dat2[,-c(4,16,17,21,22,23)],by="jobId",all.x = T)
final_dat3 <- final_dat2[match(unique(final_dat2$jobId), final_dat2$jobId),] #first occurance
final_dat3$months <- as.factor(month(final_dat3$date))
final_dat3$num_NA <- apply(final_dat3[,c(8:19)],1,function(x) sum(is.na(x)))
final_dat3$local_per <- final_dat3$localClicks / final_dat3$clicks
dat3 <- final_dat3 %>% group_by(companyId) %>% summarise(num_job=n())
final_dat4 <- merge(final_dat3,dat3,by="companyId",all.x = T)
final_dat5 <- final_dat4
final_dat5$educationRequirements[final_dat5$educationRequirements=="None"] <- 0
final_dat5$educationRequirements[final_dat5$educationRequirements=="High School"] <- 12
final_dat5$educationRequirements[final_dat5$educationRequirements=="Higher Education"] <- 16

final_dat6 <- final_dat5

final_dat6$stateProvince<-as.factor(final_dat6$stateProvince)
final_dat6$city <- as.factor(final_dat6$city)
final_dat6$normTitleCategory <- as.factor(final_dat6$normTitleCategory)

write.csv(final_dat6,"final_dat6.csv")

library(readxl)
us_population_data <- read_excel("~/Desktop/us population data.xlsx")
us_population_data <- us_population_data[-1,-3]
names(us_population_data)<- c("stateProvince","state_name","emp_pop")
final_dat8 <- merge(final_dat6,us_population_data,by = "stateProvince",all.x = T) 
final_dat8$state_name<-toupper(final_dat8$state_name)

GDP <- read.csv("~/Desktop/DataFest_2018/us states gdp .csv")
GDP$Area <- toupper(GDP$Area)
names(GDP)[3] <-"gdp"
final_dat9 <- merge(final_dat8,GDP[,c(2,3)],by.x="state_name",by.y="Area",all.x = T)


final_dat9$emp_pop <- (final_dat9$emp_pop - min(final_dat9$emp_pop,na.rm = T))/(max(final_dat9$emp_pop,na.rm = T)-min(final_dat9$emp_pop,na.rm = T))
final_dat9$gdp <-(final_dat9$gdp - min(final_dat9$gdp,na.rm = T))/(max(final_dat9$gdp,na.rm = T)-min(final_dat9$gdp,na.rm = T))
final_dat9$state_sub <- final_dat9$emp_pop +final_dat9$gdp

write.csv(final_dat9,"final_dat9.csv")

final_dat10 <- final_dat9[,-c(1,2,3,4,5,7,8,9,12,13,14,15,26,27)]


####maxday
final_dat11 <- final_dat9[,-c(1,2,3,4,6,7,8,9,12,13,14,15,26,27)]
final_dat11$maxjobagedays <- 1/(final_dat11$maxjobagedays+1)

write.csv(final_dat10,"final_dat10.csv")

####
final_dat12 <- final_dat9[,-c(1,2,3,4,7,8,9,12,13,14,15,26,27)]
final_dat12$maxjobagedays <- 1/(final_dat12$maxjobagedays+1)

final_dat12$maxjobagedays <- (final_dat12$maxjobagedays - min(final_dat12$maxjobagedays,na.rm = T))/(max(final_dat12$maxjobagedays,na.rm = T)-min(final_dat12$maxjobagedays,na.rm = T))
final_dat12$clicks <- (final_dat12$clicks - min(final_dat12$clicks,na.rm = T))/(max(final_dat12$clicks,na.rm = T)-min(final_dat12$clicks,na.rm = T))
final_dat12$resp <- final_dat12$maxjobagedays + final_dat12$clicks
final_dat12 <- final_dat12[,-c(1,2)]
