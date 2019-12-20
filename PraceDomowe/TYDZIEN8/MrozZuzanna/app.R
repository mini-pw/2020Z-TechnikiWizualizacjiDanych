library(shiny)
library(r2d3)

ui <- fluidPage(
  inputPanel(
    #kolory bombek
    selectInput("col_bom1", label = "Kolor zakładanych bombek:", choices = c("red","pink","magenta","purple" ,"white","lime", "cyan", "blue", "black","orange", "yellow")),
    #kolor łańcuchów
    selectInput("col_chain", label = "Kolor zakładanego łańcucha:", choices = c("red","pink","magenta","purple" ,"white","lime", "cyan", "blue", "black","orange", "yellow")),
    #kolor gwiazdki
    selectInput("col_star", label = "Kolor zakładanej gwiazdki:", choices = c("red","pink","magenta","purple" ,"white","lime", "cyan", "blue", "black","orange", "yellow")),
    
    div(id= "form",actionButton("add_bom", "Załóż bombki")),
    div(id= "form",actionButton("add_chain", "Załóż łańcuch")),
    div(id= "form",actionButton("add_star", "Załóż gwiazdke")),
    
    div(id= "form",actionButton("reset_bom", "Zdejmij bombki")),
    div(id= "form",actionButton("reset_chain", "Zdejmij łańcuch")),
    div(id= "form",actionButton("reset_star", "Zdejmij gwiazdke"))

    
  ),
  d3Output("d3")
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    observeEvent(input$add_bom, {shinyjs::reset("form")})
    observeEvent(input$add_chain, {shinyjs::reset("form")})
    observeEvent(input$add_star, {shinyjs::reset("form")})
    
    observeEvent(input$reset_bom, {shinyjs::reset("form")})
    observeEvent(input$reset_chain, {shinyjs::reset("form")})
    observeEvent(input$reset_star, {shinyjs::reset("form")})
    
    r2d3(data.frame(col_bom1 = input[["col_bom1"]],
                    col_chain = input[["col_chain"]],
                    col_star = input[["col_star"]]), 
    script = "choinka.js"
    )
  })
}

shinyApp(ui = ui, server = server)
