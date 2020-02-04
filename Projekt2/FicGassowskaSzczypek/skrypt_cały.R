library(dplyr)
library(lubridate)
library(wordcloud)
library(RColorBrewer)
library(wordcloud2)
library(tm)
library(stringi)
library(quanteda)

options(stringsAsFactors = FALSE)
#pobieranie i scie¿kê do projektu trzeba ustawiæ, reszta ju¿ powinna byæ dobrze automatycznie
setwd("E://Pulpit//TWD//projekt_2//repo_R//projekt_twd_2")
df <- read.csv("E://Pulpit//TWD//projekt_2//moje_dane//messenger.csv", encoding="UTF-8")
name_full <-  name <- df$sender_name[min(which(df$sender_name!=df$rozmowca & df$rozmowca!="czat_grupowy"))]
name <- df$sender_name[min(which(df$sender_name!=df$rozmowca & df$rozmowca!="czat_grupowy"))]
name <- gsub( " .*$", "", name) #wszystko przed spacja - samo imie
name <- gsub("[????????]", "-", name) #zamieniam polskie znaki na gwiazdke


dir.create(paste("./aplikacja/dane_",gsub(" ","",name,fixed=TRUE),sep=""))

df1 <- df %>%
  select(c(4,10,11,14)) #zostawiamy tylko kolumny ktore nas itneresuja

## Osoby z ktorymi najwiÄ™cej piszemy (wysÅ‚ane + odebrane)
most_popular_both <- df1 %>%
  group_by(rozmowca) %>%
  summarise(amount = n()) %>%
  arrange(desc(amount)) %>%
  filter(rozmowca != "czat_grupowy")

