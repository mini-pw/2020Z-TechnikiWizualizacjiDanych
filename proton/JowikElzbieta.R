library(BetaBit)
library(dplyr)
proton()

# 1. 
# employees - data frame
etykiety <- names(employees)
wiersz <- employees[employees$name == "John" & employees$surname == "Insecure",]
login <- wiersz$login

# login użytkownika John insecure to "johnins"

# 2. 
typeof(top1000passwords)
passwords <- as.array(top1000passwords)

for (i in 1:1000){
  proton(action = "login", login="johnins", password = passwords[i])
}

# 3. 
head(logs)
data_frame <- logs

wiersz1 <- employees[employees$surname == "Pietraszko",]
login <- wiersz1$login
names(logs)
dane <- logs[logs$login == login, ]

dane %>% group_by(dane$host)  %>%
  summarise(count=n()) 

# Najczesciej uzywany host to 194.29.178.16
proton(action = "server", host="194.29.178.16")

# 4. 
