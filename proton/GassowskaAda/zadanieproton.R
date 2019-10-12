employees
library(dplyr)
x <-employees %>% 
  filter(surname=="Insecure") %>% 
  pull(login) 
proton(action="login",login=x )
for(password in top1000passwords){
  proton(action='login',login=x, password=password)
}
y <- employees %>% 
  filter(surname=="Pietraszko") %>% 
  pull(login) 
serwer <- logs %>%
  filter(login==y) %>%
  group_by(host) %>%
  summarise(n()) %>% slice(1) %>% pull(1)
serwer <- as.character(serwer[[1]])
serwer
proton(action="server", host=serwer)
bash_history
library(stringi)
passwords <- bash_history[!grepl(".", bash_history, fixed = TRUE) & !grepl(" ", bash_history, fixed = TRUE)] %>% unique()
for(i in passwords){
  print(i)
  print(proton(action='login', login=y, password=i))
}
