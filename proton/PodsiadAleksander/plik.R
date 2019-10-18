proton()
employees[employees$name == 'John' & employees$surname == 'Insecure', 'login'] -> login
proton(action = "login", login=login)
for(pass in top1000passwords){
  proton(action = "login", login=login, password=pass)
}
x <- employees[employees$surname == 'Pietraszko', 'login']
hosts1 <- logs[logs$login == x , 'host']
hosts1 <- as.vector(hosts1)
table(hosts1)
proton(action = "server", host="194.29.178.16")
for(i in bash_history){
  proton(action = "login", login=x, password=i)
}

# 17:44