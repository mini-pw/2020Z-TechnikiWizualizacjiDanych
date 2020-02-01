library(shiny)
library(visNetwork)
library(dplyr)
library(colourpicker)

# from http://networkrepository.com/soc-dolphins.php

# defining edges
edges <- read.csv(file = "dolphins.csv")
colnames(edges)<-c("from","to")

# max node
max_node <- max(max(edges$from), max(edges$to))

# number of neighbours
spokrewnienie <- rep(0,max_node)

for (i in edges$from){
    spokrewnienie[i] <-  spokrewnienie[i] +1
}
for (i in edges$to){
    spokrewnienie[i] <-  spokrewnienie[i] +1
}

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    tags$head(
        tags$style(HTML("
     body {background-color: #d4e4ff;}"))), 

    # Application title
    titlePanel("Zgraja Delfinów"),
        sidebarLayout(
            sidebarPanel(
                   selectInput(inputId = "pf", label = "Czy chcesz czekać aż graf się ustabilizuje?",
                               choices = c("Tak","Nie"), selected = "Tak"),
                   sliderInput("width", "Grubość krawędzi", min =1 , max = 7, value = 1, step = 0.05),
                   colourInput("EdgeColor","Kolor krawędzi" , "black"),
                   h5("Ma tooltipy")),
    
        mainPanel(
                visNetworkOutput("network")
        ))
    )

# pictures are preety much random
pics <- c("https://www.rd.com/wp-content/uploads/2014/01/26-february-dolphins-pa.jpg", 
          "http://www.germmagazine.com/wp-content/uploads/2014/02/dolphin1.jpg", 
          "https://img3.goodfon.com/wallpaper/nbig/8/c4/delfin-ulybka-voda.jpg",
          "https://grouperluna.files.wordpress.com/2012/07/dolphin-smile.jpg")

names <- c("Staś", "Jan", "Piotr"," Krzysztof"," Gucio"," Mirabelka"," Janusz"," Konrad"," Robert ","Trefniś"," Paweł")

server <- function(input, output) {
    
    output$network <- renderVisNetwork({
            
        true_false <- if_else(input[["pf"]] == "Tak", TRUE, FALSE)
        
        nodes <- data.frame(id = 1:max_node, 
                            shape = c("image", "circularImage"),
                            image = rep(pics, length.out = max_node),
                            labels =  rep(names, length.out = max_node),
                            title = paste0("<p><b>Imię delfina: ",rep(names, length.out = max_node),
                                           "<br> Ilość rodzeństwa: ",spokrewnienie,"<br>  </b></p>"))
        edges <- data.frame(from = edges$from, to = edges$to, 
                            width = rep(input[["width"]],length(edges$from)))
                            
        
        visNetwork(nodes, edges, height = "1600px", width = "100%") %>%
            visEdges(smooth = TRUE, 
                     color = list(color = input[["EdgeColor"]], highlight = "red")) %>%
            visNodes(shapeProperties = list(useBorderWithImage = TRUE)) %>% 
            visInteraction(navigationButtons = TRUE) %>%
            visPhysics(solver = "repulsion") %>%
            visPhysics(stabilization = true_false)
            
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
