install.packages("BetaBit")
library(BetaBit)
proton()

install.packages('data.table')

empl <- data.table::data.table(employees)

# find by name and surname
John_login <- empl[name == 'John']
John_login <- John_login[surname == 'Insecure']


#find Pietraszko
Pietraszko_login <- empl[name == 'Slawomir']
Pietraszko_login <- empl[surname == 'Pietraszko']


proton(action <- "login", login=John_login$login)

#just to be sure
t100 <- unique(top1000passwords)

for (pass in t100){
  if (proton(action = "login", login=John_login$login, password=pass) != "Password or login is incorrect"){
    Jpass <- pass
    break
  }
}

proton(action = "login", login=John_login$login, password=Jpass)

install.packages('dplyr')
library(dplyr)

countedLogs <- dplyr::group_by(logs, host)

PietraszkoLogs <- dplyr::filter(countedLogs,login == Pietraszko_login$login) %>% count()

for (ser in PietraszkoLogs$host){
  if( proton(action="server", host=ser)){
    Jhost <- ser
  }
}


#hard-brute
for (pass in bash_history){
  if (proton(action = "login", login=Pietraszko_login$login, password=pass) != "Password or login is incorrect"){
    Ppass <- pass
    break
  }
}

#Zadanie skończono w czasie: 1h 15 minut