library(visNetwork)
library(dplyr)

data <- read.table("/home/elzbieta/2020Z-TechnikiWizualizacjiDanych/PraceDomowe/TYDZIEN11/JowikElzbieta/ia-crime-moreno.edges")
data <- data[, c(1:2)]
colnames(data) <- c("from", "to")

maxNodesCount <- 800 
nodes <- data.frame(id = 1:maxNodesCount)
edges <- data %>% filter(from <= maxNodesCount & to <= maxNodesCount)

net <- visNetwork(nodes, edges, height = "540px", width = "100%") %>% 
  visOptions(highlightNearest = TRUE, 
             nodesIdSelection = list(enabled = TRUE,
                                     selected = "2",
                                     values = c(1:maxNodesCount),
                                     style = 'width: 200px; height: 26px;
                                 background: #f8f8f8;
                                 color: darkblue;
                                 border:none;
                                 outline:none;'),
             manipulation = TRUE) %>%
  visPhysics(solver = "forceAtlas2Based", 
             forceAtlas2Based = list(gravitationalConstant = -500)) %>%
  visIgraphLayout() %>%
  visEdges(smooth = FALSE) %>% 
  visInteraction(navigationButtons = TRUE,
                 keyboard = TRUE,
                 hideEdgesOnDrag = TRUE)
net

