# zadanie  1
library("dplyr")

#1 

head(employees)
names(employees)
right_person <- employees[employees$surname=="Insecure",]
right_person

# login użytkownika to "johnins"

#2

head(top1000passwords)
typeof(top1000passwords)

for (i in 1:1000){
  proton(action="login", login="johnins", password=as.array(top1000passwords)[i])
}

#3

head(logs)

pietraszko_login <- employees[employees$surname=="Pietraszko",]
pietraszko_login
# login Pietraszko to "slap"

logs %>%
  filter(login=="slap")%>%
  group_by(host)%>%
  summarise(count=n())

# najczęsciej używany serwer to 194.29.178.16

#4

head(bash_history)


