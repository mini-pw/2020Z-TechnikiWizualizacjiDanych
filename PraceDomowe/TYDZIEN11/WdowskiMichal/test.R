library(visNetwork)

# wizualizacja sieci drogowych w europie
# trochę się ładuje (u mnie z minutę), ale wygląda ok

data <- read.table(file = 'PraceDomowe/TYDZIEN11/WdowskiMichal/road-euroroad.edges', sep = ' ', header = FALSE)
colnames(data) <- c("from", "to")
nodes <- data.frame(id = 1:max(data))

#edges <- data.frame(from = as.array(data[1]), 
#                    to = as.array(data[2]))

net <- visNetwork(nodes, data, height = 1000, width = 1000) %>%
    visLayout(randomSeed = 123) 

net