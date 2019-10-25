library(dplyr)
proton()
names(employees)
employees[(employees$name=="John" & employees$surname=="Insecure"),]
proton(action="login", login="johnins")

for (i in 1:1000){
  proton(action="login", login="johnins", password=top1000passwords[i])
  
} 
pietraszko<-logs%>%
  group_by(login)%>%
  summarise(Count=n())%>%
  arrange(desc(Count))%>%
  slice(1)
pietraszko
pietraszkohosts<-logs[logs$login=="slap",]%>%
  group_by(host)%>%
  summarise(Count=n())%>%
  arrange(desc(Count))
pietraszkohosts
for( i in 1:5){
  proton(action="server", host=pietraszkohosts$host[i])
}

proton(action="server", host="194.29.178.16")

for (i in 1:1000){
  proton(action="login", login="slap", password=commands[i])
} 

