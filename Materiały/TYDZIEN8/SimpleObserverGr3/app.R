library(shiny)
library(SmarterPoland)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Simple Observer"),
  verbatimTextOutput("selected_countries_value"),
  plotOutput("countries_plot", height = 600, click = "countries_click")
)

server <- function(input, output) {
  
  selected_countries <- reactiveValues(
    selected = character()
  )
  
  observeEvent(input[["countries_click"]], {
    selected_countries[["selected"]] <- nearPoints(countries, input[["countries_click"]], 
                                                   maxpoints = 1)[["country"]]
  })
  
  output[["selected_countries_value"]] <- renderPrint({
    selected_countries[["selected"]]
  })
  
  output[["countries_plot"]] <- renderPlot({
    mutate(countries, selected = country %in% selected_countries[["selected"]]) %>% 
      ggplot(aes(x = birth.rate, y = death.rate, color = continent, size = selected)) +
      geom_point() +
      theme_bw()
  })
  
}

shinyApp(ui = ui, server = server)
