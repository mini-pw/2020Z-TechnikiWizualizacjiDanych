library(shiny)
library(SmarterPoland)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  titlePanel("Simple Observer"),
  verbatimTextOutput("selected_value"),
  plotOutput("countries_plot", height = 600, click = "countries_click")
)

server <- function(input, output) {
  
  selected_countries <- reactive({
    nearPoints(countries, input[["countries_click"]], maxpoints = 1)[["country"]]
  })
  
  output[["selected_value"]] <- renderPrint({
    selected_countries()
  })
  
  output[["countries_plot"]] <- renderPlot({
    mutate(countries, selected = country %in% selected_countries()) %>% 
      ggplot(aes(x = birth.rate, y = death.rate, color = continent, size = selected)) +
      geom_point() +
      theme_bw()
  })
  
}

shinyApp(ui = ui, server = server)
