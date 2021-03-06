install.packages("remotes")
library('remotes')
library('nCov2019')
library(ggplot2)
update.packages('nCov2019')
require(dplyr)
require(ggplot2)
require(shadowtext)
require(nCov2019)
alldata <- load_nCov2019()
Kor_Data <- alldata['global'] %>% 
  as_tibble %>%
  rename(confirm=cum_confirm) %>%
  filter(country == "South Korea") %>%
  group_by(country)


#시각화
plot(x=Kor_Data$time, y=Kor_Data$confirm, type = "l")
p <- ggplot(Kor_Data, aes(time, confirm)) + geom_line()
print(p)
#종합 2/20 ~ 5/29
plot(x=kor_coda$time,y=kor_coda$confirm,type = "o", col = "red", main = "Kor_increasing_trend",xlim = c(min(as.Date(dd$time)),max(as.Date(dd$time))),
     xlab = "Date", ylab = "confirm",lty =6, sub = "red = confirm, blue = heal, black = dead")
lines(dd$time,dd$cum_heal,col="blue")
points(dd$time,dd$cum_heal,col="blue")
lines(dd$time,dd$cum_dead)
points(dd$time,dd$cum_dead)
#이태원 4/30 ~ 5/5
Itaewon <- dd[71 : 76,]
plot(x=Itaewon$time,y=Itaewon$confirm,type = "o", col = "red", main = "Itaewon_increasing_trend",
     xlab = "Date", ylab = "confirm",lty =6)
#Coupang 물류센터 5월 25 ~
Coupang <- dd[96 : 100,]
plot(x=Coupang$time,y=Coupang$confirm,type = "o", col = "red", main = "Coupang_increasing_trend",
     xlab = "Date", ylab = "confirm",lty =6)
#구로시 콜센터 감염 3/9 ~ 3/24
callcenter<- dd[19 : 35,]
plot(x=callcenter$time,y=callcenter$confirm,type = "o", col = "red", main = "callcenter_increasing_trend",
     xlab = "Date", ylab = "confirm",lty =6)




time <- c("2020-01-21","2020-01-22","2020-01-23","2020-01-24","2020-01-25","2020-01-26","2020-01-27",
          "2020-01-28","2020-01-29","2020-01-30","2020-01-31","2020-02-01","2020-02-02","2020-02-03",
          "2020-02-04","2020-02-05","2020-02-06","2020-02-07","2020-02-08","2020-02-09","2020-02-10",
          "2020-02-11","2020-02-12","2020-02-13","2020-02-14","2020-02-15","2020-02-16","2020-02-17",
          "2020-02-18","2020-02-19")
confirm <- c("1","1","1","2","2","2","4","4","4","7","11","12","15","15","16","21","24","24","24","27",
             "27","28","28","28","28","28","29","30","31","51")
cum_heal <- c("0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","1","2","2","2","3","4",
              "4","7","7","7","9","9","10","10","16")
cum_dead <- c("0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0","0",
              "0","0","0","0","0","0","0","0")
kk <- data.frame(time,confirm,cum_heal,cum_dead)
dfdf[c(30:131),] -> dfdf2
str(kk)
kk$time <- as.Date(kk$time)
kk$confirm <- as.integer(kk$confirm)
kk$cum_heal <- as.integer(kk$cum_heal)
kk$cum_dead <- as.integer(kk$cum_dead)
read.csv(Kor_coda)
newd <- dd[,c(1,3,4,5)]
str(kk)
str(dfdf2)
dfdf2 <- dfdf2[,c(2:5)]
last_data <- rbind(kk,dfdf2)
kor_coda <- rbind(kk,newd)

write.csv(kor_coda, "/Users/cpprhtn/Desktop/Kor_coda.csv")
write.csv(Kor_coda, "/Users/cpprhtn/Desktop/Kor_codaa.csv")

update_coda <- dd[103,c(1,3,4,5)]
kor_coda <- rbind(kor_coda,update_coda)
fit <- lm(Kor_Data$confirm ~ Kor_Data$time)
summary(fit)
abline(fit, col = "purple",  lwd="3")
fit$coefficients[[1]]

#전체 기울기
fit$coefficients[[2]] #109.5699

#신천지 이전
coda1 <- kor_coda[c(1:28),]
fit_1 <- lm(coda1$confirm ~ coda1$time)
fit_1$coefficients[[2]] #0.2208539
abline(fit_1, col="dark blue", lwd="3")

#신천지 영항력 2/18 ~ 3/8
coda2 <- kor_coda[c(29:48),]
fit_2 <- lm(coda2$confirm ~ coda2$time)
fit_2$coefficients[[2]] #432.2105
abline(fit_2,col="black", lwd="3")

