install.packages("BetaBit")
library(BetaBit)
library(dplyr)
proton()
employees %>% filter(name=="John") %>% head
employees %>% filter(surname == "Pietraszko")
test1 <- proton(action="login", login="johnins", password=top1000passwords[12])
i <- 0
while(test == test1) {
  test <- proton(action="login", login="johnins", password=top1000passwords[i])
  i <- i + 1
}
proton(action="login", login="johnins", password=top1000passwords[i])
logs %>% head()
mylogs <- logs
logs %>% filter(login=="slap") %>% group_by(login, host) %>% tally()
