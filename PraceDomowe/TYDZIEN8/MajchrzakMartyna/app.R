library(shiny)
library(r2d3)

ui <- fluidPage(titlePanel("CHOINKA"),
                sidebarLayout(
                  sidebarPanel(
                    sliderInput(
                      "height",
                      "Wysokość choinki",
                      min = 100,
                      max = 450,
                      value = 300
                    ),
                    sliderInput(
                      "width",
                      "Szerokość choinki",
                      min = 50,
                      max = 300,
                      value = 200
                    ),
                    numericInput(
                      "smallBaubleCount",
                      "Liczba małych bombek",
                      min = 0,
                      max = 100,
                      value = 25
                    ),
                    selectInput(
                      "smallBaubleColor", 
                      "Kolor małych bombek:",
                      choices = c("red", 
                                  "gold",
                                  "silver", 
                                  "blue"),
                      selected="red"),
                    numericInput(
                      "bigBaubleCount",
                      "Liczba dużych bombek",
                      min = 0,
                      max = 100,
                      value = 15
                    ),
                    selectInput(
                      "bigBaubleColor", 
                      "Kolor dużych bombek:",
                      choices = c("red", 
                                  "gold",
                                  "silver", 
                                  "blue"),
                      selected="gold"),
                    
                  ),
                  mainPanel(
                    conditionalPanel(
                      "checkboxes",
                      checkboxInput(
                        "chainShining", 
                        label = "Podłącz lampki do prądu", 
                        value = FALSE, 
                        width = "200px"
                      )
                    ),
                    d3Output("d3", height = "500px")
                  )
                )
              )
            


server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(
      data.frame(
        height = input[["height"]],
        width = input[["width"]],
        smallBaubleCount= round(input[["smallBaubleCount"]]),
        smallBaubleColor=input[["smallBaubleColor"]],
        bigBaubleCount=round(input[["bigBaubleCount"]]),
        bigBaubleColor=input[["bigBaubleColor"]],
        chainShining=input[["chainShining"]]
      ),
      script = "choinka.js"
    )
  })
}

shinyApp(ui = ui, server = server)