library(visNetwork)
library(dplyr)


# download.file("nrvis.com/download/data/chem/ENZYMES_g1.zip", "ENZYMES_g1.zip")
# unzip("ENZYMES_g1.zip")
# data <- read.csv("ENZYMES_g1.edges", sep = " ")

data <- read.csv("ENZYMES_g1.edges", sep = " ")

edges <- data.frame(from = data[[1]], 
                    to = data[[2]], 
                    smooth = FALSE, 
                    color = "black") %>% 
  filter(from > to) # removing edge duplicates
  

nodes <- data.frame(id = unique(c(data[[1]], data[[2]])), 
                    color = rep(c("darkred", "grey", "orange", "darkblue", "purple"), 8)[1:37], 
                    shadow = FALSE)

net <- visNetwork(nodes, 
                  edges, 
                  main = "ENZYMES-g1", 
                  height = "500px", 
                  width = "100%") %>%
  visLayout(randomSeed = 137) %>%
  visInteraction(navigationButtons = TRUE,
                 keyboard = TRUE)

net





