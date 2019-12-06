library("tidyverse")
library("haven")
library("dplyr")
library(ggplot2)
setwd("~/studia/semIII/twd/proj1")
data <- read_sas("./cy6_ms_cmb_stu_qqq.sas7bdat")

library(tmap)
data("World")
eu_iso <- World %>%
  filter(continent == "Europe") %>%
  select(iso_a3)
eu_iso <- eu_iso$iso_a3

wybrane <- data %>% select(c("CNT", "CNTSTUID", "ST004D01T", "ST005Q01TA", "ST006Q01TA" , "ST006Q02TA" , "ST006Q03TA"  ,  "ST006Q04TA" , 
                             "ST007Q01TA" ,   "ST008Q01TA"    ,"ST008Q02TA"  ,  "ST008Q03TA"   , "ST008Q04TA" ,"ST118Q01NA" ,   "ST118Q02NA",
                             "ST118Q03NA"  ,  "ST118Q04NA"  ,  "ST118Q05NA"  ,  "ST119Q01NA" ,   "ST119Q02NA" ,   "ST119Q03NA" ,   "ST119Q04NA"  ,  "ST119Q05NA", 
                             "PV1MATH", "PV1READ", "PV1SCIE","ST071Q01NA"  ,  "ST071Q02NA" ,   "ST071Q03NA"   , "ST071Q04NA"   , "ST071Q05NA" ))

colnames(wybrane) <- c("Country", "StudentId", "SEX", "WM1", "WM2a", "WM2b", "WM2c", "WM2d", "WO1", 
                       "WO2a", "WO2b", "WO2c", "WO2d", "NERW1", "NERW2", "NERW3", "NERW4", "NERW5",
                       "AMB1", "AMB2", "AMB3", "AMB4", "AMB5", "MATH", "READING", "SCIENCE", "T1", "T2", "T3", "T4", "T5")

wybrane <- wybrane %>% filter(Country %in% eu_iso)

bully <- read_sas("./cy6_ms_cmb_stu_qq2.sas7bdat") %>% select(c(2,4,14,15,16,17,18,19,20,21))
colnames(bully)
colnames(bully) <- c("Country", "StudentId", "B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8")
wybrane <- merge(wybrane, bully, by="StudentId")



wybrane$SUMANERW <- wybrane$NERW1 + wybrane$NERW2 + wybrane$NERW3 + wybrane$NERW4 +wybrane$NERW5
wybrane$SUMAPUNKTOW <- wybrane$MATH + wybrane$READING + wybrane$SCIENCE
wybrane$SUMAAMB <- wybrane$AMB1 + wybrane$AMB2 +  wybrane$AMB3 + wybrane$AMB4 + wybrane$AMB5
wybrane$SUMAWYKRODZ <- wybrane$WM1 + wybrane$WO1
wybrane$SUMABULLY <- wybrane$B1 + wybrane$B2 + wybrane$B3 + wybrane$B4 + wybrane$B5 + wybrane$B6 + wybrane$B7 + wybrane$B8
wybrane$SUMATIME <- wybrane$T1 + wybrane$T2 + wybrane$T3 + wybrane$T4 + wybrane$T5

nerw_country <- wybrane %>% group_by(Country.x) %>% summarise(mean_nerw = mean(SUMANERW, na.rm=TRUE))
nerw_country_sex <- wybrane %>% group_by(Country.x,SEX) %>% summarise(mean_nerw = mean(SUMANERW, na.rm=TRUE))


#wykres sredniej liczby punktow od stresu
x <- wybrane %>% group_by(SUMANERW, SEX) %>% summarise(mean_pkt = mean(SUMAPUNKTOW,na.rm=TRUE), median_pkt = median(SUMAPUNKTOW, na.rm = TRUE)) 

ggplot(x, aes(x=SUMANERW, y=mean_pkt)) + 
  geom_line(data=subset(x, SEX==1), color="red", alpha=0.6, size=2) +
  geom_line(data=subset(x, SEX==2), color="blue", alpha=0.6, size=2)+ geom_smooth(method="lm")

#wykres ?rednio sp?dzonego czasu nad nauk? wzgl?dem nerwowoci
stres_time <- wybrane  %>% group_by(SUMANERW,SEX) %>% summarise(mean_time= mean(SUMATIME, na.rm=TRUE))

ggplot(stres_time, aes(x=SUMANERW, y=mean_time)) + geom_line(data=subset(stres_time, SEX==1), color="red", size=2)+
  geom_line(data=subset(stres_time, SEX==2), color="blue", size=2) + ylim(0,40) + geom_smooth(method="lm", color="black")


stres_time_filtered  <- wybrane  %>%filter(SUMATIME<72) %>%  group_by(SUMANERW,SEX) %>% summarise(mean_time= mean(SUMATIME, na.rm=TRUE))

