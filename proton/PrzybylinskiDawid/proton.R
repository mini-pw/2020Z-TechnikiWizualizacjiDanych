install.packages("BetaBit")
library(BetaBit)
library(dplyr)
library(stringi)
proton()
employees[employees$surname == 'Pietraszko',]
proton(action = 'login', login='johnins')

for (i in pass){
  proton(action = "login", login="johnins", password=i)
}

pass <- top1000passwords
pass

colnames(logs)
sort(table(logs[logs$login=='slap','host']), decreasing = T)[1]
h <- "194.29.178.16"
proton(action = "server", host=h)

bash_history
na.omit(stringi::stri_extract_first_regex(bash_history, "[]*[]"))
?stringi::stri_extract_first_regex
comm <- stringi::stri_extract_all_regex(bash_history, "^[^ ]+")
table(unlist(comm))

p <- "DHbb7QXppuHnaXGN"
proton(action = "login", login="slap", password=p)
