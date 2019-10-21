install.packages("BetaBit")
library(BetaBit)
proton()

emp <- employees
emp[emp$surname== "Insecure",]
proton(action="login", login="johnins")

toppass <- top1000passwords
for (i in toppass){
  if (proton(action="login", login="johnins", password=i)=="Success! User is logged in!") print(i)
  
}
# wyświetla nam hasło:"q1w2e3r4t5"

logs <- logs
emp[emp$surname== "Pietraszko",]  # login: slap
logs2 <- logs[logs$login=="slap",]
unique(logs2$host)
proton(action = "server", host="194.29.178.16")

bh <- bash_history

for (p in bh){
  if (proton(action="login", login="slap", password=p)=="Success! User is logged in!") print(p)
  
}

# hasło: "DHbb7QXppuHnaXGN"

