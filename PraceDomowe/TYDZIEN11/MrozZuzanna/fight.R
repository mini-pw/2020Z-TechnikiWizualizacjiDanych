library(visNetwork)
library(dplyr)

install.packages("visNetwork")

# wizualizacja sieci interakcji samic gęsi

data <- read.table(file = 'aves-geese-female-foraging.edges', sep = ' ', header = FALSE)
colnames(data) <- c("from", "to", "value")
nodes <- data.frame(id = 1:max(data))

net <- visNetwork(nodes, data) %>%
  visLayout(randomSeed = 123)

net

# The first rule of Fight Club is: You do not talk about Fight Club

