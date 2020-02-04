#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(rpivotTable)

data <- read.csv("pokemon.csv")

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Praca domowa ostatnia - Michał Wdowski"),
    mainPanel(
        textOutput(outputId = "text1"),
        rpivotTableOutput(outputId = "table1")
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output[["table1"]] <- renderRpivotTable({rpivotTable(
        data = data,
        cols = "Height_m",
        rows = "Weight_kg",
        aggregatorName = "List Unique Values",
        vals = "Name",
        rendererName = "Scatter Chart",
        height = 700
    )})
    
    output[["text1"]] <- renderText("Dane o Pokemonach")
}

# Run the application 
shinyApp(ui = ui, server = server)
