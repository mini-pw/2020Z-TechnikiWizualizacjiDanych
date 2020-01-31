#' @inproceedings{nr,
#'   title={The Network Data Repository with Interactive Graph Analytics and Visualization},
#'   author={Ryan A. Rossi and Nesreen K. Ahmed},
#'   booktitle={AAAI},
#'   url={http://networkrepository.com},
#'   year={2015}
#' }


library(visNetwork)
library(dplyr)

#wczytujemy dany zbiór
df <- read.csv("bn-mouse-kasthuri_graph_v4.csv", sep = " ") %>% as.data.frame()
colnames(df) <- c("from", "to")


id <- c(df$from, df$to) %>% unique() %>% sort() %>% as.data.frame() #wszystkie występujące węzły
colnames(id) <- "id"

#chcemy zrobić grupy do nadawania kolorów w zależności od tego ile połączeń wychodzi z danego węzła
gr <- table(df$from) %>% as.data.frame(stringsAsFactors = FALSE)
colnames(gr) <- c("id", "col")
gr$id <- as.integer(gr$id)
data <- left_join(id, gr, by = "id")
data$col <- ifelse(is.na(data$col), 0, data$col)

nodes <- data.frame(id = data$id, group = as.character(data$col), shape = "diamond")

edges <- data.frame(from = df$from, 
                    to = df$to)

net <- visNetwork(nodes, edges, height = 500, width = 600, main = list( text = "Mouse brain networks",
                  style = "font-family:Calibri;color:#80bfff;font-size:20px;text-align:center;")) %>%
  visPhysics(stabilization = FALSE, solver = "repulsion", repulsion = list(gravitationalConstant = -10000,
                                                       springConstant = 0.001,
                                                       springLength = 200)) %>%
  visInteraction(hover = TRUE,
                 navigationButtons = TRUE,
                 keyboard = TRUE,
                 selectConnectedEdges = TRUE,
                 dragView = FALSE,
                 zoomView = FALSE) %>% 
  visEdges(color = "black") %>% 
  visOptions(selectedBy = list(variable = "group", style = 'background: #f8f8f8;
                                                                       color: #80bfff;
                                                                       border:none;
                                                                       outline:none;'), 
             highlightNearest = TRUE, nodesIdSelection = list(enabled = TRUE, selected = "0",
                                                              style = 'background: #f8f8f8;
                                                                       color: #80bfff;
                                                                       border:none;
                                                                       outline:none;'))

#wywołanie grafu - może się zacinać z powodu dużej ilości danych
net
