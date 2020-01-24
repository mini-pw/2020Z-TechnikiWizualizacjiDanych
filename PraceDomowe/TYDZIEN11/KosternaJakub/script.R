# install.packages("visNetwork") # if not installed
library(visNetwork)
library(dplyr)

# data taken from:
# http://networkrepository.com/ -> Infrastructure Networks -> USAir97

# The inf-USAir97.mtx file contains some info about the network data, and then
#   one line informing about nodes and edges and in the end all the edges.

# "USAir97 is a binary undirected graph whose nodes are 332 airports in the United States
# and edges indicate whether there are direct flights between the airports."
# (from https://sites.google.com/site/neighborembedding/usair97)

USAir97 <- file("inf-USAir97.mtx", "r")

# First let's omit rows containing comments
# All of them are in the beginning of the file and start with '%'
while(TRUE)
{
  line = readLines(USAir97, n = 1)

  if(substring(line, 0, 1) != '%')
  {
    firstContainingNumbers <- whichLine
    break
  }
}

# One next row contains information about number of nodes and edges
line <- unlist(strsplit(line, " "))
nOfNodes <- line[1]
nOfEdges <- line[3]

# let's construct the from and to vectors
fromIr <- c()
toIr <- c()

line <- readLines(USAir97, n = 1)
while(length(line) > 0)
{
  line <- unlist(strsplit(line, " "))
  fromIr <- c(fromIr, line[1])
  toIr <- c(toIr, line[2])
  
  line <- readLines(USAir97, n = 1)
  
  # if(length(fromIr) >= 200) # uncomment for faster renderation
  #   break                   # (unfortunately ruins the colors thing)
}

# Let's count appearances of every node
appearances <- c(fromIr, toIr)
appearances <- as.numeric(unlist(appearances))
nOfAppearances <- data.frame(table(appearances), stringsAsFactors = FALSE)
colnames(nOfAppearances) <- c("id", "appearances")

# Preparing colors - firstly everything let be light blue...
colors = rep("blue", nOfNodes)
# ... intead of these nodes having a lot of neighbors!
hasManyNeighbors <- nOfAppearances[2] >= 15
colors[hasManyNeighbors] <- "purple"
# the super special ones
hasLotsOfNeighbors <- nOfAppearances[2] >= 50
colors[hasLotsOfNeighbors] <- "black"
# ... and the lame ones
onlyAFewNeighbors <- nOfAppearances[2] < 3
colors[onlyAFewNeighbors] <- "lightblue"

# We have to remember about correct coloring nodes
nodes <- data.frame(id = 1:nOfNodes, 
                    label = nOfAppearances,
                    color = colors)

edges <- data.frame(from = fromIr, 
                    to = toIr, 
                    color = "red")

# Let's construct our network having finished nodes and edges
net <- visNetwork(nodes, edges, height = 600, width = 1000) %>%
  visEdges(arrows = "from;to")  %>% 
  visLayout(randomSeed = 123)

# Here's the result!
net