#구로 콜센터 3/9~3/25
coda3 <- kor_coda[c(49:65),]
fit_3 <- lm(coda3$confirm ~ coda3$time)
fit_3$coefficients[[2]] #103.6201
abline(fit_3,col="dark blue", lwd="3")

#사이 4/10~5/9
coda4 <- kor_coda[c(81:110),]
fit_4 <- lm(coda4$confirm ~ coda4$time)
fit_4$coefficients[[2]] #24.12121
abline(fit_4,col="green", lwd="3")

#이태원 5/10~5/15
coda5 <- kor_coda[c(111:116),]
fit_5 <- lm(coda5$confirm ~ coda5$time)
fit_5$coefficients[[2]] #28.34286
abline(fit_5,col="yellow", lwd="3")

#사이 5/16~5/25
coda6 <- kor_coda[c(117:126),]
fit_6 <- lm(coda6$confirm ~ coda6$time)
fit_6$coefficients[[2]] #19.42424
abline(fit_6,col="green", lwd="3")

#쿠팡 집단감염 5/27 ~
coda7 <- kor_coda[c(127:133),]
fit_7 <- lm(coda7$confirm ~ coda7$time)
fit_7$coefficients[[2]] #47.75
abline(fit_7,col="green", lwd="3")

6/7일기준
city <- c("합계","서울","부산","대구","인천","광주","대전","울산","태종","경기","강원","충북",
          "충남","전북","전남","경북","경남","제주","검역")
count <- c(0:18)
total <- c("57","27","0","1","6","0","0","1","0","19","0","1","0","0","0","0","0","0","2")

abroad <- c("4","0","0","0","0","0","0","1","0","0","0","1","0","0","0","0","0","0","2")

local <- c("53","27","0","1","6","0","0","0","0","19","0","0","0","0","0","0","0","0","0")

confirmed <- c("11776","974","147","6887","279","32","46","53","47","934","58","61","148","21","20","1383","124","15","547")

isolation <- c("951","319","4","59","161","2","3","6","0","237","4","12","5","2","3","25","2","2","105")

unisolation <- c("10552","651","140","6640","118","30","42","46","47","678","51","49","143","19","17","1304","122","13","442")

death <- c("273","4","3","188","0","0","1","1","0","19","3","0","0","0","0","54","0","0","0")

percent <- c("22.71","10.01","4.31","282.66","9.44","2.2","3.12","4.62","13.73","7.05","3.76","3.81","6.97","1.16","1.07","51.94","3.69","2.24","")

all <- data.frame(count,city,total,abroad,local,confirmed,isolation,unisolation,death,percent)

write.csv(all, "/Users/cpprhtn/Desktop/Occurrence_trend.csv")

plot(all$count,all$isolation,col="red",type="c")



----------------------------------------------
library(dplyr)
library(ggplot2)
library(tidyr)
library(reshape2)

setwd("/Users/cpprhtn/Desktop/git_local/Corona-19_made_JW/코로나/data")
read.csv("/Users/cpprhtn/Desktop/Kor_coda.csv") -> dfdf
update_coda <- update_coda[,c(2:5)]
up_coda <- rbind(update_coda,coda3)
coda2$confirm <- coda2$cum_confirm
coda3 <- coda2[,c(1,5,3,4)]
str(update_coda)
update_coda$time <- as.Date(update_coda$time)

write.csv(up_coda, "/Users/cpprhtn/Desktop/update_coda.csv") # 누적확진자 
write.csv(kor_coda, "/Users/cpprhtn/Desktop/coda2.csv") #일일 확진자

write.csv(last_data, "/Users/cpprhtn/Desktop/last_data.csv") #머신러닝을 위한 데이터





----------------------------------------------
  
last_data <- read.csv("/Users/cpprhtn/Desktop/last_data.csv")

#국내 확진 추이
kor_coda <- kor_coda %>% select(time, confirm, cum_heal, cum_dead)
str(kor_coda)
kor_coda$time <- as.Date(kor_coda$time)
coda <- melt(kor_coda,id.vars="time",variable.name = "type", value.name = "count")
ggplot(coda, aes(x = time, y = count, color = type)) + 
  geom_line(lwd = 2) +
  scale_x_date(breaks = "month") +
  xlab(label = "Date") +
  ylab(label = " ") +
  ggtitle("<Korea increasing trend>") +
  theme_set(theme_gray(base_family='NanumGothic'))+
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))

