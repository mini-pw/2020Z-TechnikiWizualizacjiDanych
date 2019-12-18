install.packages("BetaBit")
library(BetaBit)
proton()

library(dplyr)
employees %>% filter(surname == "Insecure")

proton(action = "login", login="johnins")

top1000passwords


for (password in top1000passwords) {
  proton(action="login", login="johnins", password=password)
}

employees %>% filter(surname == "Pietraszko")

logs %>% filter(login == "slap") %>% group_by(host) %>% summarise(n())


library(stringi)
proton(action = "server", host="194.29.178.16")

stri_split_fixed(bash_history, " ") %>% lapply(function(x) (x[[1]])) %>% unlist() %>% table()


proton(action="login", login="slap", password="DHbb7QXppuHnaXGN")



