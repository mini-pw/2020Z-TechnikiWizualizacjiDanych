library(visNetwork)
library(dplyr)

# wczytanie zbioru danych (za strony http://networkrepository.com/inf-euroroad.php)

data <- read.table("inf-euroroad.edges",skip=2)

# Opis zbioru danych

# This is the international E-road network, a road network located mostly in Europe. 
# The network is undirected; nodes represent cities and an edge between two nodes denotes 
# that they are connected by an E-road.

# zmiana nazw kolumn
colnames(data) <- c("from", "to")

# zmniejszamy ilość węzłów aby graf nie wyświetlał się po minucie ;)
data <- data %>%
  filter(from <= 500) %>%
  filter(to <= 500)

# definiujemy węzły, określając ich stopień oraz kolor i label zależnie od stopnia
nodes_count <- as.data.frame(table(unlist(data)), stringsAsFactors = FALSE)
colnames(nodes_count) <- c("Nodes", "Count")

nodes <- data.frame(id = 1:500, 
                    color = ifelse(nodes_count$Count <= 8,
                                   ifelse(nodes_count$Count <= 5,
                                                 ifelse(nodes_count$Count <= 2,
                                                        ifelse(nodes_count$Count <=1,
                                                        " #ffccff", "	 #ff66ff"), "#e600e6"), "#800080"), ""),
                    label = ifelse(nodes_count$Count <= 8,
                                   ifelse(nodes_count$Count <= 5,
                                          ifelse(nodes_count$Count <= 2,
                                                 ifelse(nodes_count$Count <=1,
                                                        "Badly connected", "Quite well connected"), "Well connected"), "Very well connected"),""))

# definiujemy krawędzie i ich kolor
edges <- data.frame(data, color = "blue")

# tworzymy graf
net <- visNetwork(nodes, edges, height = "540px", width = "100%")%>%
  visOptions(highlightNearest = TRUE,
             # rozwijana lista do wyboru w?z?a
             nodesIdSelection = list(enabled = TRUE,
                                     selected = "1",
                                     values = c(1:500),
                                     style = 'width: 200px; height: 26px;
                                              background: #f8f8f8;',
                                     useLabels = FALSE),
             manipulation = TRUE) %>%
  visPhysics( solver = "forceAtlas2Based",
             forceAtlas2Based = list(gravitationalConstant = -1000)) %>%
  visIgraphLayout() %>%
  visEdges(smooth = FALSE) %>%
  # dodajemy widżety do nawigacji 
  visInteraction(navigationButtons = TRUE,
                 keyboard = TRUE,
                 hideEdgesOnDrag = TRUE)
net
