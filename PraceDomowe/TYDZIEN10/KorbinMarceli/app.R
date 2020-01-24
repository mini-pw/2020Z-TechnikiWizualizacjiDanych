library(shiny)
library(r2d3)
library(dplyr)

load("dragons.rda")

kolory <- unique(dragons$colour)

ui <- fluidPage(
  titlePanel("Dragons' physical harms according to their height and weight / Krzywdy fizyczne smoków w zależności od ich wysokości i wagi"),
  inputPanel(
    checkboxGroupInput("colour", label = "Colour", 
                choices = kolory, selected=sample(kolory, 2)), #aplikacja zaczyna od dwóch losowych kolorów
    selectInput("measure", label="Measure", choices=c("height", "weight")),
    selectInput("impairment", label="Impairment", choices=c("scars", "number_of_lost_teeth"))
  ),
  d3Output("d3")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    if (length(input$colour)>0)
      smoki <- dragons %>% filter(colour %in% input$colour)
    else
      smoki <- dragons
    # jeżeli nie wybieramy żadnego konkretnego koloru, to pokazują się po prostu wszystkie
    r2d3(data.frame(meas = smoki[[input$measure]],
                    measN = input$measure,
                    imp = smoki[[input$impairment]],
                    impN = input$impairment,
                    col = smoki$colour), 
         script = "kodwykresu.js"
    )
  })
}

shinyApp(ui = ui, server = server)