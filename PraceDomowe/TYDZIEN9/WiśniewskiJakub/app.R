#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(r2d3)
library(colourpicker)
library(rsconnect)



# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Zarobki w wybranych miastach Polski"),

    inputPanel(
            selectInput("pick_col", label = "Select column", choices = c("POLSKA","Wrocław","Lublin","Kraków",
                                                                         "Warszawa","Gdańsk","Katowice","Sosnowiec","Szczecin")),
            colourInput("lineCol",
                        label = "Pick line colour",
                        value = "black"),
            colourInput("dotCol",
                        label = "Pick dot colour",
                        value = "black"),
            selectInput("pick_col2", label = "Select column to compare with", choices = c("POLSKA","Wrocław","Lublin","Kraków",
                                                                          "Warszawa","Gdańsk","Katowice","Sosnowiec","Szczecin")),
            colourInput("lineCol2",
                        label = "Pick line colour",
                        value = "blue"),
            colourInput("dotCol2",
                        label = "Pick dot colour",
                        value = "blue")
        ),

        d3Output("d3")
)

server <- function(input, output) {

    output[["d3"]] <- renderD3({
        # Wczytanie danych do wykresu
        csvData = read.csv(file = "toDo.csv", sep = ",")
        
        r2d3(data.frame(csvData, 
                        pickedColumn = input[["pick_col"]], 
                        lineCol = input[["lineCol"]],
                        dotCol = input[["dotCol"]],
                        colToCompare = input[["pick_col2"]],
                        lineCol2 = input[["lineCol2"]],
                        dotCol2 = input[["dotCol2"]]),
             script = "skrypt.js", width = 1600, height = 500
        )
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
