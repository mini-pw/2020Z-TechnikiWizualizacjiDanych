# ŁADOWANIE BILIOTEK I DANYCH
library("tidyverse")
library("haven")
library("dplyr")
library("reshape2")

data<-read_sas("C:/Users/marty/OneDrive/Dokumenty/TWD/Projekt1/cy6_ms_cmb_stu_qqq.sas7bdat")
school<-read_sas("C:/Users/marty/OneDrive/Dokumenty/TWD/Projekt1/cy6_ms_cmb_sch_qqq.sas7bdat")
## wczytujemy informacje na temat kraj (numer-nazwa) - wyciagniete z excela opisujacego dane
countries<-read.csv("C:/Users/marty/OneDrive/Dokumenty/TWD/Projekt1/countries.csv", sep=";")

# 1. ŚRODOWISKO
# wyciagamy odpowiedzi na pytania zwiazane ze srodowiskiem naturalnym
# 1- greenhouse gases
# 2- GMO
# 3- nuclear waste
# 4- deforestation
# 5- air pollution
# 6- extinction of plants and animals
# 7- water shortage
# z informacją o kraju


question_env<-na.omit(data[, c(1,3, grep("ST092", colnames(data)))])
countries_env<-unique(question_env[1])

## w oryginalnej punktacji
# 1- nigdy nie słyszałem o tym zagadnieniu
# 2- coś słyszałem, nie umiałbym wyjaśnić
# 3- umiałbym trochę wyjaśnić
# 4- umiałbym dobrze wyjaśnić
# odejmiemy od każdej kolumny 1 tak żeby za brak wiedzy było 0 pkt

colnames(question_env)<-c("country","school","q1","q2","q3","q4","q5","q6","q7")
question_env<-question_env%>%
  mutate(q1=q1-1,
         q2=q2-1,
         q3=q3-1,
         q4=q4-1,
         q5=q5-1,
         q6=q6-1,
         q7=q7-1)

by_countries_env<-question_env%>% 
  group_by(country)%>%
  summarise_each(funs(mean),q1,q2,q3,q4,q5,q6,q7)%>%
  mutate(score=(q1+q2+q3+q4+q5+q6+q7)/7)%>%
  arrange(desc(score))

## dodajemy nazwę kraju do by_countries_env
by_countries_env<-by_countries_env%>% left_join(countries[,c(1,2)],
                         by=c("country"="NEWVAL"))
## pożądana kolejnosc (wg wyniku)
order<-factor(by_countries_env$LABEL,
              levels=by_countries_env$LABEL)

## Wykres 1 -Swiadomość w poszczególnych krajach
ggplot(by_countries_env, aes(x=LABEL, y=score))+
  geom_col()+
  scale_x_discrete(limits = order)+
  theme(
    axis.text.x=element_text(angle=60, hjust=1, size=6)
  )+
  labs(title="Świadomość na temat środowiska naturalnego w poszczeóglnych krajach",
       xlab="kraj",
       ylab="wynik")

# 2. POLSKA
poland_env<-by_countries_env%>%
  filter(LABEL=="Poland")%>%
  melt()%>%
  slice(2:8)
poland_env<-poland_env[,c(2,3)]
colnames(poland_env)<-c("variable", "mean_pol")

mean_question_env<-melt(by_countries_env[,c(2:8,10)])%>%
  group_by(variable)%>%
  summarise(mean_all=mean(value))

poland_env<-poland_env%>%
  inner_join(mean_question_env, by=c("variable"="variable"))

poland_env<-arrange(poland_env,-mean_all)

colnames(poland_env)<-c("Pytanie", "Polska", "Reszta Świata")
order_env<-factor(poland_env$Pytanie,
              levels=poland_env$Pytanie)
poland_env<-melt(poland_env)

# Wykres 2 - Polska w porównaniu do wszystkich

ggplot(data=poland_env,aes(x=Pytanie, y=value, fill=variable))+
  geom_col(position="dodge")+
  xlab("pytanie")+
  ylab("wynik")+
  labs(fill="Obszar")+
  scale_x_discrete(limits=order_env,
                   labels=c("air pollution",
                            "extinction",
                            "deforestation",
                            "water shortage",
                            "greenhouse gases",
                            "nuclear waste",
                            "GMO"))+
  ggtitle("Wyniki Polski na tle średniej ogólnoświatowej")
 
