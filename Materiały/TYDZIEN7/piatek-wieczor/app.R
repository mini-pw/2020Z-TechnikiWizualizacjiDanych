library(shiny)
library(ggplot2)
library(SmarterPoland)
library(dplyr)

ui <- fluidPage(
  title = "Piątek wieczór",
  plotOutput(outputId = "countries_plot", click = "countries_click"),
  checkboxGroupInput(inputId = "countries_choose", label = "Wybierz kontynent", 
                     choices = unique(countries[["continent"]]),
                     selected = unique(countries[["continent"]])),
  verbatimTextOutput(outputId = "click_res")
)

server <- function(input, output) {
  
  countries_r <- reactive({ 
    
    filter(countries, continent %in% input[["countries_choose"]])
    
    })
  
  output[["countries_plot"]] <- renderPlot({
    
    countries_r() %>% 
      ggplot(aes(x = birth.rate, y = death.rate, color = continent)) +
      geom_point()
    
  })
  
  output[["click_res"]] <- renderPrint({
    
    nearPoints(countries_r(), input[["countries_click"]])
    
  })
  
}

shinyApp(ui = ui, server = server)
