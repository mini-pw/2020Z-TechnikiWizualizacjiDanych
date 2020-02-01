library(visNetwork)
library(dplyr)

#@inproceedings{nr-aaai15,
#  title = {The Network Data Repository with Interactive Graph Analytics and Visualization},
#  author={Ryan A. Rossi and Nesreen K. Ahmed},
#  booktitle = {AAAI},
#  url={http://networkrepository.com},
#  year={2015}
#}

#This dataset was collected by Davis and colleague in the 1930s. It contains the observed attendance at 14 social events by 18 Southern women.
nodes <- data.frame( id = 1:18,
                     label = paste0( rep("Southern women ", 18), 1:18))

edges <- as.data.frame( read.table("ia-southernwomen.edges", skip=2))
names(edges) <- c("from","to")
edges <- edges[ edges$from != edges$to,]

visNetwork(nodes, edges, width = "100%") %>% 
  visNodes(shape = "star", 
           color = list(background = "yellow", 
                        border = "black",
                        highlight = "red"),
           shadow = list(enabled = TRUE, size = 10)) %>%
  visLayout(randomSeed = 1)