write.csv(most_popular_both, paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/most_popular_both_",gsub(" ", "", name, fixed = TRUE),".csv",sep=""), fileEncoding = "UTF-8")
## Ilosc wiadomsoci w dane dni tygodnia (wysÅ‚adne + odebrane)

timestamp <- strptime(df1$timestamp_ms, "%Y-%m-%d %H:%M:%S") #wektor dat ale w juÅ¼ w POSIX
tmp <- data.frame(df1,weekdays(timestamp)) # stworzenie nowej ramki danych z nowa kolumna dni tygodnia

top10_both <- most_popular_both %>%
  pull(rozmowca)

weekdays_message_both <- tmp %>%
  select(2,5) %>%
  rename(weekday = weekdays.timestamp.) %>%
  group_by(rozmowca, weekday) %>%
  summarise(amount = n())



## ilosc wiadomosci w z podziaÅ‚em na miesiÄ…ce (wysÅ‚ane + odebrane)

tmp <- data.frame(df1,month(timestamp)) # stworzenie nowej ramki danych z nowa kolumna miesiace

month_message_both <- tmp %>%
  select(2,5) %>%
  rename(month = month.timestamp.) %>%
  group_by(rozmowca, month) %>%
  summarise(amount = n()) %>%
  filter(rozmowca %in% top10_both)



## ilosc wiadomosci w z podziaÅ‚em na godziny (wysÅ‚ane + odebrane) 0 oznacza 00.00 - 01.00, 1 oznacza 01.00 - 02.00 itd.

tmp <- data.frame(df1,hour(timestamp)) # stworzenie nowej ramki danych z nowa kolumna godziny

hour_message_both <- tmp %>%
  select(2,5) %>%
  rename(hour = hour.timestamp.) %>%
  group_by(rozmowca, hour) %>%
  summarise(amount = n()) %>%
  filter(rozmowca %in% top10_both)


###################################################### ÅšREDNIE

## srednia ilosc wiadomosci w z podziaÅ‚em na miesiÄ…ce (wysÅ‚ane + odebrane)

months_amount <- function(date1, date2=as.POSIXlt(Sys.time())){ # funkcja ktora zwraca nam wektor o dlugosci 12, kazda wartosc to dany miesiac, liczy ilsoc wystapien kazdego miesiaca
  # date1 - data od ktorej chcemy liczyc, date2 - data koniec (domyslnie obecna data), 
  year1 <- year(date1)
  year2 <- year(date2)
  month1 <- month(date1)
  month2 <- month(date2)
  month_difference <- 12 * (year2 - year1) + (month2 - month1)
  months_vector <- rep(0,12)
  for (i in month1:(month_difference+month1)) {
    k <- i %% 12
    if(k == 0) k <- 12
    months_vector[k] <- months_vector[k] + 1
  }
  return(months_vector)
}


minutes_difference <- difftime(rep(Sys.time(),length(timestamp)),timestamp,units = "mins") #potrzebujemy roznicy w czasie miedzy teraz a datami zeby znalezc najstarsza
tmp <- data.frame(df1,month(timestamp),minutes_difference) # stworzenie nowej ramki danych z nowa kolumna miesiace

oldest_user_date <- tmp %>% #bierzemy kazdego uzytkownika i najstarsza date dla kazdego z nich
  group_by(rozmowca) %>%
  filter(minutes_difference == max(minutes_difference)) %>%
  select(2,4)

oldest_date <- oldest_user_date %>%
  pull(2)

month_amount <- as.integer()
for (i in 1:length(oldest_date)) { #teraz dla kazdego zutkowniak robimy wektor z ilsocia wystapien akzdego z miesiacow i laczymy to w jedno
  current_user_month_amount <- months_amount(oldest_date[i],Sys.time())
  month_amount <- c(month_amount,current_user_month_amount)
}

user <- oldest_user_date %>% #wektor uzytkownikwo powielony zeby kleilo sie do nowego df
  pull(1)
user <- rep(user, each = 12)

month <- rep(c(1,2,3,4,5,6,7,8,9,10,11,12), times = length(oldest_date)) #wektor meisiecy powielony zeby sie kleilo do df

month_amount_each_user <- data.frame(user, month, month_amount) %>% # nowa ramka osob z meisiacami i ilsocia wystapien akzdego z nich dla kazdego z uzytkownikow
  filter(user %in% top10_both) #ograniczenie ilosci osob do tych top 10 

average_month_message_both <- month_amount_each_user %>% #stworzenie nowej kolumny ze srednia ilsocia wiadomosci na miesiac
  inner_join(month_message_both, c("user"="rozmowca","month"="month")) %>%
  mutate(srednio_na_miesiac = amount/month_amount) %>%
  select(1,2,5)

write.csv(average_month_message_both, paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/month_message_both_",gsub(" ", "", name, fixed = TRUE),".csv",sep=""), fileEncoding = "UTF-8")





## srednia ilosc wiadomsoci w dane dni tygodnia (wysÅ‚ane + odebrane)

days_amount <- function(date1, date2 = as.POSIXlt(Sys.time())){ # funkcja ktora zwraca nam wektor o dlugosci 7, kazda wartosc to dany dzien tyg,
  # liczy ilsoc wystapien kazdego dnai tygodnia, z tym, ze 1szy element wektora to ndz, 2gi to pon, 3ci to wtorek itd.
  # date1 - data od ktorej chcemy liczyc, date2 - data koniec (domyslnie obecna data), 
  day1 <- wday(date1)
  day_difference <- ceiling(as.double(difftime(date2,date1,units = "day")))
  days_vector <- rep(0,7)
  for (i in day1:(day_difference+day1)) {
    k <- i %% 7
    if(k == 0) k <- 7
    days_vector[k] <- days_vector[k] + 1
  }
  return(days_vector)
}

#korzystamy jzu z wektorow i ramek danych ktore utworzylismy w podpunkcie z miesiacami

day_amount <- as.integer()
for (i in 1:length(oldest_date)) { #teraz dla kazdego zutkowniak robimy wektor z ilsocia wystapien akzdego z dni tygodnia i laczymy to w jedno
  current_user_day_amount <- days_amount(oldest_date[i],Sys.time())
  day_amount <- c(day_amount,current_user_day_amount)
}

user <- oldest_user_date %>% #wektor uzytkownikwo powielony zeby kleilo sie do nowego df
  pull(1)
user <- rep(user, each = 7)

day <- rep(c("niedziela","poniedziałek","wtorek","środa","czwartek","piątek","sobota"), times = length(oldest_date)) #wektor dni tygodnia powielony zeby sie kleilo do df

day_amount_each_user <- data.frame(user, day, day_amount) %>% # nowa ramka osob z dniami tygodnia i ilsocia wystapien akzdego z nich dla kazdego z uzytkownikow
  filter(user %in% top10_both) #ograniczenie ilosci osob do tych top 10 

average_day_message_both <- day_amount_each_user %>% #stworzenie nowej kolumny ze srednia ilsocia wiadomosci na dany dzien tygodnia WYNIKOWA
  inner_join(weekdays_message_both, c("user"="rozmowca","day"="weekday")) %>%
  mutate(srednio_na_dzien = amount/day_amount) %>%
  select(1,2,5)

write.csv(average_day_message_both, paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/day_message_both_",gsub(" ", "", name, fixed = TRUE),".csv",sep=""), fileEncoding = "UTF-8")




## srednia ilosc wiadomosci w z podziaÅ‚em na godziny (wysÅ‚ane + odebrane) 0 oznacza 00.00 - 01.00, 1 oznacza 01.00 - 02.00 itd.

hours_amount <- function(date1, date2 = as.POSIXlt(Sys.time())){ # funkcja ktora zwraca nam wektor o dlugosci 24
  #, kazda wartosc to dany kubelek godzinowy,, liczy ilsoc wystapiien kazdego kubelka godzinowego
  # date1 - data od ktorej chcemy liczyc, date2 - data koniec (domyslnie obecna data), 
  hour1 <- hour(date1)
  hour_difference <- ceiling(as.double(difftime(date2,date1,units = "hours")))
  hours_vector <- rep(0,24)
  for (i in hour1:(hour_difference+hour1)) {
    k <- i %% 24
    if(k == 0) k <- 24
    hours_vector[k] <- hours_vector[k] + 1
  }
  return(hours_vector)
}

#korzystamy jzu z wektorow i ramek danych ktore utworzylismy w podpunkcie z miesiacami

hour_amount <- as.integer()
for (i in 1:length(oldest_date)) { #teraz dla kazdego yzytkownika robimy wektor z ilsocia wystapien kazdej z godzin i laczymy to w jedno
  current_user_hour_amount <- hours_amount(oldest_date[i],Sys.time())
  hour_amount <- c(hour_amount,current_user_hour_amount)
}

user <- oldest_user_date %>% #wektor uzytkownikwo powielony zeby kleilo sie do nowego df
  pull(1)
user <- rep(user, each = 24)

hour <- rep(c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,0), times = length(oldest_date)) #wektor godzin powielony zeby sie kleilo do df

hour_amount_each_user <- data.frame(user, hour, hour_amount) %>% # nowa ramka osob z godzinami i ilsocia wystapien kazdej z nich dla kazdego z uzytkownikow
  filter(user %in% top10_both) #ograniczenie ilosci osob do tych top 10 

average_hour_message_both <- hour_amount_each_user %>% #stworzenie nowej kolumny ze srednia ilsocia wiadomosci na dana godzine WYNIKOWA
  inner_join(hour_message_both, c("user"="rozmowca","hour"="hour")) %>%
  mutate(srednio_na_godzine = amount/hour_amount) %>%
  select(1,2,5)

write.csv(average_hour_message_both, paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/hour_message_both_",gsub(" ", "", name, fixed = TRUE),".csv",sep=""), fileEncoding = "UTF-8")




###spedzony czas

wyslane <- df %>% filter(sender_name==name_full) 
#jak chcemy z konkretn¹ osob¹ dodajemy filter(rozmowca==osoba)
wyslane$ilosc_znakow <- nchar(wyslane$content)
wyslane$minuty <- wyslane$ilosc_znakow/190
wyslane$rok <- substring(wyslane$timestamp_ms,1,4)
wyslane$rok_miesiac <- substring(wyslane$timestamp_ms, 1,7)
wyslane$rok_miesiac_dzien <- substring(wyslane$timestamp_ms,1,10)
#czlowiek srednio pisze 190 znakow na minute
total <- c(sum(wyslane$minuty), sum(wyslane$minuty)/60, sum(wyslane$minuty)/(60*24))
pom_year <- data.frame(wyslane %>% group_by(rok) %>% summarise(sum=sum(minuty)))
year_avg <- c(mean(pom_year$sum), mean(pom_year$sum)/60, mean(pom_year$sum)/(60*24))
pom_month <- data.frame(wyslane %>% group_by(rok_miesiac) %>% summarise(sum=sum(minuty)))
month_avg <- c(mean(pom_month$sum), mean(pom_month$sum)/60, mean(pom_month$sum)/(60*24))
pom_day <- data.frame(wyslane %>% group_by(rok_miesiac_dzien) %>% summarise(sum=sum(minuty)))
day_avg <- c(mean(pom_day$sum), mean(pom_day$sum)/60, mean(pom_day$sum)/(60*24))





spedzony_czas <- data.frame(rbind(total, year_avg, month_avg, day_avg))
colnames(spedzony_czas) <- c("minuty", "godziny","dni")
write.csv(spedzony_czas,paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/spedzony_czas_",gsub(" ", "", name, fixed = TRUE),".csv",sep=""), fileEncoding = "UTF-8")



#Pusty df na wynik
result <- data_frame()
wyslane1 <- df %>% filter(sender_name==name_full)
osoby <- unique(wyslane1$rozmowca)
osoby <- osoby[osoby!="czat grupowy"]

#Petla po najpopularniejszych rozmowcach
for(i in seq(1, length(osoby))){
  
  #Kolejny z rozmowcow
  cur <- osoby[i]
  #Filtrowanie
  #jak chcemy z konkretn? osob? dodajemy filter(rozmowca==osoba)
  wyslane <- filter(wyslane1, rozmowca==cur)
  
  wyslane$ilosc_znakow <- nchar(wyslane$content)
  wyslane$minuty <- wyslane$ilosc_znakow/190
  wyslane$rok <- substring(wyslane$timestamp_ms,1,4)
  wyslane$rok_miesiac <- substring(wyslane$timestamp_ms, 1,7)
  wyslane$rok_miesiac_dzien <- substring(wyslane$timestamp_ms,1,10)
  #czlowiek srednio pisze 190 znakow na minute
  total <- c("Total", sum(wyslane$minuty), sum(wyslane$minuty)/60, sum(wyslane$minuty)/(60*24))
  # pom_year <- data.frame(wyslane %>% group_by(rok) %>% summarise(sum=sum(minuty)))
  # year_avg <- c("Year_avg", mean(pom_year$sum), mean(pom_year$sum)/60, mean(pom_year$sum)/(60*24))
  # pom_month <- data.frame(wyslane %>% group_by(rok_miesiac) %>% summarise(sum=sum(minuty)))
  # month_avg <- c("Month_avg", mean(pom_month$sum), mean(pom_month$sum)/60, mean(pom_month$sum)/(60*24))
  # pom_day <- data.frame(wyslane %>% group_by(rok_miesiac_dzien) %>% summarise(sum=sum(minuty)))
  # day_avg <- c("Day_avg", mean(pom_day$sum), mean(pom_day$sum)/60, mean(pom_day$sum)/(60*24))
  
  
  #To jest dla aktualnego rozmowcy
  spedzony_czas1 <- data.frame(rbind(total))
  colnames(spedzony_czas1) <- c("x", "minuty", "godziny","dni")
  spedzony_czas1["osoba"] <- cur
  
  #Append do wynikowej csv
  result <- rbind(result, spedzony_czas1)
  
}

tmp <- data_frame(rozmowca = most_popular_both$rozmowca)
result1 <- tmp %>%
  left_join(result, by = c("rozmowca"="osoba")) %>%
  select(1,3,4,5)
result1[is.na(result1$minuty),2] <- 0
result1[is.na(result1$godziny),3] <- 0
result1[is.na(result1$dni),4] <- 0

write.csv(result1,paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/spedzony_czas_osoby_",gsub(" ", "", name, fixed = TRUE),".csv",sep=""), fileEncoding = "UTF-8")



###

## Ilosc wiadomsoci w dane dni tygodnia (wysÅ‚adne + odebrane)

tmp <- data.frame(df1,weekdays(timestamp)) # stworzenie nowej ramki danych z nowa kolumna dni tygodnia

top10_both <- most_popular_both %>%
  pull(rozmowca)

weekdays_message_both <- tmp %>%
  select(2,5) %>%
  rename(weekday = weekdays.timestamp.) %>%
  group_by(rozmowca, weekday) %>%
  summarise(amount = n())


## ilosc wiadomosci w z podziaÅ‚em na miesiÄ…ce (wysÅ‚ane + odebrane)

tmp <- data.frame(df1,month(timestamp)) # stworzenie nowej ramki danych z nowa kolumna miesiace

month_message_both <- tmp %>%
  select(2,5) %>%
  rename(month = month.timestamp.) %>%
  group_by(rozmowca, month) %>%
  summarise(amount = n())



## ilosc wiadomosci w z podziaÅ‚em na godziny (wysÅ‚ane + odebrane) 0 oznacza 00.00 - 01.00, 1 oznacza 01.00 - 02.00 itd.

tmp <- data.frame(df1,hour(timestamp)) # stworzenie nowej ramki danych z nowa kolumna godziny

hour_message_both <- tmp %>%
  select(2,5) %>%
  rename(hour = hour.timestamp.) %>%
  group_by(rozmowca, hour) %>%
  summarise(amount = n()) #%>%
#filter(rozmowca %in% top10_both)


###################################################### ÅšREDNIE

## srednia ilosc wiadomosci w z podziaÅ‚em na miesiÄ…ce (wysÅ‚ane + odebrane)

months_amount <- function(date1, date2=as.POSIXlt(Sys.time())){ # funkcja ktora zwraca nam wektor o dlugosci 12, kazda wartosc to dany miesiac, liczy ilsoc wystapien kazdego miesiaca
  # date1 - data od ktorej chcemy liczyc, date2 - data koniec (domyslnie obecna data), 
  year1 <- year(date1)
  year2 <- year(date2)
  month1 <- month(date1)
  month2 <- month(date2)
  month_difference <- 12 * (year2 - year1) + (month2 - month1)
  months_vector <- rep(0,12)
  for (i in month1:(month_difference+month1)) {
    k <- i %% 12
    if(k == 0) k <- 12
    months_vector[k] <- months_vector[k] + 1
  }
  return(months_vector)
}


minutes_difference <- difftime(rep(Sys.time(),length(timestamp)),timestamp,units = "mins") #potrzebujemy roznicy w czasie miedzy teraz a datami zeby znalezc najstarsza
tmp <- data.frame(df1,month(timestamp),minutes_difference) # stworzenie nowej ramki danych z nowa kolumna miesiace

oldest_user_date <- tmp %>% #bierzemy kazdego uzytkownika i najstarsza date dla kazdego z nich
  group_by(rozmowca) %>%
  filter(minutes_difference == max(minutes_difference)) %>%
  select(2,4)

oldest_date <- oldest_user_date %>%
  pull(2)

month_amount <- as.integer()
for (i in 1:length(oldest_date)) { #teraz dla kazdego zutkowniak robimy wektor z ilsocia wystapien akzdego z miesiacow i laczymy to w jedno
  current_user_month_amount <- months_amount(oldest_date[i],Sys.time())
  month_amount <- c(month_amount,current_user_month_amount)
}

user <- oldest_user_date %>% #wektor uzytkownikwo powielony zeby kleilo sie do nowego df
  pull(1)
user <- rep(user, each = 12)

month <- rep(c(1,2,3,4,5,6,7,8,9,10,11,12), times = length(oldest_date)) #wektor meisiecy powielony zeby sie kleilo do df

month_amount_each_user <- data.frame(user, month, month_amount) #%>% # nowa ramka osob z meisiacami i ilsocia wystapien akzdego z nich dla kazdego z uzytkownikow
#filter(user %in% top10_both) #ograniczenie ilosci osob do tych top 10 

average_month_message_both1 <- month_amount_each_user %>% #stworzenie nowej kolumny ze srednia ilsocia wiadomosci na miesiac
  inner_join(month_message_both, c("user"="rozmowca","month"="month")) %>%
  mutate(srednio_na_miesiac = amount/month_amount) %>%
  select(1,2,5)


## srednia ilosc wiadomsoci w dane dni tygodnia (wysÅ‚ane + odebrane)

days_amount <- function(date1, date2 = as.POSIXlt(Sys.time())){ # funkcja ktora zwraca nam wektor o dlugosci 7, kazda wartosc to dany dzien tyg,
  # liczy ilsoc wystapien kazdego dnai tygodnia, z tym, ze 1szy element wektora to ndz, 2gi to pon, 3ci to wtorek itd.
  # date1 - data od ktorej chcemy liczyc, date2 - data koniec (domyslnie obecna data), 
  day1 <- wday(date1)
  day_difference <- ceiling(as.double(difftime(date2,date1,units = "day")))
  days_vector <- rep(0,7)
  for (i in day1:(day_difference+day1)) {
    k <- i %% 7
    if(k == 0) k <- 7
    days_vector[k] <- days_vector[k] + 1
  }
  return(days_vector)
}

#korzystamy jzu z wektorow i ramek danych ktore utworzylismy w podpunkcie z miesiacami

day_amount <- as.integer()
for (i in 1:length(oldest_date)) { #teraz dla kazdego zutkowniak robimy wektor z ilsocia wystapien akzdego z dni tygodnia i laczymy to w jedno
  current_user_day_amount <- days_amount(oldest_date[i],Sys.time())
  day_amount <- c(day_amount,current_user_day_amount)
}

user <- oldest_user_date %>% #wektor uzytkownikwo powielony zeby kleilo sie do nowego df
  pull(1)
user <- rep(user, each = 7)

day <- rep(c("niedziela","poniedziałek","wtorek","środa","czwartek","piątek","sobota"), times = length(oldest_date)) #wektor dni tygodnia powielony zeby sie kleilo do df

day_amount_each_user <- data.frame(user, day, day_amount) #%>% # nowa ramka osob z dniami tygodnia i ilsocia wystapien akzdego z nich dla kazdego z uzytkownikow
#filter(user %in% top10_both) #ograniczenie ilosci osob do tych top 10 

average_day_message_both1 <- day_amount_each_user %>% #stworzenie nowej kolumny ze srednia ilsocia wiadomosci na dany dzien tygodnia WYNIKOWA
  inner_join(weekdays_message_both, c("user"="rozmowca","day"="weekday")) %>%
  mutate(srednio_na_dzien = amount/day_amount) %>%
  select(1,2,5)



## srednia ilosc wiadomosci w z podziaÅ‚em na godziny (wysÅ‚ane + odebrane) 0 oznacza 00.00 - 01.00, 1 oznacza 01.00 - 02.00 itd.

hours_amount <- function(date1, date2 = as.POSIXlt(Sys.time())){ # funkcja ktora zwraca nam wektor o dlugosci 24
  #, kazda wartosc to dany kubelek godzinowy,, liczy ilsoc wystapiien kazdego kubelka godzinowego
  # date1 - data od ktorej chcemy liczyc, date2 - data koniec (domyslnie obecna data), 
  hour1 <- hour(date1)
  hour_difference <- ceiling(as.double(difftime(date2,date1,units = "hours")))
  hours_vector <- rep(0,24)
  for (i in hour1:(hour_difference+hour1)) {
    k <- i %% 24
    if(k == 0) k <- 24
    hours_vector[k] <- hours_vector[k] + 1
  }
  return(hours_vector)
}

#korzystamy jzu z wektorow i ramek danych ktore utworzylismy w podpunkcie z miesiacami

hour_amount <- as.integer()
for (i in 1:length(oldest_date)) { #teraz dla kazdego yzytkownika robimy wektor z ilsocia wystapien kazdej z godzin i laczymy to w jedno
  current_user_hour_amount <- hours_amount(oldest_date[i],Sys.time())
  hour_amount <- c(hour_amount,current_user_hour_amount)
}

user <- oldest_user_date %>% #wektor uzytkownikwo powielony zeby kleilo sie do nowego df
  pull(1)
user <- rep(user, each = 24)

hour <- rep(c(1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,0), times = length(oldest_date)) #wektor godzin powielony zeby sie kleilo do df

hour_amount_each_user <- data.frame(user, hour, hour_amount) #%>% # nowa ramka osob z godzinami i ilsocia wystapien kazdej z nich dla kazdego z uzytkownikow
#filter(user %in% top10_both) #ograniczenie ilosci osob do tych top 10 

average_hour_message_both1 <- hour_amount_each_user %>% #stworzenie nowej kolumny ze srednia ilsocia wiadomosci na dana godzine WYNIKOWA
  inner_join(hour_message_both, c("user"="rozmowca","hour"="hour")) %>%
  mutate(srednio_na_godzine = amount/hour_amount) %>%
  select(1,2,5)

######## ZAPIS ###################


write.csv(average_hour_message_both1,paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/hour_all_",gsub(" ", "", name, fixed = TRUE),".csv",sep=""), fileEncoding = "UTF-8")
write.csv(average_month_message_both1,paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/month_all_",gsub(" ", "", name, fixed = TRUE),".csv",sep=""), fileEncoding = "UTF-8")
write.csv(average_day_message_both1,paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/day_all_",gsub(" ", "", name, fixed = TRUE),".csv",sep=""), fileEncoding = "UTF-8")


df_joyplot <- df 
df_joyplot$mr <- substring(df_joyplot$timestamp_ms, 1,7)
ponumerowane_miesiace <- data.frame(cbind(c(1:length(unique(df_joyplot$mr))),sort(unique(df_joyplot$mr))), stringsAsFactors = FALSE)
colnames(ponumerowane_miesiace) <- c("nr", "mr")
ponumerowane_miesiace$nr <- as.numeric(ponumerowane_miesiace$nr)


df_joyplot<- data.frame(df_joyplot %>% group_by(rozmowca, mr) %>% summarise(n=n()))
osoby <- unique(df_joyplot$rozmowca)
osoby <- osoby[osoby!="czat grupowy"]
result_joyplot <- data.frame()
for(i in 1:length(osoby)){
  cur <- df_joyplot %>% filter(rozmowca==osoby[i])
  cur <- merge(cur, ponumerowane_miesiace, by="mr", all.y=TRUE)
  cur$rozmowca <- osoby[i]
  result_joyplot <- rbind(result_joyplot, cur)
}
result_joyplot$n <- ifelse(is.na(result_joyplot$n), 0, result_joyplot$n)
result_joyplot$density <- result_joyplot$n/sum(result_joyplot$n)
write.csv(result_joyplot,paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/joy_chart_",gsub(" ", "", name, fixed = TRUE),".csv",sep=""), fileEncoding = "UTF-8")


#########WORLD CLOUD

dir.create(paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/wordcloud", sep=""))


stopwords_txt <- read.table("./aplikacja/stopwords_app.txt", sep = '\t', encoding = "UTF-8") 


stopwords_vector <- stopwords_txt %>%
  pull(1) %>%
  as.character() %>%
  c("nan")

setwd(paste("./aplikacja/dane_",gsub(" ", "", name, fixed = TRUE),"/wordcloud", sep="")) 

for(i in 1:length(osoby)){
  data <- df %>%
    filter(rozmowca == osoby[i])
  if(length(data$content)<50){
    next
  }
  text <- paste(data$content, collapse = ' ')
  docs <- Corpus(VectorSource(text))
  docs <- docs %>%
    tm_map(removePunctuation) %>%
    tm_map(stripWhitespace) %>%
    tm_map(removeNumbers)
  matrix <- DocumentTermMatrix(
    docs, 
    control = list(tolower = TRUE, stopwords = stopwords_vector)
  )
  matrix <- t(as.matrix(matrix))
  words <- sort(rowSums(matrix),decreasing=TRUE) 
  df_current <- data.frame(word = names(words),freq=words)
  name_cur <- strsplit(osoby[i],split=" ")[[1]]
  name_cur <- paste(name_cur, collapse = "")
  name_cur <- paste("./wordcloud_",name_cur,".csv",sep="")
  write.csv(df_current,file=name_cur,row.names=FALSE, fileEncoding = "UTF-8")
}




