library(visNetwork)
library(dplyr)

M <- read.csv("retweet.csv", sep= ",") # retweet'y na koncie ASSAD
M <- M[,c(1,2)]
colnames(M) <- c("from", "to")


maxWierzcholkow <- 1000 # przy 1000 jeszcze w miare szybko dziala
nodes <- data.frame(id = 1:maxWierzcholkow)
edges <- M %>% filter(from <= maxWierzcholkow & to <= maxWierzcholkow)
net <- visNetwork(nodes, edges, height = 1000, width = 1000) %>%
  visEdges(arrows = "")  %>%
  visLayout(randomSeed = 123)
net




















