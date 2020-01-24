library(shiny)
library(r2d3)
library(colourpicker)

ui <- fluidPage(
    titlePanel("Porównywanie parametrów smoków"),
  
  inputPanel(
    selectInput("parameter1", label = "Wybierz parametr 1", 
                choices = c("długość życia" = "life_length",
                            "waga" = "weight",
                            "wysokość" = "height",
                            "blizny" = "scars",
                            "rok odkrycia" = "year_of_discovery",
                            "liczba straconych zębów" = "number_of_lost_teeth",
                            "rok urodzenia" = "year_of_birth")),
    selectInput("parameter2", label = "Wybierz parametr 2", 
               choices = c("blizny" = "scars",
                           "liczba straconych zębów" = "number_of_lost_teeth",
                           "waga" = "weight",
                           "wysokość" = "height",
                           "rok odkrycia" = "year_of_discovery",
                           "długość życia" = "life_length",
                           "rok urodzenia" = "year_of_birth")),
    colourInput("dotColor",
                label = "Wybierz kolor punktów",
                value = "black"),
    checkboxInput("defaultColor", "Czy barwa zgodna ze smokiem", value = TRUE),
    sliderInput("dotSize", label = "Wielkość punktów", min = 1, max = 5, step = 0.5, value = 1)
  ),
  
  d3Output("d3")
)

server <- function(input, output) {
  
  output[["d3"]] <- renderD3({
    load(file = "dragons.rda")

    r2d3(data.frame(dragons, 
                    parameter1 = input[["parameter1"]], 
                    parameter2 = input[["parameter2"]], 
                    dotColor = input[["dotColor"]],
                    dotSize = input[["dotSize"]],
                    defaultColor = input[["defaultColor"]]),
         script = "script.js", width = 0, height = 0
    )
  })
}


shinyApp(ui = ui, server = server)
