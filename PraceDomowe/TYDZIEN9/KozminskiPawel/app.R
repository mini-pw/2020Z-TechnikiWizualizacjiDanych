#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(r2d3)
library(shiny)
library(reshape2)
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Lok Sabha general elections turnout by sex"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Choose Lok Sabhas you are interested in:",
                        min = 3,
                        max = 17,
                        value = c(3, 17)),
            checkboxGroupInput("checkGroup", 
                               h3("Choose sex:"), 
                               choices = list("Female" = "woman", 
                                              "Male" = "man"),
                               selected = c("man", "woman"))
        ),

        # Show a plot of the generated distribution
        mainPanel(
          d3Output("d3")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  dataToPlot <- melt(read.csv("data.csv"), id.vars = c("lok_sabha", "year"))
  dataToPlot <-  dataToPlot %>%
    mutate(color = ifelse(dataToPlot[["variable"]] == 'man', "steelblue", "green"))
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
