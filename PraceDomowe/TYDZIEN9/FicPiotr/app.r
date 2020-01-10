library(shiny)
library(ggplot2)
library(r2d3)

ui <- fluidPage(
  
  titlePanel(
    fluidRow(
      column(1, ""),
      column(4,
      "Parents' driving habits"))),
  
  fluidRow(
    column(3,
    selectInput("category", label = "Choose parents group",
                  choices = c("All parents", "New parents")), offset = 0, style='padding-left:200px; padding-right:5px; padding-top:10px; padding-bottom:0px'),
    column(3,  
    selectInput("colour", label = "Choose bars' colour",
                  choices = c("red", "green", "blue")), offset = 0, style='padding-left:0px; padding-right:0px; padding-top:10px; padding-bottom:0px'),
    column(6,
    d3Output("d3"))
    )
  )

server <- function(input, output){
  #Wczytanie danych
  data <- read.csv("./data.csv")
  #Przygotowanie Labels tak aby później nie zachodziły na siebie na wykresie
  leb <- c("Slammed \n on the \n brakes",
           "Reached \n into the \n back seat",
           "Pulled over \n to calm children",
           "Gotten pulled \n over \n by police",
           "Drifted from \n my lane",
           "Ran over a \n curb",
           "Missed a \n red light",
           "Spilled a \n hot drink",
           "Gotten into \n a fender \n bender",
           "Lost memory \n of driving",
           "Closed my \n eyes while \n driving",
           "Hit a \n parked car")
  leb <- gsub(" ", " ", leb)
  
  data[,1] <- leb
  
  
output[["d3"]] <- renderD3({
    if(input[["category"]] == "All parents"){
      dataPlot <- data[, c(1,2)]
      colnames(dataPlot) <- c("Question", "Value")
    }else{
      dataPlot <- data[, c(1,3)]
      colnames(dataPlot) <- c("Question", "Value")
    }
    
    col <- rep(input[["colour"]], 12)
    dataPlot <- cbind(dataPlot, col)
    colnames(dataPlot) <- c("Question", "Value", "col")
    r2d3(dataPlot, script = "skrypt.js")
  })
  }
  

shinyApp(ui, server)