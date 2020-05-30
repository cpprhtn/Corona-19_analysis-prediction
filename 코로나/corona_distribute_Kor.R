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
plot(x=dd$time,y=dd$confirm,type = "o", col = "red", main = "Kor_increasing_trend",
     xlab = "Date", ylab = "confirm",lty =6, sub = "red = confirm, blue = heal, black = dead")
lines(dd$time,dd$cum_heal,col="blue")
points(dd$time,dd$cum_heal,col="blue")
lines(dd$time,dd$cum_dead)
points(dd$time,dd$cum_dead)
