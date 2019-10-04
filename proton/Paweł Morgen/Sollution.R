install.packages("BetaBit")
library(BetaBit)
library(dplyr)
library(stringi)
employees%>%View()
#Szukamy loginu:
employees[employees$name=="John" & employees$surname=="Insecure",3]
#Odp:johnins
#Szukamy hasła
proton(action="login", login="johnins")
passwords<-top1000passwords
sapply(passwords, 
       function(x) proton(action="login",login="johnins",password=x)%>%as.character())->outcomes
passwords[which(stri_detect_fixed(outcomes, "Success"))]
#Odp: q1w2e3r4t5
proton(action="login",login="johnins",password="q1w2e3r4t5")

#Szukamy loginu Pietraszki:
filter(employees, surname=="Pietraszko")
#Wychodzi: slap.
filter(logs, login=="slap")%>%group_by(host)%>%summarise(Count=n())%>%arrange(desc(Count))->Serwers_Count
Serwers_Count$host[1]
proton(action="server",host="194.29.178.16")
#Odp: 194.29.178.16

stri_match_first_regex(bash_history, "[^\\s]+")->possible_passwords #Szukamy niezerowego ciągu znaków niebędących spacją
unique(possible_passwords)
#Odp: DHbb7QXppuHnaXGN
proton(action="login", login="slap", password="DHbb7QXppuHnaXGN")



