library(shiny)
library(shinyjs)
library(r2d3)
library(shinythemes)

globalRunif <- function(n,min,max){
  set.seed(69)
  x <- runif(n,min,max)
  return(x)
}

chainPosition <- function(n){
  
  x <- seq(from = 100, to= 400, length.out = 100)
  y <- 0.001 * x**2 + 0.001*x + 250
  
  return(c(x,y))
}


stworzBombki <- function(y){
x <- rep(0, 2* round(length(y)/2))
  for (i in 1:length(x)){
    x[i] <- runif(1,round(250-25/33*y[i]),round(250+25/33*y[i]))
}
  return(x)
}

ui <- fluidPage(
                useShinyjs(),
                theme = shinytheme("cyborg"),
                
  sidebarPanel(title = "Aplikacja python",
    selectInput("bar_col", label = "Kolor bombek", 
                choices = c("red", "white", "blue", "black", "orange", "yellow", "purple")),
  
    sliderInput("bombki", label = "Ilość bombek: ",
                min = 2, max = 200, value =0 , step = 2),
    
    div(id= "form",
    actionButton("Resetbombki", "Zresetuj bombki")
    )
  ),
  mainPanel(d3Output("d3"))
)

server <- function(input, output) {
  observeEvent(input$Resetbombki, {
    shinyjs::reset("form")})
  
  set.seed(69)
  
  output[["d3"]] <- renderD3({
  r2d3(data.frame(  bombkix = stworzBombki(globalRunif(input[["bombki"]],20,350)),
                    bombkiy = globalRunif(input[["bombki"]],20,350),
                    col =  rep(input[["bar_col"]],input[["bombki"]])),
                    
       
         script = "ch.js"
    )
  })
}

shinyApp(ui = ui, server = server)