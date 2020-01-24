library(shiny)
library(r2d3)
load('./dragons.rda')

ui <- fluidPage(

    titlePanel("Smoki"),

        fluidRow(
            column(3,selectInput('x', 'Wybierz oś X:', colnames(dragons), selected = "year_of_discovery")),
            column(3,selectInput('y', 'Wybierz oś Y:', colnames(dragons), selected = "number_of_lost_teeth")),
            column(3,selectInput('col', 'Wybierz kolor:', colnames(dragons), selected = 'colour')),
            column(3,numericInput('sample', 'Ilość:', 500, min = 0, max = 2000))),
        mainPanel(
           d3Output('d3', height = 10)  
        )
    )

server <- function(input, output) {
    output[["d3"]] <- renderD3({
        library(dplyr)
        df <- data.frame(x = dragons[,input$x], y = dragons[,input$y], c =  dragons[,input$col], xname = input$x, yname = input$y)
        df <- sample_n(df, input$sample)
        
        # sort, żeby potem legenda była też posortowana
        df <- df %>% arrange(c)
        r2d3(df, script = "skrypt.js")
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
