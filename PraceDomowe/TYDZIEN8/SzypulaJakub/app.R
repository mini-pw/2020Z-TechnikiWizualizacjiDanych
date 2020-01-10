library(shiny)
library(shinyjs)
library(r2d3)


trojkaty <- function(n) {
  punkty <- "220,380 380,380"
  x <- 380
  y <- 380
  for (i in 1:n) {
    x <- x - 180
    y <- y - 340/n
    punkty <- paste(punkty, paste(x, y, sep=","), collapse="", sep =" ")
    if(i < n) {
      x <- x + 180
      punkty <- paste(punkty, paste(x, y, sep=","), collapse="", sep =" ")
    }
  }
  for (i in 1:n) {
    x <- x - 180
    y <- y + 340/n
    punkty <- paste(punkty, paste(x, y, sep=","), collapse="", sep =" ")
    if(i < n) {
      x <- x + 180
      punkty <- paste(punkty, paste(x, y, sep=","), collapse="", sep =" ")
    }
  }
  
  return(punkty)
}

ui <- fluidPage(
  useShinyjs(),
  
  sidebarPanel(title = "Ho ho ho",
               p("Choinka po wybraniu ustawień wymaga kliknięcia przycisku, żeby zmienić wygląd."),
               div(id = "prezentyChbx",              
                checkboxInput("prezentyI", "Prezenty?", value = FALSE)
               ),
                
               
               selectInput("bombkiKolor", label = "Kolor bombek", 
                           choices = c("czerwony" = "#FF0000", 
                                       "żółty" = "#FFD800",
                                       "niebieski" = "#0026FF",
                                       "fioletowy" = "#57007F",
                                       "jasnozielony" = "#4CFF00")),
               
               sliderInput("krokiChoinki", label = "Ilość trójkątów: ",
                           min = 1, max = 10, value =5 , step = 1),
               textInput("tekst", "Życzenia świąteczna", value = "Najlepszego!", width = NULL, placeholder = NULL),
               
               div(id= "form",
                   actionButton("Reset", "Reset choinki")
               )
  ),
  mainPanel(d3Output("d3"))
)


server <- function(input, output) {
  observeEvent(input$Reset, {
    shinyjs::reset("form")})
  
  set.seed(69)
  
  output[["d3"]] <- renderD3({
    r2d3(data = data.frame(punkty=trojkaty(input[["krokiChoinki"]]), 
                           prezenty=input[["prezentyI"]],
                           tekst = input[["tekst"]], 
                           bombkiY = seq(40+170/input[["krokiChoinki"]], 380-170/input[["krokiChoinki"]], 340/input[["krokiChoinki"]]),
                           bombkiX = rep(200, input[["krokiChoinki"]]),
                           bombkiKolor =  input[["bombkiKolor"]]),
         
         script = "choinka.js"
    )
  })
}

shinyApp(ui = ui, server = server)
