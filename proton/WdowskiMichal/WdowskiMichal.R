library(BetaBit)
library(dplyr)
library(stringi)
proton()

emp <- employees
emp[emp$name=="John", ]

proton(action = "login", login = "johnins")


pas <- top1000passwords

#for (a in pas){
#    proton(action = "login", login = "johnins", password = a)
#}
#q1w2e3r4t5

proton(action = "login", login = "johnins", password = "q1w2e3r4t5")


emp[emp$surname=="Pietraszko", ]

logs %>%
    filter(login=="slap") %>%
    group_by(host) %>%
    summarise(liczba=n())-> logs2
logs2
#194.29.178.16
proton(action="server", host="194.29.178.16")

bh <- as.data.frame(bash_history)
bh %>%
    mutate(command = stri_match_first_regex(bash_history, pattern = "[a-z]+ ")) -> bh
bh