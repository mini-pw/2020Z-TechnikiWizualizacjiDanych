install.packages("BetaBit")
library(BetaBit)
proton()

#znajdujemy login Johna Insecure
employees[which(employees$surname=="Insecure"),]$login -> login

#logowanie
proton(action = "login", login=login)

#hasło
for (i in top1000passwords) {
  proton(action = "login", login=login, password=i)
}

#logi
dplyr::count(logs, login) %>%
  arrange(desc(n)) 
#host
dplyr::count(logs[which(logs$login=="slap"),], host)$host[1] 
proton(action = "server", host="194.29.178.16")

#hasło
unique(stringi::stri_extract_first_regex(bash_history, "[^ ]*"))

#rozwiazanie
proton(action = "login", login="slap", password="DHbb7QXppuHnaXGN")
