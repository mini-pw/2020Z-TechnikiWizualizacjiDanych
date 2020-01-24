library(shiny)
library(r2d3)
library(colourpicker)

ui <- fluidPage(
  titlePanel("People give a variety of reasons for eating less meat"),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "category", label = "Choose group of people", 
        choices = c("People interested in cutting down meat consumption", "Non-meat eaters")),
      colourInput(
        inputId = "colour",label = "Choose colour", value = "blue"),
      checkboxInput(
        inputId = "percentage", label = "Show percentage", value = FALSE, width = "50px")
    ),
    mainPanel(
      d3Output("d3")
    )
    )
  )

server <- function(input,output){
  
  # Wczytanie danych
  data <- read.csv("dane.csv", sep = ";")
  
  labelWithPercent <- data.frame()
  for (i in 1:dim(data)[1]){
    labelWithPercent[i,1] <- paste(data[i,1]," ",data[i,2],"%")
    labelWithPercent[i,2] <- paste(data[i,1]," ",data[i,3], "%")
  }
  
  observeEvent(c(input$percentage, input$category), {
    
    if(input[["percentage"]]){
      if(input[["category"]] == "People interested in cutting down meat consumption"){
        data[,1] <- labelWithPercent[1]
      }else{
        data[,1] <- labelWithPercent[2]
      }
    }
  output[["d3"]] <- renderD3({
    
    if(input[["category"]] == "People interested in cutting down meat consumption"){
      result <- data[, c(1,2)]
      colnames(result) <- c("Group", "Value")
    }else{
      result <- data[, c(1,3)]
      colnames(result) <- c("Group", "Value")
    }

    col <- rep(input[["colour"]], 6)
    result <- cbind(result, col)
    colnames(result) <- c("Group", "Value", "col")
    r2d3(result, script = "PD_8.js")
  })
  })

}

shinyApp(ui = ui, server = server)