library(shiny)
library(SmarterPoland)
library(ggplot2)
library(dplyr)
library(plotly)

ui <- fluidPage(
  checkboxGroupInput(inputId = "countries_choose", label = "Wybierz kontynenty", 
                     choices = sort(unique(countries[["continent"]])),
                     selected = sort(unique(countries[["continent"]]))),
  plotOutput(outputId = "countries_plot", hover = "countries_hover"),
  tableOutput(outputId = "hover_result"),
  plotlyOutput(outputId = "countries_plotly")
)

server <- function(input, output) {
  
  r_countries_plot <- reactive({
    unique_continents <- unique(countries[["continent"]])
    lazy_palette <- rainbow(length(unique_continents)) %>% 
      setNames(unique_continents)
    
    countries %>% 
      filter(continent %in% input[["countries_choose"]]) %>% 
      ggplot(aes(x = birth.rate, y = death.rate, color = continent)) +
      geom_point() +
      scale_color_manual(values = lazy_palette) +
      scale_x_continuous(limits = range(countries[["birth.rate"]], na.rm = TRUE)) +
      scale_y_continuous(limits = range(countries[["death.rate"]], na.rm = TRUE))
  })
  
  output[["hover_result"]] <- renderTable({
    nearPoints(countries, input[["countries_hover"]], maxpoints = 5, threshold = 20)
  })
  
  
  output[["countries_plot"]] <- renderPlot({
    r_countries_plot()
  }) 
  
  output[["countries_plotly"]] <- renderPlotly({
    r_countries_plot() %>% 
      ggplotly()
  })
  
}

shinyApp(ui = ui, server = server)
