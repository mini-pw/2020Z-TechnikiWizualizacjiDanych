install.packages("BetaBit")
library(BetaBit)
proton()

x <- employees[employees$name=="John" & employees$surname=="Insecure", "login"]
proton(action="login", login=x)
q <- proton(action="login", login=x, password="123456")
for (i in top1000passwords){
  if (!proton(action="login", login=x, password=i)==q){
    n <- i
  }
}
proton(action="login", login="johnins", password=n)
piet <- employees[employees$name=="Slawomir" & employees$surname=="Pietraszko", "login"]
hosty <- unique(logs[logs$login==piet, ]$host)
h <- type.convert(as.character(hosty[1]), as.is=TRUE)

proton(action="server", host=h)

sp <- strsplit(bash_history, " ")
for (i in 1:length(sp)){
  sp[i] <- sp[i][[1]][1]
}

haslo <- unique(sp)[length(unique(sp))]
proton(action="login", login=piet, password=haslo[[1]][1])

# rozwiązania
# 1: johnins
# 2: q1w2e3r4t5
# 3: 194.29.178.16
# 4: DHbb7QXppuHnaXGN

# czas: 65 minut