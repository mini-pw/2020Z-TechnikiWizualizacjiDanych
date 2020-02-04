library(shiny)

#@inproceedings{nr-aaai15,
#  title = {The Network Data Repository with Interactive Graph Analytics and Visualization},
#  author={Ryan A. Rossi and Nesreen K. Ahmed},
#  booktitle = {AAAI},
#  url={http://networkrepository.com},
#  year={2015}
#}


label_w <- paste0( rep("Southern women ", 18), 1:18)

ui <- fluidPage(
    titlePanel("18 Southern women, 1930s"),
    
    sidebarLayout(
        checkboxGroupInput( "women", "Selsect women:" ,choices = label_w, selected = label_w),

        mainPanel(
            visNetworkOutput("vis")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    edges <- as.data.frame( read.table("ia-southernwomen.edges", skip=2))
    names(edges) <- c("from","to")
    edges <- edges[ edges$from != edges$to,]
    
    output$vis <- renderVisNetwork({ 
        visNetwork(
                data.frame( id = 1:18, label = label_w) %>% filter( label %in% input$women),
                edges,
                width = "100%") %>% 
            visNodes(shape = "star", 
                     color = list(background = "yellow", 
                                  border = "black",
                                  highlight = "red"),
                     shadow = list(enabled = TRUE, size = 10)) %>%
            visLayout(randomSeed = 1)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
