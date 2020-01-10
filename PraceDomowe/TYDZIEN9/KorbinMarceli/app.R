library(shiny)
library(r2d3)
library(dplyr)
library(ggbeeswarm)

ranking <- read.csv("happy_ranking.csv")

ui <- fluidPage(
  titlePanel("Happiness Index in the world regions in years 2015–2019"),
  inputPanel(
    sliderInput("year", label = "Year",
                min = 2015, max = 2019, value = 2019, step = 1),
    checkboxGroupInput("zone", label = "Zone", choices = unique(ranking$Regional.indicator),
                       selected = unique(ranking$Regional.indicator))
  ),
  plotOutput("plot", height=500, hover="countries_hover")
)

server <- function(input, output) {
  
  selected_countries <- reactiveValues(
    selected = character()
  )
  
  observeEvent(input[["countries_hover"]], {
    selected_countries[["selected"]] <- nearPoints(ranking, input[["countries_hover"]], 
                                                   maxpoints = 1)[["country"]]
    
  })
  
  output[["plot"]] <- renderPlot(
    ggplot(ranking %>%
             mutate(selected = country %in% selected_countries[["selected"]]) %>%
             filter(Regional.indicator %in% input$zone),
           aes_string(x="Regional.indicator",
                      y=paste0("score", input$year))) +
      geom_quasirandom(mapping=aes(colour=Regional.indicator),
                       method="smiley",
                       na.rm=TRUE) +
      geom_label(aes(label = if_else(selected, country, NULL)), na.rm=TRUE) +
      scale_colour_manual(values=rainbow(length(input$zone), v=5/6)) +
      theme(axis.text.x = element_blank())
  )
}

shinyApp(ui = ui, server = server)