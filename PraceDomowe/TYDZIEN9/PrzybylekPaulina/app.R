library(shiny)
library(shinydashboard)
library(r2d3)
library(shinyjs)
library(colourpicker)

ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Data Visualization", titleWidth = 400),
  dashboardSidebar(
    width = 400,
    sidebarMenu(
      menuItem("Click to see option", icon = icon("chart-line"),
               selectInput("area1", "Select area of imports:",
                           choices = c("USA and CAN", "Euro area", "China",
                                       "East Asia excluding China"," Other EMDEs",
                                       "United Kingdom", "Rest of world"),
                           width = '98%'),
               colourInput("colour1", "Pick a line colour:", value = "blue"),
               selectInput("area2", "Select area of imports to compare with:",
                           choices = c("None", "USA and CAN", "Euro area", "China",
                                       "East Asia excluding China"," Other EMDEs",
                                       "United Kingdom", "Rest of world"),
                           width = '98%'),
               colourInput("colour2", "Pick a line colour:", value = "red"))
    )

  ),
  dashboardBody( 
    titlePanel("Contribution to Global Imports"),
    d3Output("plot")
    )
)

server <- function(input, output) {

  output$plot <- renderD3({
    
    csv = read.csv(file = "dane.csv", sep = ",")
    r2d3(data.frame( csv,
                     area1 = input[["area1"]],
                     colour1 = input[["colour1"]],
                     area2 = input[["area2"]],
                     colour2 = input[["colour2"]]),
         script = "wykres.js", width = 6000)
  })

}

shinyApp(ui, server)