library(visNetwork)
library(dplyr)
library(igraph)
library(shiny)


# załadowanie csv z zipa
nodes <- read.csv("./fb-pages-artist.nodes", header=T) %>% select(name=new_id, label=name)
edges <- read.csv("./fb-pages-artist.edges", header=F, col.names=c("from", "to"))
# 2 warunki do filter - kolumny z id musza sie zawierac w nodes, tzn usuwamy niekompletne krawędzie
edges <- edges %>% filter(from %in% nodes$name, to %in% nodes$name)

# tworzymy graf przy pomocy biblioteki igraph
g <- graph_from_data_frame(edges, directed=F, vertices=nodes)

# wektor nazwany
choices <- nodes$name
names(choices) <- nodes$label

# interfejs shiny
ui <- fluidPage(
  titlePanel("Strony artystów na Facebooku"),
  sidebarLayout(
    sidebarPanel(
      selectInput("artist", "Artysta:", choices=choices),
      sliderInput("level", "Głębokość:", min=0, max=2, value=1)
    ),
    mainPanel(
      h2("Graf zależności"),
      visNetworkOutput("network", height = "600px")
    )
  )
)

# serwer shiny
server <- function(input, output) {
  output$network <- renderVisNetwork({
    # podgraf wybranego węzła i jego sąsiadów stopnia do wybranego stopnia
    subGraph <- make_ego_graph(g, order=input$level, which(nodes$name==input$artist))[[1]]
    data <- toVisNetworkData(subGraph, idToLabel=F)
    # kolorujemy wszystkie wierzchołki
    data$nodes$color <- "#d2b6fb"
    # koloryjemy wierzchołki 1 stopnia
    first_neighbors <- c(data$edges$from[data$edges$to==input$artist], data$edges$to[data$edges$from==input$artist])
    data$nodes$color[data$nodes$id %in% first_neighbors] <- '#896bf8'
    # kolorujemy wybrany wierzchołek
    data$nodes$color[which(data$nodes$id == input$artist)] <- "#4533e1"
    visNetwork(data$nodes, data$edges, stabilization=T)
  })
}

shinyApp(ui, server)
