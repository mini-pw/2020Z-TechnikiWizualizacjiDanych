
library(BetaBit)
proton()
x <- employees
library(data.table)
login <- x[x$name=="John" & x$surname=="Insecure", "login"]
proton(action = "login", login=login)

passwords <- top1000passwords

pass <- NULL

for (i in 1:length(passwords)) {
  msg <- proton(action = "login", login=login, password=passwords[i])
  if(msg == "Success! User is logged in!")
    pass <- passwords[i]
}

p_login <- x[x$surname=="Pietraszko", "login"]
y <- logs
y <- as.data.frame(y[y$login==p_login, "host"])
y <- sort(table(y), decreasing = TRUE)[1]
host <- names(y)

proton(action = "server", host=host)
B <- bash_history
?grepl
B <- unique(B[!grepl(" ", B)])
p_password <- B[6]

proton(action = "login", login = p_login, password = p_password)
