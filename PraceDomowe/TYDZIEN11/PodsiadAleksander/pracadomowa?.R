library(visNetwork)
library(dplyr)
library(igraph)

data <- read.csv("ENZYMES_g118.csv", sep= ",")

nodes <- data.frame(id = 2:length(unique(c(data$from,data$to))), label = 2:length(unique(c(data$from,data$to)))-1)
edges <- data

graph <- graph.data.frame(edges, directed = TRUE)
degree_value <- degree(graph, mode = "in")
nodes$value <- degree_value[match(nodes$id, names(degree_value))]
nodes %>% mutate(color = case_when(
  value == 5 ~ "red",
  value == 4 ~ "orange",
  value == 3 ~ "gold",
  value == 2 ~ "green",
  TRUE ~ "blue"
)) -> nodes

net <- visNetwork(nodes, edges, height = "100%", width = "100%", main = "ENZYMES") %>%
  visEdges(arrows = "from") %>% 
  visLayout(randomSeed = 7) %>% visNodes(scaling = list(min = 7, max = 30)) %>% 
  visOptions(highlightNearest = TRUE, nodesIdSelection = TRUE, selectedBy = "value") %>% 
  visInteraction(hideEdgesOnDrag = TRUE) %>% visPhysics(stabilization = FALSE)
net 
