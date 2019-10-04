install.packages("BetaBit")
library(BetaBit)
proton()

# hint = TRUE

# dtplayer


library(dplyr)
employees %>% filter(name=="John")
employees %>% filter(name=="Slawomir")
# login jsco

proton(action = "login", login = "johnins")
top1000passwords

for (haslo in top1000passwords){
  proton(action = "login", login = "johnins", password = haslo)
}


# login pietraszki to slap
logs %>% 
  filter(login=="slap") %>% 
  select(host) %>% 
  table %>% 
  sort # 194.29.178.16
proton(action = "server", host="194.29.178.16")


indeksy <- bash_history %>% stringi::stri_detect_regex("[ ]") %>% {!.} %>% which()
dlugosci <- bash_history[indeksy] %>% nchar()
haslo_slap <- bash_history[indeksy][which(dlugosci>6)]

proton(action = "login", login = "slap", password = haslo_slap)


