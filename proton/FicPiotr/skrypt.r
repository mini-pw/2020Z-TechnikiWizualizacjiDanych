install.packages("BetaBit")
library(BetaBit)
proton()
head(employees)
tail(employees)
employees[employees$surname=='Insecure',]
proton(action = "login", login="johnins")

head(top1000passwords)
for (haslo in top1000passwords) {
  proton(action = "login", login="johnins", password=haslo)
}

head(logs)
library(dplyr)

employees[employees$surname=='Pietraszko',]
hosty <- logs[logs$login=='slap',]
hosty <- group_by(hosty, by = hosty$host)
dplyr::count(hosty)
proton(action = "server", host="194.29.178.16")

head(bash_history)
bash <- bash_history
unique(sub(' .*', '', bash_history))

proton(action = "login", login="slap", password='DHbb7QXppuHnaXGN')
