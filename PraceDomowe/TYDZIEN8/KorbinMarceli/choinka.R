library(shiny)
library(r2d3)

ui <- fluidPage(
  inputPanel(
    sliderInput("szerokosc", label = "szerokość choinki",
                min = 50, max = 500, value = 400, step = 5),
    sliderInput("poziomy", label = "liczba poziomów choinki",
                min = 1, max = 15, value = 3, step = 1),
    sliderInput("jasnosc", label = "jasność choinki",
                min = 0, max = 1, value = 0.5, step = 0.02),
    sliderInput("zielonosc", label = "zieloność choinki",
                min = 0, max = 1, value = 1, step = 0.02)
  ),
  d3Output("d3")
)

kolory <- function(n) {
  return(rgb(runif(n, 0, 1), runif(n, 0, 1), runif(n, 0, 1)))
}

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(data.frame(szr = input[["szerokosc"]],
                    poz = c(1:input[["poziomy"]]),
                    pozM = input[["poziomy"]],
                    kolor = hsv(1/3, input[["zielonosc"]], input[["jasnosc"]])
              ),
         script = "choinkod.js"
    )
  })
}

shinyApp(ui = ui, server = server)