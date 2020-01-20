library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(r2d3)
library(plotly)

dragons <- miceadds::load.Rdata2("dragons.rda")

dragons1<-dragons%>%
  mutate(id=1:2000)%>%
  mutate(year_of_death=year_of_birth+life_length)%>%
  mutate(alive=case_when(
    year_of_death >= 2020 ~ "Alive",
    TRUE ~ "Dead"
  ))%>%
  arrange(year_of_birth)

ggplot(dragons1)+
  geom_segment( aes(x=id, xend=id, y=year_of_birth, yend=year_of_death), color="grey") +
  geom_point( aes(x=id, y=year_of_birth, colour=alive), size=0.5 ) +
  geom_point( aes(x=id, y=year_of_death, colour=alive),  size=0.5 ) +
  coord_flip()+
  facet_wrap(~colour, nrow=2)+
  ggtitle("Are dragons still around in 2020?!")+
  xlab("")+
  ylab("Year of birth")+
  guides(colour=guide_legend(title="Status"))

alive_dragons<-dragons1%>%
  filter(alive=="Alive")%>%
  group_by(colour)%>%
  summarise(count=n())

all<-alive_dragons%>%
  summarise(count=sum(count))%>%
  mutate(colour="all")%>%
  select(2,1)%>%
  arrange(count)

alive_dragons<-rbind(alive_dragons,all)

smths_wrong<-dragons1%>%
  filter(year_of_discovery<year_of_birth)%>%
  mutate(id=1:28)

ggplot(smths_wrong)+
  geom_segment( aes(x=id, xend=id, y=year_of_birth, yend=year_of_death), color="grey") +
  geom_point( aes(x=id, y=year_of_discovery, colour="Discovery"),  size=2 ) +
  geom_point( aes(x=id, y=year_of_birth, colour="Birth"), size=1.5 ) +
  geom_point( aes(x=id, y=year_of_death, colour="Death"),  size=1.5 ) +
  coord_flip()+
  ggtitle("Dragons discovered before they were even born")+
  xlab("")+
  ylab("Year of birth")+
  theme_classic()+
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank())
