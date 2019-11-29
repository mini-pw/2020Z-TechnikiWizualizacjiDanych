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
  
  selected_country <- reactiveValues(
    country = character()
  )
  
  observeEvent(input[["countries_click"]], {
    selected_country[["country"]] <- c(selected_country[["country"]],
                                       nearPoints(countries, input[["countries_click"]],
                                                  maxpoints = 1)[["country"]])

    nonunique_country <- table(country = selected_country[["country"]]) %>% 
      as.data.frame() %>% 
      filter(Freq == 2) %>% 
      pull(country) %>% 
      as.character()
    
    selected_country[["country"]] <- setdiff(selected_country[["country"]], nonunique_country)
  })
  
  
  output[["countries_plot"]] <- renderPlot({
    mutate(countries, selected = country %in% selected_country[["country"]]) %>% 
      ggplot(aes(x = birth.rate, y = death.rate, color = continent, size = selected)) +
      geom_point() +
      theme_bw()
  })
  
  output[["processed_selection"]] <- renderPrint({
    selected_country[["country"]]
  })
  
}

shinyApp(ui = ui, server = server)