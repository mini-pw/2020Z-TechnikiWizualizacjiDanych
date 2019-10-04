
#install.packages("BetaBit")
#library(BetaBit)
#proton()
John_Ins_login <- employees[employees$name=="John" & employees$surname=="Insecure", 3]
#wyszukujemy login, ktory znajduje sie w 3 kolumnie naszej ramki danych, i ktory odpowiada danemu imieniu oraz nazwisku
proton(action = "login", login = John_Ins_login)
#login Johna Insecure to johnins
for (i in top1000passwords){
  proton(action = "login", login= John_Ins_login, password=i)
}
#powyzszy kod umozliwia nam zalogowanie sie na konto Johna Insecure
library(dplyr)
Pietr_login <- employees[employees$surname == "Pietraszko",3]
#login Pietraszko to slap
salwek <- logs[logs$login=="slap",] 
as.character(salwek[unique(salwek$host),2])
#uzyskujemy interesujace nas hosty
#sprawdzamy te kilka hostow,a poprawnym okazuje sie byc 194.29.178.16

proton(action = "server", host = "194.29.178.16")
#podlaczamy sie do interesujacego nas serwera

for (i in bash_history){
  proton(action = "login", login= "slap", password=i)
}
#wreszcie logujemy sie na konto Pietraszko