# 3. WYNIKI W NAUCE (tu nie ma wykresu, ale potem się przyda)

cols_res<-grep("PV1[A-Z]*$", colnames(data))
question_res<-na.omit(data[, c(1,3,4, grep("PV1[A-Z]*$", colnames(data)))])
by_countries_res<-question_res%>%
  group_by(CNTRYID)%>%
  summarise_each(funs(mean),
                 3:12)
by_countries_res<-by_countries_res%>% left_join(countries[,c(1,2)],
                                            by=c("CNTRYID"="NEWVAL"))
# by_countries_res<-melt(by_countries_res)%>%filter(variable!="CNTRYID")

# 4. Środowisko według wielkosci miasta

schools_citysize<-na.omit(school[,c("CNTSCHID", "SC001Q01TA")])
colnames(schools_citysize)<-c("school", "size")

# Wykres 4 - wielkosc miasta a srodowisko
by_schools_env<-inner_join(question_env, schools_citysize,
                          by=c("school"="school"))%>%
  mutate(score=(q1+q2+q3+q4+q5+q6+q7)/7)%>%
  arrange(size)

ggplot(by_schools_env, aes(x=size, y=score, group=size, fill=size))+
  geom_boxplot()+
  scale_x_discrete(limits=c(1,2,3,4,5),
                   labels=c("village","small town","town","city","large city"))+
  guides(fill=FALSE)+
  ggtitle("Świadomość na temat zagadnień związanych ze środowiskiem naturalnym")+
  labs(subtitle = "Według wielkości miejsca zamieszkania")

# 5. Wyniki według wielkosci miasta

by_schools_res<-inner_join(question_res, schools_citysize,
                           by=c("CNTSCHID"="school"))%>%
  mutate(score = rowMeans(select(., starts_with("PV1")), na.rm = TRUE))%>%
  arrange(size)

# Wykres 5 - wielkosc miasta a wyniki
ggplot(by_schools_res, aes(x=size, y=score, group=size, fill=size))+
  geom_boxplot()+
  scale_x_discrete(limits=c(1,2,3,4,5),
                   labels=c("village","small town","town","city","large city"))+
  guides(fill=FALSE)+
  ggtitle("Wyniki testów PISA")+
  labs(subtitle = "W zależności od wielkości miejsca zamieszkania")


# 6. Polska, USA i Singapur

sup_res<-inner_join(question_res,countries[,c("NEWVAL", "LABEL")],
                    by=c("CNTRYID"="NEWVAL"))%>%
  filter(LABEL %in% c("Singapore", "Poland", "United States"))
sup_res<-sup_res[,c(15,4,5,6)]%>%
  rename(MATH=PV1MATH, READING=PV1READ, SCIENCE=PV1SCIE)%>%
    melt()

# Wykres 6
ggplot(sup_res, aes(x=LABEL, y=value))+
  geom_boxplot(aes(fill=variable))+
  ggtitle("Rozkład wyników")+
  xlab("")+
  ylab("wynik")

# 7. Porównanie środowiska i wyników
## Centryle

centile_vector<-function(v){
  cv<-(v-min(v))/(max(v)-min(v))*100
  return(cv)
}
centile_env<-by_countries_env[,c("LABEL", "score")]%>%
  mutate(env_centile=centile_vector(score))

centile_res<-by_countries_res%>%
  mutate(score=(PV1MATH+PV1READ+PV1SCIE)/3,
         res_centile=centile_vector(score))

centile_res<-centile_res[c("LABEL","res_centile")]
centile<-inner_join(centile_env, centile_res, by=c("LABEL"="LABEL"))%>%
  mutate(score=(env_centile+res_centile)/2)%>%
  arrange(desc(score))%>%
  slice(1:10)
colnames(centile)<-c("LABEL", "score", "wyniki testu", "środowisko")
order_centile<-factor(centile$LABEL,
              levels=centile$LABEL)
centile<-melt(centile[,c("LABEL","środowisko", "wyniki testu")])
colnames(centile)<-c("Kraj", "Kategoria", "centyl")

# Wykres 7
ggplot(centile, aes(x=Kraj, y=centyl))+
  geom_col(aes(fill=Kategoria))+
  scale_x_discrete(limits=order_centile)+
  ggtitle("Państwa o najlepszych wynikach i świadomości środowiskowej")+
  xlab("Kraj")+
  ylab("centyle")
