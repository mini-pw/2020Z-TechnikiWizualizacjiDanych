library(shiny)
library(rpivotTable)

data <- read.csv("IMDB.csv")


ui <- fluidPage(
    
    titlePanel("PD12 Zuzanna Mróz - Top rated English movies of this decade from IMDB"),
    mainPanel(
        textOutput(outputId = "text"),
        rpivotTableOutput(outputId = "table")
    )
)


server <- function(input, output) {
    
    output[["table"]] <- renderRpivotTable({rpivotTable(
        data = data,
        cols = "Rating",
        rows = "Genre1",
        aggregatorName = "Count Unique Values",
        vals = "Title",
        rendererName = "Stacked Bar Chart",
    )})
    
    output[["text"]] <- renderText("OCENA VS GATUNEK FILMU")
}

shinyApp(ui = ui, server = server)

