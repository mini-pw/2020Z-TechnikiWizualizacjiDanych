install.packages("BetaBit")
options(stringsAsFactors = FALSE)
library(BetaBit)
library(stringi)
proton()
library("dplyr")
employees %>%
  filter(name == "John" & surname == "Insecure") %>%
  select(login) -> login1
login1 <- toString(login1)
proton(action = "login", login=login)
for (i in 0:length(top1000passwords)) {
  proton(action = "login", login=login, password=top1000passwords[i])
}
employees %>%
  filter(surname == "Pietraszko") %>%
  select(login) -> login1
login1 <- toString(login1)
host <- logs %>%
  filter(login == login1) %>%
  group_by(host) %>%
  summarise(count = n()) %>%
  arrange(desc(count)) %>%
  slice(1) %>%
  pull(host) %>% 
  as.character()
proton(action = "server", host=host[1])

bash_history[!grepl(" ", bash_history)] %>% unique -> costam

proton(action = "login", login="slap", password=costam[6])