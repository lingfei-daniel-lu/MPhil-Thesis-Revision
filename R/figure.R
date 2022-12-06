setwd("~/GitHub/MPhil-Thesis-Revision/R")

library(ggplot2)
library(lubridate)
library(readxl)

mydata <- read_xlsx("figure.xlsx")

colnames(mydata) <- c("Currency","Year","NER","RER")

ggplot(data=mydata,aes(x=Year,y=NER,group=Currency,color=Currency,shape=Currency))+
  geom_point()+
  geom_line()+
  xlab("Year")+
  ylab("Nomimal Exchange Rate")+
  theme_bw() + theme(panel.grid=element_blank())
  ggsave("figure1.eps", width = 6.5, height = 3.0, device = cairo_ps)


ggplot(data=mydata,aes(x=Year,y=RER,group=Currency,color=Currency,shape=Currency))+
  geom_point()+
  geom_line()+
  xlab("Year")+
  ylab("Real Exchange Rate")+
  theme_bw() + theme(panel.grid=element_blank())
  ggsave("figure2.eps", width = 6.5, height = 3.0, device = cairo_ps)