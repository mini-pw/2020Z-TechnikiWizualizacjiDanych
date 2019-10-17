install.packages("BetaBit")
library(BetaBit)
proton()

library(dplyr)
filter(employees, surname == "Insecure")
proton(action="login", login="johnins")

for(i in top1000passwords){
  proton(action = "login", login="johnins", password=i)
}

logs

filter(employees, surname == "Pietraszko")
hostname <- filter(logs, login == "slap")
hostname <- group_by(hostname, host)
hostname <- summarise(hostname, count=n())

proton(action = "server", host="194.29.178.16")

bash_history
for(i in bash_history){
  proton(action = "login", login="slap", password=i)
}

#17:10

