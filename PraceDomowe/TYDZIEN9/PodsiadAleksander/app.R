library(shiny)
library(r2d3)

ui <- fluidPage(
  titlePanel("Share of Women and Men in the Labour Force and in Top Positions"),
  inputPanel(
    h4("Choose position:"),
    checkboxInput("lab", "Labour Force", value = TRUE), 
    checkboxInput("man", "Managers", value = TRUE), 
    checkboxInput("sen", "Senior Managers", value = TRUE), 
    checkboxInput("com", "Company Boards", value = TRUE), 
    checkboxInput("top", "TOP 0.1%", value = TRUE), 
    checkboxInput("ceo", "CEO'S", value = TRUE), 
    selectInput("gender", "Choose gender:",
                choices = c("Female", "Male", "Both"),
                selected = "Both")),
  d3Output("d3"))

server <- function(input, output){
  
  dane <- read.csv("dane.csv")
  
  output[["d3"]] <- renderD3({r2d3(data = data.frame(dane, gend = input[["gender"]], 
                                                     lab = input[["lab"]], man = input[["man"]],
                                                     sen = input[["sen"]], com = input[["com"]],
                                                     topp = input[["top"]], ceo = input[["ceo"]]), script = "skrypt.js", width = 1000, height = 600)})
}


shinyApp(ui, server)