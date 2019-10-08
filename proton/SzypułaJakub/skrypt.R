install.packages("BetaBit")
library(BetaBit)
library(dplyr)
library(stringi)
proton()
employees %>% filter(name=="John") %>% head
employees %>% filter(surname == "Pietraszko")
test1 <- proton(action="login", login="johnins", password=top1000passwords[12])
i <- 0
while(test == test1) {
  test <- proton(action="login", login="johnins", password=top1000passwords[i])
  i <- i + 1
}
i <- 120
proton(action="login", login="johnins", password=top1000passwords[i])
logs %>% head()
mylogs <- logs
logs %>% filter(login=="slap") %>% group_by(login, host) %>% tally()
proton(action="server", host="194.29.178.16")
bash_history%>% head
bash_history[!grepl(".* ", bash_history)] %>% unique()
proton(action="login", login="slap", password= "DHbb7QXppuHnaXGN")
