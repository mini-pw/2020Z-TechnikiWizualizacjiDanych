library(visNetwork)
library(dplyr)

#' @inproceedings{nr,
#'   title={The Network Data Repository with Interactive Graph Analytics and Visualization},
#'   author={Ryan A. Rossi and Nesreen K. Ahmed},
#'   booktitle={AAAI},
#'   url={http://networkrepository.com},
#'   year={2015}
#' }

data <- read.table("./PraceDomowe/TYDZIEN11/WisniewskiJacek/road-euroroad.edges", skip = 2)
colnames(data) <- c("from", "to")

data <- data %>% filter(from <= 400) %>% filter(to <= 400)
temp <- data %>% group_by(from) %>% summarise(count = length(from) + length(to))
data <- left_join(data, temp)

nodes <- data[!duplicated(data$from),]
nodes <- data.frame(id = nodes$from,
                    color = ifelse(nodes$count <= 8,
                                   ifelse(nodes$count <= 6,
                                          ifelse(nodes$count <= 4,
                                                 ifelse(nodes$count <= 2,
                                                        "#ffffb2", "#fecc5c"), "#fd8d3c"), "#f03b20"), "#bd0026"),
                    label = ifelse(nodes$count <= 4,
                                   ifelse(nodes$count <= 3,
                                          ifelse(nodes$count <= 2,
                                                 ifelse(nodes$count <= 1,
                                                        "Bardzo mały ruch", "Mały ruch"), "Średni ruch"), "Duży ruch"), "Bardzo duży ruch"))
edges <- data.frame(from = data$from, to = data$to, color = "blue")

visNetwork(nodes, edges, height = 600, width = 1000) %>%
  visEdges(arrows = "to;from")