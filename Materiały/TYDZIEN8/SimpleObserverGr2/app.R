library(shiny)
library(SmarterPoland)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
  titlePanel("Simple Observer"),
  verbatimTextOutput("selected_value"),
  plotOutput("countries_plot", height = 600, hover = "countries_hover")
)

server <- function(input, output) {
  
  selected_countries <- reactiveValues(
    selected = character()
  )
  
  observeEvent(input[["countries_hover"]], {
    selected_countries[["selected"]] <- nearPoints(countries, input[["countries_hover"]], 
                                                     maxpoints = 1)[["country"]]

  })
  
  output[["selected_value"]] <- renderPrint({
    selected_countries[["selected"]]
  })
  
  output[["countries_plot"]] <- renderPlot({
    mutate(countries, selected = country %in% selected_countries[["selected"]],
           ) %>% 
      ggplot(aes(x = birth.rate, y = death.rate, color = continent, size = selected, 
                 label = if_else(selected, country, NULL))) +
      geom_point() +
      geom_label(nudge_x = 1) +
      theme_bw()
  })
  
}

shinyApp(ui = ui, server = server)