#검색 트렌드
search <- read.csv("SearchTrend.csv")
search_g <- gather(search, keyword, volume, -date)
search_g$date <- as.Date(search_g$date)
'''
2016년 12월 독감유행으로 'flu' 검색량 증가

2019년 3월 감기유행으로 'cold' 검색량 증가

2020년 1월8일 폐렴 검색 증가이후 코로나 검색 증가

1/20 첫 확진자 발생 -> 코로나 검색 증가
2/18 31번 확진자 확진판정 후 급증
'''
#2020
min <- as.Date("2020-01-01")
max <- as.Date("2020-05-31")
search_g %>% 
  ggplot(aes(x=date, y=volume, color=keyword)) +
  ggtitle("Search Trend in 2020") +
  geom_line(lwd = 2) + scale_x_date(breaks = "month", limits = c(min, max)) +
  xlab(label = "Date") +
  ylab(label = "Number of searches") + ylim(0,90) +
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))
#2019
min19 <- as.Date("2019-01-01")
max19 <- as.Date("2020-01-01")
search_g %>% 
  ggplot(aes(x=date, y=volume, color=keyword)) +
  ggtitle("Search Trend in 2019") +
  geom_line(lwd = 2) + scale_x_date(breaks = "month", limits = c(min19, max19)) +
  xlab(label = "Date") +
  ylab(label = "Number of searches") + ylim(0,20) +
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))

#성별에 따른 누적 확진자 수
gender <- read.csv("TimeGender.csv")
gender_g <- mutate(gender, death_rate = deceased/confirmed)
gender_g$date <- as.Date(gender_g$date)
gender_g %>% ggplot(aes(x = date, y = confirmed, fill = sex)) +
  ggtitle(label = "<Number of confirmed cases by gender>") +  
  geom_bar(stat = "identity", position = "dodge") +
  scale_x_date(breaks = "month") +
  xlab(label = "Date") +
  ylab(label = "number of confirmed cases") +
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.7, size=20, color="black"))

#성별에 따른 사망률
ggplot(gender_g, aes(x=date, y=death_rate, color=sex)) + 
  ggtitle(label = "gender-based mortality") + 
  geom_point() + geom_line() +
  scale_x_date(breaks = "month") +
  xlab(label = "Date") +
  ylab(label = "mortality") +
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="dark red"))


#연령대별 확진자수 및 사망률
age <- read.csv("TimeAge.csv")
age_mu <- aggregate(cbind(confirmed,deceased)~age, age, sum) %>%
  mutate(age, death_rate = deceased/confirmed)
age_mu %>% ggplot() +
  ggtitle("Confirmed number and mortality by age group") +
  geom_bar(mapping = aes(x = age, y = confirmed/1000000), 
           stat = "identity", width=0.5, fill = "skyblue") +
  geom_point(mapping = aes(x = age, y = death_rate), 
             size = 3, shape = 21, fill = "red") + xlab(label = "Age") +
  scale_y_continuous(name = expression("mortality"), 
                     sec.axis = sec_axis(~ . *1000000, name = "number of confirmed cases")) +
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="red"))


#연령, 성별에 따른 확진자 수
patient <- read.csv("Patientinfo.csv")
patient %>% filter(sex != '') %>% filter(age != '') %>%
  group_by(age, sex) %>% summarise(N=n()) %>%
  ggplot(aes(x=age, y=N, fill=sex)) + 
  ggtitle("Number of confirmed cases by age and gender") +
  geom_bar(stat="identity", position=position_dodge()) +
  xlab(label = "Age") +
  ylab(label = "number of confirmed cases") +
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="darkgreen"))

#연령에 따른 유동 인구
move <- read.csv("SeoulFloating.csv")
move %>% filter(fp_num != '') %>% filter(birth_year != '') %>%
  group_by(birth_year, fp_num) %>% summarise(N=n()) %>%
  ggplot(aes(x=birth_year, y=N, fill=fp_num)) + 
  ggtitle("floating population following age") +
  geom_bar(stat="identity", position=position_dodge(), width = 6) +
  xlab(label = "birth_year") +
  ylab(label = "Floating population") +
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.6, size=20, color="darkgreen"))

#성별에 따른 유동인구
move %>% filter(fp_num != '') %>% filter(sex != '') %>%
  group_by(sex, fp_num) %>% summarise(N=n()) %>%
  ggplot(aes(x=sex, y=N, fill=fp_num)) + 
  ggtitle("floating population following sex") +
  geom_bar(stat="identity", position=position_dodge(), width = 0.4) +
  xlab(label = "sex") +
  ylab(label = "Floating population") +
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.6, size=20, color="darkgreen"))

#시간에 따른 유동인구
move %>% filter(fp_num != '') %>% filter(hour != '') %>%
  group_by(hour, fp_num) %>% summarise(N=n()) %>%
  ggplot(aes(x=hour, y=N, fill=fp_num)) + 
  ggtitle("floating population following hour") +
  subti
  geom_line(lwd = 2) +
  geom_bar(stat="identity", position=position_dodge(), width = 0.5) +
  xlab(label = "hour") +
  ylab(label = "Floating population") +
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.6, size=20, color="darkgreen"))




