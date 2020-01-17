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
library(shinythemes)

ui <- fluidPage(
  # Styl z shiny themes
  theme = shinytheme("united"),
  title = "Wybory w Indiach",
  
  # Tytuł
  titlePanel(h1("Frekwencja wyborcza Lok Sabha z podziałem na płeć",align="center")),
  
  # Wykres
  d3Output("d3js",height = "600px"),
  
  # Kontrolki
  fluidRow(
    
    column(5,offset = 2,
           h4("Wybierz zakres wyborów Lok Sabha"),
           sliderInput("bins","",
                       min = 3,
                       max = 17,
                       value = c(3, 17))
           ),
    column(5,
           radioButtons("btns", 
                        h3("Wybierz płeć:",align="center"), 
                        choices = list("Kobiety" = "woman", 
                                       "Mężczyźni" = "man",
                                       "Przewaga w p.p mężczyzn " = "diff"))
           )
  )
  
)

server <- function(input, output) {
  
  plotData <- read.csv("data.csv")
  
  plotData <- plotData%>%
    mutate(diff=round(man-woman,1))%>%
    melt(id.vars = c("lok_sabha", "year"),na.rm = TRUE)
  
  plotData <- plotData%>%
    mutate(color = ifelse(plotData[["variable"]] == 'man',"#1f5bab",
                          ifelse(plotData[["variable"]] == 'woman', "#ab15a4",
                                 "#9268cc")))
  
  plotData <- plotData[order(plotData[["year"]]),]
  
  output[["d3js"]] <- renderD3({
    r2d3(plotData%>%
           filter(variable %in% input[["btns"]])%>%
           slice(((input[["bins"]][1]-2)):((input[["bins"]][2]-2))), 
         script = "script.js"
    )
  })
}

shinyApp(ui = ui, server = server)