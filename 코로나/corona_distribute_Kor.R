install.packages("remotes")
library('remotes')
library('nCov2019')
library(ggplot2)

#세계누적 요약 데이터
ggplot(d, aes(as.Date(date, "%m.%d"), as.numeric(confirm))) +
  geom_col(fill = 'firebrick') + 
  theme_minimal(base_size = 14) +
  xlab(NULL) + ylab(NULL) + 
  scale_x_date(date_labels = "%Y/%m/%d") +
  labs(caption = paste("accessed date:", time(x)))


# Korea
nCov2019_set_country('South Korea') 
Kor <- load_nCov2019(lang = 'en', source = 'github')
head(kor['province'])
Kor["province"] -> Kor_Data
# Japan
nCov2019_set_country('Japan') 
Jp["province"] -> Jp_Data
Jp_Data

str(Kor["province"])

require(dplyr)
require(ggplot2)
require(shadowtext)
require(nCov2019)
d <- load_nCov2019()
dd <- d['global'] %>% 
  as_tibble %>%
  rename(confirm=cum_confirm) %>%
  filter(confirm > 100 & country == "South Korea") %>%
  group_by(country) %>%
  mutate(days_since_100 = as.numeric(time - min(time))) %>%
  ungroup 
breaks=c(100, 200, 500, 1000, 2000, 5000, 10000, 20000, 50000, 100000)
p <- ggplot(dd, aes(days_since_100, confirm, color = country)) +
  geom_smooth(method='lm', aes(group=1),
              data = . %>% filter(!country %in% c("Japan", "Singapore")), 
              color='grey10', linetype='dashed') +
  geom_line(size = 0.8) +
  geom_point(pch = 21, size = 1) +
  scale_y_log10(expand = expansion(add = c(0,0.1)), 
                breaks = breaks, labels = breaks) +
  scale_x_continuous(expand = expansion(add = c(0,1))) +
  theme_minimal(base_size = 14) +
  theme(
    panel.grid.minor = element_blank(),
    legend.position = "none",
    plot.margin = margin(3,15,3,3,"mm")
  ) +
  coord_cartesian(clip = "off") +
  geom_shadowtext(aes(label = paste0(" ",country)), hjust=0, vjust = 0, 
                  data = . %>% group_by(country) %>% top_n(1, days_since_100), 
                  bg.color = "white") +
  labs(x = "date", y = "number", 
       subtitle = "Korea increasing trend")
print(p)


#install.packages("maps")
library('maps')
x = get_nCov2019(lang = 'en')
plot(x)
plot(x, region = 'South Korea')

#install.packages("devtools") 

write.csv(dd, "/Users/cpprhtn/Desktop/Kor_data2.csv")
getwd()

#시각화
plot(x=Kor_Data$time, y=Kor_Data$cum_confirm)
p <- ggplot(Kor_Data, aes(time, cum_confirm))
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

4시기준 확진, 사망자, 완치

1/21 1,0,0
1/24 2,0,0
27 4,0,0
30 7,0,0
31 11,0,0
2/1 12,0,0
2/2 15,0,0
2/3 15,0,0
2/4 16,0,0
2/5 21,0,1
6 24,0,2
9 27,0,3
10 27,0,4
11 28,0,4
12 28,0,7
15 28,0,9
16 29,0,9
17 30,0,10

2/18일 4시기준 확진 31,  격리해제 10, 사망자 0
19  51, 16, 0

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

str(kk)
kk$time <- as.Date(kk$time)
kk$confirm <- as.integer(kk$confirm)
kk$cum_heal <- as.integer(kk$cum_heal)
kk$cum_dead <- as.integer(kk$cum_dead)

newd <- dd[,c(1,3,4,5)]

kor_coda <- rbind(kk,newd)
write.csv(kor_coda, "/Users/cpprhtn/Desktop/Kor_coda.csv")


update_coda <- dd[103,c(1,3,4,5)]
kor_coda <- rbind(kor_coda,update_coda)

fit <- lm(kor_coda$confirm ~ kor_coda$time)
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

