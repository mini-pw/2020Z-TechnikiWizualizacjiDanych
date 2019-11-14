library(BetaBit)
library(dplyr)
library(stringi)
login <- (employees %>% filter(name=="John", surname=="Insecure") %>% pull(login))[1]
pass <- sapply(top1000passwords, function(p){ proton(action="login", login=login,password=p) != "Password or login is incorrect"})
correct <- top1000passwords[which(pass)]
proton(action="login", login=login,password=correct)
loginPietraszko <- (employees %>% filter(surname=="Pietraszko") %>% pull(login))[1]
popularHost <- as.character((logs %>% filter(login==!!loginPietraszko) %>% group_by(host) %>% tally %>% arrange(desc(n)) %>% pull(host))[1])
proton(action="server",host=popularHost)
bash_history %>% stri_extract_first_regex("[^ ]*") %>% table
proton(action="login",login=loginPietraszko,password="DHbb7QXppuHnaXGN")
