library(shiny)
library(shinydashboard)
library(r2d3)
library(shinyjs)
library(colourpicker)
library(rpivotTable)
library(dplyr)

load("dragons.rda")
#załóżmy, że smoki żyją krótko, a podana długość życia jest w miesiąch
dragons <- dragons %>% mutate(year_of_dead = round(year_of_birth+(life_length/365)))
dragons$year_of_dead <- ifelse((dragons$year_of_birth < 0 & dragons$year_of_dead > 0), dragons$year_of_dead + 1 , dragons$year_of_dead)


ui <- dashboardPage(
  skin = "purple",
  dashboardHeader(title = "Dragons", titleWidth = 360),
  dashboardSidebar(
    width = 360,
    sidebarMenu(
      menuItem(" Dragons data visualizations", tabName = "visualization", icon = icon("chart-bar")),
      menuItem(" If you want to know more about dragons... ", icon = icon("d-and-d"),
               div("Dragon statistics: "),
               div("Move the mouse over the point to see the exact value"),
               selectInput("statistics", label = "Select what you want to see:",
                           choices = c("max", "min", "mean")),
               selectInput("information", label = "Select what you want to see:", 
                           choices = c("Number of scars" = "scars",
                                       "Weight of the dragon" = "weight",
                                       "Height of the dragon" = "height",
                                       "Number of teeth that the dragon lost" = "number_of_lost_teeth")),
               colourInput("colourpoints", "Pick a points colour:", value = "#85C1E9"),
               div("Population of dragons:"),
               div("Select colour of dragons"),
               checkboxInput("black", label = "Black dragons", value = TRUE),
               checkboxInput("blue", label = "Blue dragons", value = TRUE),
               checkboxInput("green", label = "Green dragons", value = FALSE),
               checkboxInput("red", label = "Red dragons", value = TRUE),
               div("Select the years you are interested in the dragon population"),
               numericInput("max_year", "Maximum year:", 17, min = -1999, max = 1803),
               numericInput("min_year", "Minimum year:", -10, min = -1999, max = 1803),
               colourInput("colourbar", "Pick a bar chart colour:", value = "#85C1E9")
               ),
      menuItem(" Dragons data ", tabName = "data", icon = icon("table"))
    )
    
  ),
  dashboardBody( 
    tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
    tabItems(
      tabItem(
        tabName = "visualization",
        fluidRow(
          box(h2("Dragon statistics"), 
              d3Output("plot2", width = "470px", height = "600px"), width = 6),
          box(
            h2("Population of dragons"),
            d3Output("plot1", width = "500px", height = "600px"), width = 6)
        )),
      tabItem(
        tabName = "data",
        fluidRow(
          h2("Data used for visualization"),
          h4("You can download this dataset from: https://github.com/ModelOriented/DALEX2/blob/master/data/dragons.rda"),
          tableOutput("dragons")
    )
      )
    )
  )
)

server <- function(input, output) {
  
  output$plot1 <- renderD3({
    r2d3(data.frame( dragons, 
                     black = input[["black"]],
                     blue = input[["blue"]],
                     green = input[["green"]],
                     red = input[["red"]],
                     max_year = input[["max_year"]],
                     min_year = input[["min_year"]],
                     colourbar = input[["colourbar"]]
                     ),
         script = "smoki1.js")
  })
  
  output$plot2 <- renderD3({
    r2d3(data.frame( dragons,
                     statistics = input[["statistics"]],
                     information = input[["information"]],
                     colourpoints = input[["colourpoints"]]),
         script = "smoki2.js")
  })
  
  output$dragons <- renderTable(dragons)
}

shinyApp(ui, server)