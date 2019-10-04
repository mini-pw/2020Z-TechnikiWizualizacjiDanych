install.packages("BetaBit")
library(BetaBit)
library(dplyr)


proton()


employees[employees$name=="John" & employees$surname=="Insecure",]$login -> log  #login johnis


for (pass in top1000passwords) {
  proton(action = "login", login=log, password=pass) -> temp
  if(temp == "Success! User is logged in!") {pass -> temp2}
}      #login slap haslo q1w2e3r4t5


proton(action = "login", login=log, password=temp2)


employees[employees$name=="Slawomir" & employees$surname=="Pietraszko",]$login

logs[logs$login=="slap",] -> logs2
logs2[order(logs2$host),]
count(logs2, host)    #host 194.29.178.16


proton(action = "server", host="194.29.178.16", hint=TRUE)


grep("^\\w+", bash_history, value=TRUE)
strsplit(bash_history, " ")

unlist(strsplit(bash_history, " ")) -> tmp3
unique(tmp3)    #haslo DHbb7QXppuHnaXGN


proton(action = "login", login="slap", password="DHbb7QXppuHnaXGN")


#done
