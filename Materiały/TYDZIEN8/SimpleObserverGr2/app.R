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
  
  selected_countries <- reactiveValues(
    selected = character()
  )
  
  observeEvent(input[["countries_click"]], {
    selected_countries[["selected"]] <- c(selected_countries[["selected"]],
                                          nearPoints(countries, input[["countries_click"]], 
                                                     maxpoints = 1)[["country"]])
    
    if(length(selected_countries[["selected"]]) > 0) {
      nonunique_countries <- table(country = selected_countries[["selected"]]) %>% 
        as.data.frame() %>% 
        filter(Freq == 2) %>% 
        pull(country) %>% 
        as.character()
      selected_countries[["selected"]] <- setdiff(selected_countries[["selected"]], nonunique_countries)
    }
  })
  
  output[["selected_value"]] <- renderPrint({
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
