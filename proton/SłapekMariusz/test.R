install.packages("BetaBit")
library(BetaBit)
proton()

# 1
employees[employees$name=="John" & employees$surname=="Insecure", ]$login
proton(action = "login", login="johnins")


# 2
top1000passwords
typeof(top1000passwords)

for (i in 1:length(top1000passwords)) { 
  answer = proton(action = "login", login="johnins", password=as.character(  top1000passwords[i]))
}

# 3

Logs = logs
hostVector = logs$host
  

#proton(action = "server", host="194.29.178.91")

sortLogs <- names(sort(table(hostVector),decreasing=TRUE))

proton(action = "server", host=as.character(sortLogs[1]))
proton(action = "server", host=as.character(sortLogs[2]))
proton(action = "server", host=as.character(sortLogs[3]))
proton(action = "server", host=as.character(sortLogs[4]))

# 4
bashHistory <- bash_history

library(stringi)
library(stringr)

passwords = c()

for (i in 1:length(bashHistory)) { 
  passwords <- c(passwords, str_extract(bashHistory[i], "[^ ]* "))
  #print(str_extract(bashHistory[i], "[a-z, A-Z, 0-9]* "))
}

unique(strsplit(bashHistory, " "))

proton(action = "login", login="slap", password="DHbb7QXppuHnaXGN")

