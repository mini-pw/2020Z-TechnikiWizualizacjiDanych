library(shiny)
library(r2d3)

ui <- fluidPage(
  inputPanel(
    #kolory bombek
    selectInput("col_bom1", label = "Dodaj bombki koloru:", choices = c("red","pink","magenta","purple" ,"white","lime", "cyan", "blue", "black", "yellow")),
    #kolor łańcuchów
    selectInput("col_chain", label = "Kolor łańcucha:", choices = c("red","pink","magenta","purple" ,"white","lime", "cyan", "blue", "black", "yellow")),
    #kolor gwiazdki
    selectInput("col_star", label = "Kolor gwiazdki:", choices = c("red","pink","magenta","purple" ,"white","lime", "cyan", "blue", "black", "yellow")),
    
    div(id= "form",actionButton("reset_bom", "Zdejmij bombki")),
    div(id= "form",actionButton("reset_star", "Zdejmij gwiazdke"))
  ),
  d3Output("d3")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    observeEvent(input$reset_bom, {
      shinyjs::reset("form")})
    
    observeEvent(input$reset_star, {
      shinyjs::reset("form")})
    
    r2d3(data.frame(col_bom1 = input[["col_bom1"]],
                    col_chain = input[["col_chain"]],
                    col_star = input[["col_star"]]), 
    script = "choinka.js"
    )
  })
}

shinyApp(ui = ui, server = server)
