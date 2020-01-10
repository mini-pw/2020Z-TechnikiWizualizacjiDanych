library(r2d3)
library(shiny)
library(reshape2)
library(dplyr)

ui <- fluidPage(

    titlePanel("Lok Sabha general elections turnout by sex"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Choose Lok Sabha's terms of office you are interested in:",
                        min = 3,
                        max = 17,
                        value = c(3, 17)),
            checkboxGroupInput("checkGroup", 
                               h3("Choose sex:"), 
                               choices = list("Female" = "woman", 
                                              "Male" = "man"),
                               selected = c("man", "woman"))
        ),

        mainPanel(
          d3Output("d3")
        )
    )
)

server <- function(input, output) {
  
  dataToPlot <- melt(read.csv("data.csv"), id.vars = c("lok_sabha", "year", "term"))
  dataToPlot <-  dataToPlot %>%
    mutate(color = ifelse(dataToPlot[["variable"]] == 'man', "#FA9E31", "#148606"))
  dataToPlot <- dataToPlot[complete.cases(dataToPlot),]
  dataToPlot <- dataToPlot[order(dataToPlot[["year"]]),]
  
  output[["d3"]] <- renderD3({
    r2d3(dataToPlot[(2*(input[["bins"]][1]-2)-1):(2*(input[["bins"]][2]-2)),]%>%
           filter(variable %in% input[["checkGroup"]]), 
         script = "lok_sabhas.js"
    )
  })
}

shinyApp(ui = ui, server = server)
