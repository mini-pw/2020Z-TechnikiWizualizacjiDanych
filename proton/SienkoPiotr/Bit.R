install.packages("BetaBit")
library(BetaBit)
proton()

proton(action = "login", login = "johnins")
passwords <- top1000passwords

for(i in top1000passwords){
  proton(action = "login", login="johnins", password = i)
}


Pietraszko <- employees[employees[,2] == "Pietraszko",]
logs_on_server <- logs[logs[,1] == "slap",]


t <- subset(logs_on_server, select = "host")
t <- as.data.frame(table(t))
host <- t[which.max(t$Freq), ]
host_name <- host[1, 1]

#mamy adres hosta
info <- proton(action = "server", host= "194.29.178.16")

for(pass in bash_history){
  proton(action = "login", login="slap", password = pass)
}

