library(shiny)
library(r2d3)

dragons <- read.csv("dragons.csv")
dragons <- as.data.frame(dragons)

dragons$BMI <-  (dragons$weight*1000)/(dragons$height*0.9144)^2

ui <- shinyUI(fluidPage(
  tags$head(
    tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Amarante');
      
      h1 {
        font-family: 'Amarante', cursive;
        font-weight: 500;
        line-height: 1.1;
        color: #a11b12;
      }

    "))
  ),
  headerPanel("How obesity and militancy affect dragons' lifes' length"),
  inputPanel(
    selectInput("choice", label = "Choose dragons' lifestyle:", choices = c("All", "Calm (less than 20 scars)", "Fierce (at least 20 scars)"), selected = "All"),
    checkboxInput("red", label = "czerwone", value = TRUE),
    checkboxInput("green", label = "zielone", value = TRUE),
    checkboxInput("blue", label = "niebieskie", value = TRUE),
    checkboxInput("black", label = "czarne", value = TRUE)
  ),
  d3Output("d3")
))

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(data.frame(dragons, choice = input[["choice"]],red = input[["red"]], green = input[["green"]], black = input[["black"]],
                    blue = input[["blue"]]), script = "script.js", width = 1000, height = 2000) 
  })
}

shinyApp(ui = ui, server = server)

