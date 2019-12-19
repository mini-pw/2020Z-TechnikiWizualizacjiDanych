library(r2d3)
library(shiny)

ui <- fluidPage(
  titlePanel("Fractal Christmas Tree"),
  inputPanel(
    sliderInput("Number_of_points", label = "Number of points generated:",
                min = 1e3, max = 5e4, value = 2.5e4, step = 1),
    sliderInput("Number_of_baubles", label = "Number of baubles generated:",
                min = 1, max = 40, value = 1, step = 1),
    p("Fractal is being generated. It might take a few seconds. Please be patient :)")
    
    
  ),
  d3Output("d3")
)


server <- function(input, output){
  
  output[["d3"]] <- renderD3({
    r2d3(data = generateFractal(input[["Number_of_points"]],input[["Number_of_baubles"]]),
         script = "tree.js")
})
}

shinyApp(ui = ui, server = server)
