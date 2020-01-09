library(shiny)
#install.packages("r2d3")
library(r2d3)

ui <- fluidPage(
  inputPanel(
    # wysokość choinki
    sliderInput("im_height", label = "Image height:",
                min = 100, max = 400, value = 400, step = 50),
    
    # szerokość choinki
    sliderInput("im_width", label = "Image width:",
                min = 100, max = 400, value = 300, step = 50),
    
    #liczba "poziomów" choinki"
    sliderInput("levels", label = "Christmas tree levels:",
                min = 2, max = 16, value = 7, step = 1),
    
    # kolor choinki
    selectInput("tree_color", label = "Plant color:",
                choices = c("forestgreen", "green", "darkolivegreen",
                            "darkgreen", "lime")),
    
    # występowanie bombek
    checkboxInput("are_baubles", label = "Want some baubles?"),
    
    # jeśli bombki są...
    conditionalPanel(
      "input.are_baubles",
      
      # jak duże?
      sliderInput("baubles_size", label = "Size of baubles:",
                  min = 1, max = 3, value = 2, step = 1)
    ),
    
    conditionalPanel(
      "input.are_baubles",
      
      # jak często?
      sliderInput("baubles_freq", label = "Frequency of baubles:",
                  min = 0, max = 100, value = 50, step = 1)
    )
  ),
  d3Output("d3")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(data.frame(im_height = input[["im_height"]],
                    im_width = input[["im_width"]],
                    tree_color = input[["tree_color"]],
                    levels = input[["levels"]],
                    are_baubles = input[["are_baubles"]],
                    baubles_size = input[["baubles_size"]],
                    baubles_freq = input[["baubles_freq"]]
    ), 
    
    script = "choinka.js"
    )
  })
}

shinyApp(ui = ui, server = server)
