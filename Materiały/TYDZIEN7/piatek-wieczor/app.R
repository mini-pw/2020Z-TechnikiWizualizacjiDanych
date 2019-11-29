library(shiny)
library(ggplot2)
library(SmarterPoland)
library(dplyr)
library(shinythemes)

ui <- fluidPage(
  title = "Piątek wieczór",
  theme = shinytheme("cyborg"), 
  sidebarPanel(
    checkboxGroupInput(inputId = "countries_choose", label = "Wybierz kontynent", 
                       choices = unique(countries[["continent"]]),
                       selected = unique(countries[["continent"]])),
    
    uiOutput(outputId = "slider_x")
  ),
  mainPanel(
    verbatimTextOutput(outputId = "click_res"),
    plotOutput(outputId = "countries_plot", click = "countries_click")
  )
)

server <- function(input, output) {
  
  countries_r <- reactive({ 
    
    filter(countries, continent %in% input[["countries_choose"]])
    
    })
  
  output[["countries_plot"]] <- renderPlot({
    
    countries_r() %>% 
      ggplot(aes(x = birth.rate, y = death.rate, color = continent)) +
      geom_point() +
      scale_x_continuous(limits = input[["countries_slide_x"]])
    
  })
  
  output[["click_res"]] <- renderPrint({
    
    nearPoints(countries_r(), input[["countries_click"]])
    
  })
  
  output[["slider_x"]] <- renderUI({
    
    sliderInput(inputId = "countries_slide_x", label = "Ogranicz oś", 
                min = min(countries_r()[["birth.rate"]], na.rm = TRUE), 
                max = max(countries_r()[["birth.rate"]], na.rm = TRUE),
                value = range(countries_r()[["birth.rate"]]))
    
  })
  
}

shinyApp(ui = ui, server = server)
