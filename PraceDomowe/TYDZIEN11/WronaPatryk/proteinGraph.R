library(visNetwork)
library(dplyr)

# ANALIZA WZAJEMNYCH INTERAKCJI POMIĘDZY PROTEINAMI:

data <- read.csv("./bio-yeast-protein-inter.edges", sep= " ") # http://networkrepository.com/bio.php

colnames(data) <- c("from", "to")


maxNodes <- 700 # ponieważ zacina się przy większej liczbie

nodes <- data %>% filter(from <= maxNodes & to <= maxNodes) %>% 
  filter(from < to)# usuwam rowniez podwojne krawedzie tutaj




# ładny, zielony, bio kolor
net <- visNetwork(data.frame(id = unique(nodes$from), label = paste("PROTEIN ", unique(nodes$from))), nodes, height = 1200, width = 1200, background = "#5DBB63",
                  submain = "Wzajemne interakcje między białkami") %>%
  visEdges(arrows = "to;from")  %>%
  visLayout(randomSeed = 456)
net