ggplot(stres_time_filtered, aes(x=SUMANERW, y=mean_time)) + geom_line(data=subset(stres_time_filtered, SEX==1), color="red", size=2)+
  geom_line(data=subset(stres_time_filtered, SEX==2), color="blue", size=2) + ylim(0,40) + geom_smooth(method="lm", color="black")



#histogram
wybrane$SUMANERW <- (wybrane$SUMANERW)-5

ggplot(wybrane ,aes(x=SUMANERW)) + 
  geom_histogram(data=subset(wybrane,SEX == 1),fill = "red", alpha = 0.35, binwidth=0.5) +
  geom_histogram(data=subset(wybrane,SEX == 2),fill = "blue", alpha = 0.35, binwidth=0.5)+
  theme_minimal() +
  xlab("Współczynnik stresu") + theme(panel.grid.major = element_blank(),panel.grid.minor=element_blank())+
  theme(plot.title = element_text(size=16, hjust=0.5, face="bold", color="gray30"), axis.title=element_text(size=15, color="gray30"))+
  ylab("Ilość uczniów") +theme(axis.text = element_text(size=9), axis.ticks=element_blank()) +
  ggtitle("Histogram współczynnika stresu w europie z podziałem na płci")


# mapka

Z <- wybrane %>%
  mutate(Nerves = NERW1 + NERW2 + NERW3 + NERW4 + NERW5, Country = Country.x) %>%
  select(Country, Nerves) %>%
  filter(!is.na(Nerves)) %>%
  mutate(Nerves = Nerves - 5) %>%
  group_by(Country) %>%
  summarize(Nerves = mean(Nerves))

World <- merge(World, Z, by.x = "iso_a3", by.y = "Country", all.x = TRUE)

tmap_mode("view")
tmap_style("white")
tm_shape(World[World$continent == "Europe", ]) + 
  tm_polygons("Nerves", palette = "Reds", style = "jenks") + 
  tm_layout(bg.color = "white")

#?redni wynik w zalezno?ci od stresu
x <- wybrane %>% group_by(SUMANERW, SEX) %>% summarise(mean_pkt = mean(SUMAPUNKTOW,na.rm=TRUE), median_pkt = median(SUMAPUNKTOW, na.rm = TRUE)) 

ggplot(x, aes(x=SUMANERW, y=mean_pkt)) + 
  geom_line(data=subset(x, SEX==1), color="red", size=2, alpha=0.5) +
  geom_line(data=subset(x, SEX==2), color="blue", alpha=0.5, size=2)+
  theme_minimal()+
  ylab("średnia zsumowanego wyniku z testu") + xlab("Współczynnik stresu")+
  theme(panel.grid.major = element_blank(), panel.grid.minor=element_blank())+ylim(1300,1600) +
  theme(plot.title = element_text(size=16, hjust=0.5, face="bold", color="gray30"), axis.title=element_text(size=13, color="gray30"))+
  ggtitle("średni wynik testu w zależności od wspołczynnika stresu\n z podziałem na płci")
#histogram nerw


ggplot(wybrane ,aes(x=SUMANERW)) + 
  geom_histogram(data=subset(wybrane,SEX == 1),fill = "red", alpha = 0.35, binwidth=0.5) +
  geom_histogram(data=subset(wybrane,SEX == 2),fill = "blue", alpha = 0.35, binwidth=0.5)+
  xlab("Współczynnik stresu") + theme(panel.grid.major = element_blank(),panel.grid.minor=element_blank())+
  ylab("Ilość uczniów") + theme(axis.text = element_text(size=14), axis.ticks=element_blank()) +
  theme_minimal()



# new map

suppressPackageStartupMessages(library(sf))

world <- st_as_sf(rnaturalearth::countries110)
europe <- dplyr::filter(world, region_un=="Europe" & name!='Russia')

# A bounding box for continental Europe.
europe.bbox <- st_polygon(list(
  matrix(c(-25,29,45,29,45,75,-25,75,-25,29),byrow = T,ncol = 2)))

europe.clipped <- left_join(suppressWarnings(st_intersection(europe, st_sfc(europe.bbox, crs=st_crs(europe)))), Z, by = c("iso_a3" = "Country"))

ggplot(europe.clipped, aes(fill=Nerves)) +
  geom_sf(alpha=0.8,col='white') +
  coord_sf(crs="+proj=aea +lat_1=36.333333333333336 +lat_2=65.66666666666667 +lon_0=14") +
  hrbrthemes::theme_ipsum_rc() +
  viridis::scale_fill_viridis(option = 'magma', name='Średni\nwspółczynnik\nstresu', direction = -1) +
  labs(x=NULL, y=NULL, title=NULL) +
  ggtitle("Średni współczynnik stresu w europie")
