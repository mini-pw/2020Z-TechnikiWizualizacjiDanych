#' @inproceedings{nr-aaai15,
#'   title = {The Network Data Repository with Interactive Graph Analytics and Visualization},
#'   author={Ryan A. Rossi and Nesreen K. Ahmed},
#'   booktitle = {Proceedings of the Twenty-Ninth AAAI Conference on Artificial Intelligence},
#'   url={http://networkrepository.com},
#'   year={2015}
#' }
#' 
#' Być może nie jest to najbardziej czytelny graf na świecie, jednak trudno wymyślić jakieś sensowne dane do tak losowych połączeń bez metadanych.
#' Potencjalnie taka prezentacja dróg jako graf ważony byłaby praktyczna. Uważam, że fajnym rozszerzeniem jest wyszukiwanie pseudomiast za pomocą listy

library(visNetwork)
library(dplyr)
df <- read.table("inf-euroroad.edges", skip = 2)
colnames(df) <- c("from", "to")

euroroad <- df %>%
  filter(from<=500) %>%
  filter(to <=500)

ids <- unique(c(euroroad$to, euroroad$from))

nodes <- data.frame(id = ids, group = paste(rep(c("Miasto A", "Miasto B", "Miasto C", "Miasto D", "Miasto E"), each = 10), c("Austria", "Belgia", "Francja", "Niemcy", "Szewcja", "Dania", "Portugalia", "Polska", "Włochy"), sep = ", "))
                                
nodes <- nodes %>% mutate(label = group)
edges <- cbind(euroroad, shadow = TRUE,  label = paste0(round(runif(nrow(euroroad)*9)+1), "h"))

visNetwork(nodes, edges, height = 1000, width = "100%",  main = "Połączenia pomiędzy miastami różnych państw Europy") %>%
  visEdges(arrows = "to")  %>% 
  visNodes(shadow = TRUE) %>%
  visEdges(smooth = FALSE) %>%
  visInteraction(hideEdgesOnDrag = TRUE) %>%
  visOptions(highlightNearest = TRUE, 
             nodesIdSelection = TRUE)

