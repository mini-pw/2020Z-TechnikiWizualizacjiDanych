library(shiny)
library(visNetwork)

enzymes <- read.csv(file = 'ENZYMES_g108.edges', sep = ' ')


edges <- data.frame(from = enzymes[[1]], 
                    to = enzymes[[2]],
                    shadow = FALSE,
                    color = "black")

nodes <- data.frame(id = 1:38,
                    shape = c("image"),
                    image = "https://upload.wikimedia.org/wikipedia/commons/6/60/Myoglobin.png",
                    shadow = TRUE)

net <- visNetwork(nodes, edges, main = "Enzymes_g108", height = 600, width = "100%") %>%
  visNodes(shapeProperties = list(useBorderWithImage = TRUE), size=50) %>%
  visLayout(randomSeed = 123) %>%
  visPhysics(stabilization = TRUE) %>%
  visInteraction(dragNodes = TRUE, 
                 dragView = TRUE, 
                 zoomView = TRUE) %>%
  visPhysics(solver = "barnesHut", 
             forceAtlas2Based = list(gravitationalConstant = -500))


net
