install.packages("BetaBit")
library(BetaBit)
proton()

employees$login[employees$surname == 'Pietraszko']




top1000passwords

for (password in top1000passwords){ 
proton(action = "login", login = "johnins", password = password)
}

slap_host = logs$host[logs$login == 'slap']

library(dplyr)

logs %>% filter(logs$login == 'slap') %>% group_by(host) %>% count()

# 194.29.178.16

proton(action = "server", host="194.29.178.16")

bash_history

library(stringi)
stri_extract_first_words(bash_history) %>% unique()

proton(action = "login", login = "slap", password = "DHbb7QXppuHnaXGN" )
