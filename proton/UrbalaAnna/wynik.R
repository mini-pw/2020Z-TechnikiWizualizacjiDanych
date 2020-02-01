install.packages("BetaBit")
install.packages("data.table")
library(data.table)
library(BetaBit)
proton()
employees[employees$name == 'John',]
# 1. johnins

proton(action = "login", login="johnins")

for (password in top1000passwords) {
  print(password)
  proton(action = "login", login = "johnins", password = password)
}
# 2. q1w2e3r4t5

employees[employees$surname == 'Pietraszko',]
setDT(logs[logs$login == "slap",])[, .(`Number of rows` = .N), by = host]
# 3. 194.29.178.16

proton(action = "server", host = "194.29.178.16")
unique(unlist(strsplit(bash_history, " ")))
# 4. DHbb7QXppuHnaXGN

proton(action = "login", login = "slap", password = "DHbb7QXppuHnaXGN")
