library(visNetwork)
library(dplyr)

df <- read.csv("infect-dublin.csv", sep= ",")[,c(2,3)]


number_of_nodes <- 100 #mała liczba wierzchołków wynika z dużej wartości średniego stopnia (13 dla całego zbioru)

nodes <- data.frame(id = 1:number_of_nodes)

edges <- df %>% filter(from <= number_of_nodes) %>% filter(to <= number_of_nodes)

net <- visNetwork(nodes, edges, main = "Physical contacts between people in Dublin", 
                  height = 600, width = "100%") %>%
  visNodes(color = list(highlight = "limegreen")) %>%
  visEdges(color = list(highlight = "limegreen")) %>%
  visOptions(highlightNearest = list(enabled = TRUE, degree = 1,
                                     labelOnly = TRUE), nodesIdSelection = T) %>%
  visLayout(improvedLayout = TRUE)
  
net

