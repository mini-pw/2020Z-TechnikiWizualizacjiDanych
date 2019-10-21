install.packages("BetaBit")
library(BetaBit)
install.packages("data.table")
library(data.table)

# Finding John's login
DT <- data.table(employees)
DT[name == "John"]

proton(action = "login", login = "johnins")

# Finding John's password
head(top1000passwords)

length(top1000passwords)
for (pass in top1000passwords) {
  if(proton(action = "login", login = "johnins", password = pass) == "Success! User is logged in!"){
    print(pass)
    break
  }
}

proton(action = "login", login = "johnins", password = pass)

# Finding Pietraszko's login
DT <- data.table(employees)
DT[surname == "Pietraszko"]

# Finding Pietraszko's most used host
DT <- data.table(logs)
DT[login == "slap", .(count = .N), by = host]

proton(action = "server", host = "194.29.178.16")