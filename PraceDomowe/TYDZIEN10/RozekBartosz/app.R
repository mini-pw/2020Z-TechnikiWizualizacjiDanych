library(shiny)
library(SmarterPoland)
library(ggplot2)
library(dplyr)

load(file = "dragons.rda")
ramka <- data.frame(kod = colnames(dragons), 
           nazwa = c("Rok urodzenia", "Wysokość", "Waga", "Blizny", "Kolor", "Rok odkrycia", "Liczba straconych zębów", "Długość życia"))

ui <- fluidPage(
  titlePanel("Smoki - analiza danych, zrób to sam!"),
  plotOutput("dragons_plot", height = 600),
  inputPanel(
    selectInput("x", label = "Oś X", ramka$nazwa, selected = NULL, multiple = FALSE,
                selectize = TRUE, width = NULL, size = NULL),
    selectInput("y", label = "Oś Y", ramka$nazwa, selected = NULL, multiple = FALSE,
                selectize = TRUE, width = NULL, size = NULL),
  selectInput("grad", label = "Wartość pokazana kolorem", ramka$nazwa, selected = NULL, multiple = FALSE,
              selectize = TRUE, width = NULL, size = NULL))
  
)

server <- function(input, output) {
  
    output[["dragons_plot"]] <- renderPlot({
    p <- ggplot(dragons) 
    if (input[["y"]] == "Rok urodzenia")
      p <- p + aes(y = year_of_birth)
    if (input[["y"]] == "Wysokość")
      p <- p + aes(y = height)
    if (input[["y"]] == "Waga")
      p <- p + aes(y = weight)
    if (input[["y"]] == "Blizny")
      p <- p + aes(y = scars)
    if (input[["y"]] == "Kolor")
      p <- p + aes(y = colour)
    if (input[["y"]] == "Rok odkrycia")
      p <- p + aes(y = year_of_discovery)
    if (input[["y"]] == "Liczba straconych zębów")
      p <- p + aes(y = number_of_lost_teeth)
    if (input[["y"]] == "Długość życia")
      p <- p + aes(y = life_length)
    
    if (input[["x"]] == "Rok urodzenia")
      p <- p + aes(x = year_of_birth) +
        geom_point()
    if (input[["x"]] == "Wysokość")
      p <- p + aes(x = height) +
        geom_point()
    if (input[["x"]] == "Waga")
      p <- p + aes(x = weight) +
        geom_point()
    if (input[["x"]] == "Blizny")
      p <- p + aes(x = scars) +
        geom_point()
    if (input[["x"]] == "Kolor")
      p <- p + aes(x = colour) +
        geom_violin()
    if (input[["x"]] == "Rok odkrycia")
      p <- p + aes(x = year_of_discovery) +
        geom_point()
    if (input[["x"]] == "Liczba straconych zębów")
      p <- p + aes(x = number_of_lost_teeth) +
        geom_point()
    if (input[["x"]] == "Długość życia")
      p <- p + aes(x = life_length) +
        geom_point()
    
    if (input[["grad"]] == "Rok urodzenia")
      p <- p + aes(colour = year_of_birth) +
        scale_colour_gradient(low="red", high="blue")
    if (input[["grad"]] == "Wysokość")
      p <- p + aes(colour = height) +
        scale_colour_gradient(low="red", high="blue")
    if (input[["grad"]] == "Waga")
      p <- p + aes(colour = weight) +
        scale_colour_gradient(low="red", high="blue")
    if (input[["grad"]] == "Blizny")
      p <- p + aes(colour = scars) +
        scale_colour_gradient(low="red", high="blue")
    if (input[["grad"]] == "Kolor")
      p <- p + aes(colour = colour)
    if (input[["grad"]] == "Rok odkrycia")
      p <- p + aes(colour = year_of_discovery) +
        scale_colour_gradient(low="red", high="blue")
    if (input[["grad"]] == "Liczba straconych zębów")
      p <- p + aes(colour = number_of_lost_teeth) +
        scale_colour_gradient(low="red", high="blue")
    if (input[["grad"]] == "Długość życia")
      p <- p + aes(colour = life_length) +
        scale_colour_gradient(low="red", high="blue")
    
    p <- p + labs(x = input[["x"]], y = input[["y"]], colour = input[["grad"]])
    p
  })
  

  
}

shinyApp(ui = ui, server = server)
