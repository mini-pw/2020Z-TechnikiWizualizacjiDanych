library(BetaBit)
library(tidyverse)
proton()

# Find all Johns
employees[employees$name == 'John',]


# Brute force attack on passwords
for (password in top1000passwords) {
  proton(action = "login", login="johnins", password=password)
}

# Find most used host
logs[logs$login == 'slap',] %>% group_by(host) %>% count(host)

# Login for Pietraszko
employees[employees$surname == 'Pietraszko', ]

# Extract uniqie words loooking for password
bash_history %>% str_extract('([^\\s]+)') %>% unique()

# Final log in
proton(action = 'login', login = 'slap', password = 'DHbb7QXppuHnaXGN')
