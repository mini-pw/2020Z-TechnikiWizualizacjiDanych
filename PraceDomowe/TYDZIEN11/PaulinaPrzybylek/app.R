#' @inproceedings{nr,
#'   title={The Network Data Repository with Interactive Graph Analytics and Visualization},
#'   author={Ryan A. Rossi and Nesreen K. Ahmed},
#'   booktitle={AAAI},
#'   url={http://networkrepository.com},
#'   year={2015}
#' }

library(visNetwork)
library(dplyr)
library(shiny)
library(dplyr)
library(colourpicker)


ui <- fluidPage(

  titlePanel("Połączenia mózgowe u myszy"),
  
  sidebarLayout(
    sidebarPanel(
      tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 24px;
      }'))),
      tags$div(class="header", checked=NA,
               HTML("Przedstawiony graf został podzielony na grupy węzłów względem liczby wychodzących krawędzi. <br> Możliwe jest:
                    <br> - Wybranie konkretnego węzła po jego id
                    <br> - Zobaczenie węzłów należących do tej samej grupy <br>
                    <br> Dodatkowo nagiwację po grafie umożliwiają umieszczone przy grafie na dole kontrolki.")
               ),
      selectInput("shape", "Kształt wierzchołków:",
                         choices = c("koło" = "circle", "kwadrat" = "square", "trójkąt" = "triangle", "gwiazda" = "star",
                                     "diament" = "diamond")),
      selectInput("solver", "Sposób rozmieszczenia grafu:",
                  choices = c('barnesHut', 'repulsion')),
      sliderInput("nodes", "Liczba wierzchołków grafu:",value = 380, min=0, max = 1029),
      colourInput("color", "Kolor krawędzi:", value = "black")
               ),
    
    mainPanel(
      visNetworkOutput("network", height = "600px")
    )
  )
  )

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$network <- renderVisNetwork({
    
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
    
    nodes <- data.frame(id = data$id[1:input$nodes], group = as.character(data$col[1:input$nodes]), shape = input$shape)
    
    df2 <- df[df$from <= input$nodes & df$to <= input$nodes, ]
    edges <- data.frame(from = df2$from,
                        to = df2$to)
    
    net <- visNetwork(nodes, edges, height = 600, width = 500) %>%
      visInteraction(hover = TRUE,
                     navigationButtons = TRUE,
                     keyboard = TRUE,
                     selectConnectedEdges = TRUE,
                     dragView = FALSE,
                     zoomView = FALSE) %>% 
      visEdges(color = input$color) %>% 
      visOptions(selectedBy = list(variable = "group", style = 'background: #f8f8f8;
                                                                       color: black;
                                                                       border:none;
                                                                       outline:none;'), 
                 highlightNearest = TRUE, nodesIdSelection = list(enabled = TRUE,
                                                                  style = 'background: #f8f8f8;
                                                                       color: black;
                                                                       border:none;
                                                                       outline:none;'))
    
    if(as.character(input$solver) == 'barnesHut'){
      net %>% visPhysics(stabilization = FALSE, solver = "barnesHut", barnesHut = list(gravitationalConstant = -1000,
                                                                               springConstant = 0.001,
                                                                               springLength = 200)) 
    }else{
      net %>% visPhysics(stabilization = FALSE, solver = "repulsion", repulsion = list(gravitationalConstant = -10000,
                                                                               springConstant = 0.001,
                                                                               springLength = 200)) 
    }
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
