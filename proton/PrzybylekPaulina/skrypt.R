install.packages("BetaBit")
library(BetaBit)
proton()

#1 find the login of John Insecure

employees
names(employees)
employees[employees$name=="John" & employees$surname=="Insecure", "login"] -> loginJohn
proton(action = "login", login = loginJohn)

#2 find John Insecure's password

top1000passwords
for (i in 1:1000) {
  proton(action = "login", login = loginJohn, password=top1000passwords[i])
}

#3 check from which server Pietraszko logs into the Proton server most often

employees[employees$surname=="Pietraszko", "login"] -> loginPietraszko

logs
names(logs)
logs %>% filter(login==loginPietraszko) %>% group_by(host) %>% summarise(count= n()) -> hosts
hosts
hosts[which.max(hosts$count), "host"] -> mostoftenhost
proton(action = "server", host="194.29.178.16")

#4 find the Pietraszko's password

bash_history

library(stringi)

?stri_extract_all_words()
