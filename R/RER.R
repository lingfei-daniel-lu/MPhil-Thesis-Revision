setwd("~/GitHub/MPhil-Thesis-Revision/R")

library(ggplot2)
library(haven)

ER <- read_dta("D:/Project C/PWT10.0/RER_99_11_figure.dta")

colnames(ER) <- c("Currency","Year","NER","RER")

ER_USD <- subset(ER,ER$Currency=="US Dollar",select = c(Year,NER,RER))

ggplot()+
  geom_point(data=ER_USD,aes(x=Year, y=NER))+
  geom_point(data=ER_USD,aes(x=Year, y=RER))+
  geom_line(data=ER_USD,aes(x=Year, y=NER, linetype = "NER"),size=1)+
  geom_line(data=ER_USD,aes(x=Year, y=RER, linetype = "RER"),size=1)+
  xlab("Year")+
  ylab("Exchange Rates of USD")+
  theme_bw() + theme(panel.grid=element_blank(),legend.title=element_blank())+
  ggtitle("China's Annual Exchange Rate with the U.S. (Base Value in 1999 = 100)")
ggsave("USD.eps", width = 6.5, height = 3.0)

ER_EUR <- subset(ER,ER$Currency=="Euro",select = c(Year,NER,RER))

ggplot()+
  geom_point(data=ER_EUR,aes(x=Year, y=NER))+
  geom_point(data=ER_EUR,aes(x=Year, y=RER))+
  geom_line(data=ER_EUR,aes(x=Year, y=NER, linetype = "NER"),size=1)+
  geom_line(data=ER_EUR,aes(x=Year, y=RER, linetype = "RER"),size=1)+
  xlab("Year")+
  ylab("Exchange Rates of EUR")+
  theme_bw() + theme(panel.grid=element_blank(),legend.title=element_blank())+
  ggtitle("China's Annual Exchange Rate with Eurozone (Base Value in 1999 = 100)")
ggsave("EUR.eps", width = 6.5, height = 3.0)