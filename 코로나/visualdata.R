#세팅
library(dplyr)
library(ggplot2)
library(tidyr)
setwd("/Users/cpprhtn/Desktop/git_local/Corona-19_made_JW/코로나/data")
#https://www.kaggle.com/kimjihoo/coronavirusdataset/data?select=Weather.csv
#누적 확진, 완치, 사망 
time <- read.csv("Time.csv")
time_sel <- time %>% select(date, confirmed, released, deceased)
time_raw <- time_sel %>% gather(type, number, -date)
time_raw$date <- as.Date(time_raw$date)
ggplot(time_raw, aes(x = date, y = number, color = type)) + 
  geom_line(lwd = 2) +
  scale_x_date(breaks = "month") +
  xlab(label = "Date") +
  ylab(label = " ") +
  ggtitle("Cumulative number of confirmed, completed, and deceased") +
  theme(text=element_text(color="grey50")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))

#검색 트렌드
trend <- read.csv("SearchTrend.csv")
trend_raw <- gather(trend, keyword, volume, -date)
trend_raw$date <- as.Date(trend_raw$date)
min <- as.Date("2020-02-01")
max <- as.Date("2020-04-30")
trend_raw %>% ggplot(aes(x=date, y=volume, color=keyword)) +
  geom_line(lwd = 2) + scale_x_date(breaks = "month", limits = c(min, max)) +
  xlab(label = "Date") +
  ylab(label = "Number of searches") + ylim(0,90) +
  ggtitle("Search Trend") +
  theme(text=element_text(color="grey50")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))

#성별에 따른 누적 확진자 수
gender <- read.csv("TimeGender.csv")
mu_gender <- mutate(gender, death_rate = deceased/confirmed)
mu_gender$date <- as.Date(mu_gender$date)
mu_gender %>% ggplot(aes(x = date, y = confirmed, fill = sex)) +
  geom_bar(stat = "identity", position = "dodge") +
  scale_x_date(breaks = "month") +
  xlab(label = "Date") +
  ylab(label = "number of confirmed cases") +
  ggtitle(label = "Cumulative number of confirmed cases by gender") +  
  theme(text=element_text(color="grey50")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))

#연령대별 확진자수 및 사망률
age <- read.csv("TimeAge.csv")
mu_age <- aggregate(cbind(confirmed,deceased)~age, age, sum) %>%
  mutate(age, death_rate = deceased/confirmed)
mu_age %>% ggplot() +
  geom_bar(mapping = aes(x = age, y = confirmed/1000000), 
           stat = "identity", width=0.5, fill = "steelblue") +
  geom_point(mapping = aes(x = age, y = death_rate), 
             size = 2, shape = 24, fill = "red") + xlab(label = "Age") +
  scale_y_continuous(name = expression("mortality"), 
                     sec.axis = sec_axis(~ . *1000000, name = "number of confirmed cases")) +
  ggtitle("Confirmed number and mortality by age group") +
  theme(text=element_text(color="grey50")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))


#연령, 성별에 따른 확진자 수
info <- read.csv("Patientinfo.csv")
info %>% filter(sex != '') %>% filter(age != '') %>%
  group_by(age, sex) %>% summarise(N=n()) %>%
  ggplot(aes(x=age, y=N, fill=sex)) + 
  geom_bar(stat="identity", position=position_dodge()) +
  ggtitle("Number of confirmed cases by age and gender") +
  xlab(label = "Age") +
  ylab(label = "number of confirmed cases") +
  theme(text=element_text(color="grey50")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))

#성별에 따른 사망률
ggplot(mu_gender, aes(x=date, y=death_rate, color=sex)) + 
  geom_point() + geom_line() +
  scale_x_date(breaks = "month") +
  xlab(label = "Date") +
  ylab(label = "mortality") +
  ggtitle(label = "gender-based mortality") +  
  theme(text=element_text(color="grey50")) +
  theme(axis.title=element_text(size=15)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))

#지역별 확진자 수
province <- read.csv("TimeProvince.csv")
province$date <- as.Date(province$date)
ggplot(province, aes(date,confirmed)) + geom_line() +
  scale_x_date(breaks = "month") +
  facet_wrap(~province, scales="free_y") +
  xlab(label = "Date") +
  ylab(label = "number of confirmed cases") +
  ggtitle(label = "Cumulative number of regional confirmed cases") +  
  theme(text=element_text(color="grey50")) +
  theme(axis.title=element_text(size=15)) +
  theme(axis.text.x=element_text(angle = 45)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))

#집단 감염자 수
case <- read.csv("Case.csv")
case_2 <- aggregate(confirmed~province+group, case, sum)
ggplot(case_2, aes(x=province, y=confirmed, fill=group)) +
  geom_bar(stat="identity", position=position_dodge()) +
  xlab(label = "Area") +
  ylab(label = "number of confirmed cases") +
  ggtitle(label = "Number of collective infections by region") +  
  theme(text=element_text(color="grey50")) +
  theme(axis.title=element_text(size=15)) +
  theme(axis.text.x=element_text(angle = 45)) +
  theme(plot.title=element_text(hjust = 0.5, size=20, color="steelblue"))
