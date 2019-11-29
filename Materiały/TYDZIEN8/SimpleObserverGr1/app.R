library(shiny)
library(SmarterPoland)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  titlePanel("Simple Observer"),
  verbatimTextOutput("processed_selection"),
  plotOutput("countries_plot", height = 600, 
             click = "countries_click")

)

server <- function(input, output) {
  
  selected_country <- reactive({
    nearPoints(countries, input[["countries_click"]], 
               maxpoints = 1)
  })
  
  output[["countries_plot"]] <- renderPlot({
    mutate(countries, selected = country %in% selected_country()[["country"]]) %>% 
      ggplot(aes(x = birth.rate, y = death.rate, color = continent, size = selected)) +
      geom_point() +
      theme_bw()
  })
  
  output[["processed_selection"]] <- renderPrint({
    selected_country()
  })
  
}

shinyApp(ui = ui, server = server)