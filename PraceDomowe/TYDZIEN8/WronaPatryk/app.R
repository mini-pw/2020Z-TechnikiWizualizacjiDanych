
library(shinythemes)
library(shiny)
library(r2d3)



ui <- fluidPage(
  theme = shinytheme("yeti"),
  titlePanel("Very Shy Christmas tree"),
                h3("It will last only for 3 seconds!"),
                sidebarLayout(
                  sidebarPanel(
                    sliderInput(
                      "height",
                      "Height in cm:",
                      min = 100,
                      max = 300,
                      value = 150
                    ),
                    selectInput(
                      "treeColour",
                      "Tree Colour:",
                      c("green", "darkolivegreen", "darkslategray","lime")
                    ),
                    sliderInput(
                      "numberOfBalls",
                      "Number of christmas balls:",
                      min = 0,
                      max = 100,
                      value = 50
                    ),
                    selectInput(
                      "starColour",
                      "Star Colour:",
                      c("gold", "silver", "deeppink")
                    )
                  ),
                  mainPanel(
                    d3Output("d3", height = "500px")
                  )
                )
)


server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(
      data.frame(
        height = input[["height"]],
        treeColour = input[["treeColour"]],
        numberOfBalls = input[["numberOfBalls"]],
        starColour = input[["starColour"]]
      ),
      script = "tree.js"
    )
  })
}

shinyApp(ui = ui, server = server)


