library('remotes')
library('nCov2019')
library(ggplot2)
library(tidyr)
library(reshape2)
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
p <- ggplot(Kor_Data, aes(time, confirm)) + geom_line() + ggtitle("<Korea increasing trend>")
print(p)
#2/20 ~ 6/26
plot(x=Kor_Data$time,y=Kor_Data$confirm,type = "o", col = "red", main = "Kor_increasing_trend",xlim = c(min(as.Date(Kor_Data$time)),max(as.Date(Kor_Data$time))),
     xlab = "Date", ylab = "confirm",lty =6, sub = "red = confirm, blue = heal, black = dead")
lines(Kor_Data$time,Kor_Data$cum_heal,col="blue")
points(Kor_Data$time,Kor_Data$cum_heal,col="blue")
lines(Kor_Data$time,Kor_Data$cum_dead)
points(Kor_Data$time,Kor_Data$cum_dead)
#이태원 4/30 ~ 5/5
Itaewon <- Kor_Data[71 : 76,]
plot(x=Itaewon$time,y=Itaewon$confirm,type = "o", col = "red", main = "Itaewon_increasing_trend",
     xlab = "Date", ylab = "confirm",lty =6)
#Coupang 물류센터 5월 25 ~
Coupang <- Kor_Data[96 : 100,]
plot(x=Coupang$time,y=Coupang$confirm,type = "o", col = "red", main = "Coupang_increasing_trend",
     xlab = "Date", ylab = "confirm",lty =6)
#구로시 콜센터 감염 3/9 ~ 3/24
callcenter<- Kor_Data[19 : 35,]
plot(x=callcenter$time,y=callcenter$confirm,type = "o", col = "red", main = "callcenter_increasing_trend",
     xlab = "Date", ylab = "confirm",lty =6)




#전체 기울기
fit <- lm(Kor_Data$confirm ~ Kor_Data$time)
summary(fit)
fit$coefficients[[2]] #90.76083
abline(fit, col = "purple",  lwd="3")



#신천지 이전
coda1 <- Kor_Data[c(1:29),]
fit_1 <- lm(coda1$confirm ~ coda1$time)
fit_1$coefficients[[2]] #1.383183
abline(fit_1, col="dark blue", lwd="3")

#신천지 영항력 2/18 ~ 3/8
coda2 <- Kor_Data[c(30:49),]
fit_2 <- lm(coda2$confirm ~ coda2$time)
fit_2$coefficients[[2]] #462.3271
abline(fit_2,col="black", lwd="3")

#구로 콜센터 3/9~3/25
coda3 <- Kor_Data[c(50:66),]
fit_3 <- lm(coda3$confirm ~ coda3$time)
fit_3$coefficients[[2]] #98.77206
abline(fit_3,col="dark blue", lwd="3")

#사이 3/26~5/9
coda4 <- Kor_Data[c(67:110),]
fit_4 <- lm(coda4$confirm ~ coda4$time)
fit_4$coefficients[[2]] #25.53044
abline(fit_4,col="green", lwd="3")

#이태원 5/10~5/15
coda5 <- Kor_Data[c(111:116),]
fit_5 <- lm(coda5$confirm ~ coda5$time)
fit_5$coefficients[[2]] #26.14286
abline(fit_5,col="yellow", lwd="3")

#사이2 5/16~5/26
coda6 <- Kor_Data[c(118:127),]
fit_6 <- lm(coda6$confirm ~ coda6$time)
fit_6$coefficients[[2]] #21.4303
abline(fit_6,col="dark green", lwd="3")

#쿠팡 집단감염 5/27 ~
coda7 <- Kor_Data[c(128:134),]
fit_7 <- lm(coda7$confirm ~ coda7$time)
fit_7$coefficients[[2]] #38.5
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

#write.csv(Kor_Data, "/Users/cpprhtn/Desktop/R_Kor_Data.csv")

all <- all[c(2:19),]
plot(all$city ,all$isolation,col="red",ylim=c(0:500))

#국내 확진 추이
Kor_Data <- alldata['global'] %>% 
  as_tibble %>%
  rename(confirm=cum_confirm) %>%
  filter(country == "South Korea") %>%
  group_by(country)

Kor_Data[,c(1,3:5)] -> kor_coda
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
getwd()
setwd("/Users/cpprhtn/Desktop/git_local/Corona-19_analysis-prediction/코로나/data")
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
min20 <- as.Date("2020-01-01")
max20 <- as.Date("2020-05-31")
search_g %>% 
  ggplot(aes(x=date, y=volume, color=keyword)) +
  ggtitle("Search Trend in 2020") +
  geom_line(lwd = 2) + scale_x_date(breaks = "month", limits = c(min20, max20)) +
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

#성별에 의한 누적 확진자 수
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

#성별에 의한 사망률
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


#연령, 성별에 의한 확진자 수
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

#연령에 의한 유동 인구
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

#성별에 의한 유동인구
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

#시간에 의한 유동인구
move %>% filter(fp_num != '') %>% filter(hour != '') %>%
  group_by(hour, fp_num) %>% summarise(N=n()) %>%
  ggplot(aes(x=hour, y=N, fill=fp_num)) + 
  ggtitle("floating population following hour") +
  geom_line(lwd = 2) +
  geom_bar(stat="identity", position=position_dodge(), width = 0.5) +
  xlab(label = "hour") +
  ylab(label = "Floating population") +
  theme(text=element_text(color="black")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.6, size=20, color="darkgreen"))
