# @inproceedings{nr,
#   title={The Network Data Repository with Interactive Graph Analytics and Visualization},
#   author={Ryan A. Rossi and Nesreen K. Ahmed},
#   booktitle={AAAI},
#   url={http://networkrepository.com},
#   year={2015}
# }
# @article{traud2012social,
#   title={Social structure of {F}acebook networks},
#   author={Traud, Amanda L and Mucha, Peter J and Porter, Mason A},
#   journal={Phys. A},
#   month={Aug},
#   number={16},
#   pages={4165--4180},
#   volume={391},
#   year={2012}
# }
# @article{Traud:2011fs,
#   title={Comparing Community Structure to Characteristics in Online Collegiate Social Networks},
#   author={Traud, Amanda L and Kelsic, Eric D and Mucha, Peter J and Porter, Mason A},
#   journal={SIAM Rev.},
#   number={3},
#   pages={526--543},
#   volume={53},
#   year={2011}
# }

# biblioteki
library(dplyr)
library(visNetwork)
library(Matrix)
library(shiny)
library(dplyr)

# plik źródłowy
zipplik <- tempfile()
download.file("http://nrvis.com/download/data/socfb/socfb-Yale4.zip", zipplik)
zipplik2 <- unz(zipplik, "socfb-Yale4.mtx")
facebook <- readMM(zipplik2)
unlink(zipplik)

graf <- function(a){
  # dane
  wierzcholki <- data.frame(id=sample(0:8577, a), shape="diamond")
  krawedzie <- data.frame(from=facebook@i, to=facebook@j, color="#6600CC")
  krawedzie <- krawedzie[krawedzie$from %in% wierzcholki$id & krawedzie$to %in% wierzcholki$id,]
  
  # stopnie wierzchołków
  stopnie <- as.data.frame(table(c(krawedzie$from, krawedzie$to)))
  stopnie$Var1 <- as.numeric(levels(stopnie$Var1))
  wierzcholki <- left_join(wierzcholki, stopnie, by=c("id" = "Var1"))
  if (length(row(wierzcholki[is.na(wierzcholki$Freq),]))>0){
    wierzcholki[is.na(wierzcholki$Freq),]$Freq <- 0
  }
  colnames(wierzcholki)[3] <- "deg"
  wierzcholki$label <- wierzcholki$id+1
  
  # stopnie będą wskazywane przez kolory
  if (max(wierzcholki$deg)==1) kolory <- "#00CC00"
  else kolory <- substr(rev(rainbow(max(wierzcholki$deg), s=1, v=0.8, start=0, end=2/3)), 1, 7)
  kolory <- c("#808080", kolory)
  wierzcholki$color <- kolory[wierzcholki$deg+1]
  
  # graf
  net <- visNetwork(wierzcholki, krawedzie, height = 1000, width = 1000) %>%
    visEdges(arrows = "from;to")  %>% 
    visLayout(randomSeed = 123)
  net
}

# shiny
ui <- fluidPage(
  titlePanel("Znajomości facebookowe losowych ludzi z uczelni Yale"),
  inputPanel(
    sliderInput("users", label = "Użytkownicy", 
                       min=10, max=200, value=10, step=5)
  ),
  visNetworkOutput("graf")
)

server <- function(input, output) {
  output[["graf"]] <- renderVisNetwork(
    graf(input[["users"]])
  )
}

shinyApp(ui = ui, server = server)