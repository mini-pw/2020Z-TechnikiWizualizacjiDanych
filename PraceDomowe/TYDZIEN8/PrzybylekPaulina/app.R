library(shiny)
library(shinyjs)
library(r2d3)
library(shinythemes)

ui <- fluidPage(
  
  useShinyjs(),
  
  theme = shinytheme("superhero"),
  
  titlePanel("Choinka"),
  
  sidebarPanel(numericInput("bombki",
                           "Liczba bombek:",
                           value = 40),
               
               selectInput("kolory", label = "Kolor bombek:", 
                           choices = c("purple", "pink" , "red", "white", "blue", "orange")),
               
               sliderInput(
                 "wysokosc", label = "Wysokość choinki:", min = 100, max = 350, value = 300
               ),
               
               checkboxInput(
                 "gwiazda", label = "Gwiazdka na szczycie", value = TRUE
               ),
               
               checkboxInput(
                 "lancuch", label = "Lańcuch na choince", value = FALSE
               ),
               
               selectInput("kolorlancucha", label = "Kolor lancucha na choince:", 
                           choices = c("silver", "gold")),
               
               sliderInput(
                 "lampeczki", label = "Liczba lampek:", min = 0, max = 100,  value = 35
               )
  ),
  
  mainPanel(d3Output("d3", height = "500px", width = "500px"))
  
)

server <- function(input, output) {
  
  output[["d3"]] <- renderD3({
    r2d3(data.frame( bombki = input[["bombki"]],
                     kolory = input[["kolory"]],
                     wysokosc = input[["wysokosc"]],
                     gwiazda = input[["gwiazda"]],
                     lancuch = input[["lancuch"]],
                     kolorlancucha = input[["kolorlancucha"]],
                     lampeczki = input[["lampeczki"]]),
         
         script = "choinka.js"
    )
  })
}

shinyApp(ui = ui, server = server)