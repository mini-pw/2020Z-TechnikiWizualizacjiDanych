library(BetaBit)
library("dplyr")
library(stringr)
proton()

data1 <-employees
login <-filter(data1,name == "John")
print(login)

# johnins to jest hasło

passwords <- top1000passwords
for (i in passwords) {
  
  proton(action = "login", login="johnins",password = i)
  
}
data3 <-employees
login2 <-filter(data3,surname == "Pietraszko")
print(login2)
#/ login to slap
data2<-logs
data2<-filter(data2,login == "slap")
data2<-count(data2,host)

# 194.29.178.16 to jaest najpopularniejszy z n=112


data4<-bash_history
test<-word(data4,1)
test<-unique(test)
print(test)
# to jest hsało : DHbb7QXppuHnaXGN


#Zajeło 1h  20 minut


