library(visNetwork)
library(dplyr)
library(stringi)

data <- read.table("internet-industry-partnerships.edges", sep=",")
label_ids <- read.table("internet-industry-partnerships.node_labels")[,1]
dict <- data.frame("label" = c("content", "infrastructure", "commerce"),
                   "color" = c("#1b9e77","#d95f02","#7570b3"))

calculate_degree <- function(ids){
  sapply(ids, function(id)
  (data$from == id | data$to == id) %>% sum())
}

colnames(data) <- c("from", "to")

nodes <- data.frame(id = 1:length(label_ids),
                    dict[label_ids,]) %>%
  mutate(value = calculate_degree(id))

net <- visNetwork(nodes, data, height = "540px", width = "100%") %>% 
  visOptions(highlightNearest = list(enabled = TRUE,
                                     degree = 2), 
             nodesIdSelection = list(enabled = TRUE,
                                     selected = "2",
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
