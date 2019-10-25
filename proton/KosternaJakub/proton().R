#70 minut

install.packages("BetaBit")
library(BetaBit)
proton()

#1
employees
employees[employees[,2] == "johnins",]
employees[employees[,2] == "Pietraszko",]
proton(action = "login", login = "johnins", password = top1000passwords[which])
proton(action = "login", login = "Pietraszko", password = top1000passwords[which])

#2
top1000passwords
which <- (1:1000)
for (pass in which)
  proton(action = "login", login = "johnins", password = top1000passwords[pass])

#3
logs

sort(table(logs[(logs[,1] == "slap"),][,2]), decreasing = TRUE)

#194.29.178.13 194.29.178.81  194.29.178.56  194.29.178.84
#65             29              9              1 - tu mamy logi johninsa, to jest złe oczywiście
proton(action = "server", host = "194.29.178.16")

#4
bash_history

library(stringr)
amazing <- word(bash_history, 1)
amazing

which <- (1:19913)
for (pass in (1:19913))
  proton(action = "login", login = "slap", password = amazing[pass])

#Hurra!
