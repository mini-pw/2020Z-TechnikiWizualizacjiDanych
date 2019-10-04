install.packages("BetaBit")
library(BetaBit)
proton()
#1
log <- employees$login[employees$name=='John' & employees$surname=='Insecure']
proton(action = "login", login=log)
#2
for( i in 1:1000){
  proton(action = "login", login=log, password=top1000passwords[i])
}
#3
pLogs<-logs[logs$login==employees$login[employees$surname=='Pietraszko'],'host']
sort(table(pLogs),decreasing = TRUE)[1]
proton(action = "server", host="194.29.178.16")

