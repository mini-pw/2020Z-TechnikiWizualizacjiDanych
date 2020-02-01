library(visNetwork)
library(dplyr)

data <- read.csv(file = 'mammalia-bison-dominance.edges', sep = ' ')
path_to_image <- 'https://www.washingtonpost.com/wp-apps/imrs.php?src=https://arc-anglerfish-washpost-prod-washpost.s3.amazonaws.com/public/2RSM54GNZMI6TDA4PSHOPBNYKU.jpg&w=767'

edges <- data.frame(from = data[[2]], 
                    to = data[[3]], 
                    color = "darkgreen",
                    shadow = FALSE)

nodes <- data.frame(id = unique(data[[1]]),
                    shape = c("circularImage"),
                    image = path_to_image,
                    label = paste("Bizon", 1:25),
                    color = 'black',
                    shadow = TRUE)

net <- visNetwork(nodes, edges, height = '500px', width = '100%', main = 'Dominacja osobników w pewnym stadzie bizona amerykańskiego') %>%
  visNodes(shapeProperties = list(useBorderWithImage = TRUE), size = 35) %>%
  visEdges(arrows = "to", physics = TRUE) %>%
  visOptions(highlightNearest = list(enabled = T, degree = 1, hover = T)) %>%
  visPhysics(solver = 'repulsion',
             repulsion = list(nodeDistance = 200,
                              springConstant = 0.02,
                              damping = 0.25))

# use highlighting to explore data
net
