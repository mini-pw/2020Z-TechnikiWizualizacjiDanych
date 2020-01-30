library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(r2d3)

test <- read.csv("dane.csv")
colnames(test) <- c("V1","V2","V3","V4")


ui <- fluidPage(theme = shinytheme("superhero"),
                sidebarPanel(checkboxInput("man","Man?",value=TRUE),
                                checkboxInput("woman","Woman?",value=FALSE)),
                
                
                d3Output("d3")
)

server <- function(input, output) {
  
  output[["d3"]] <- renderD3({
    test1 <- test
    test1$V3 <- 0 
    if (input$woman){
      test1 <- test[7:12,]
      test1$V5 <- "blue"
    }
    if (input$man){
      test1 <- test[1:6,]
      test1$V5 <- "red"
      
    }

    
    r2d3(test1, script = "man.js")
  

})
}

shinyApp(ui = ui, server = server)

