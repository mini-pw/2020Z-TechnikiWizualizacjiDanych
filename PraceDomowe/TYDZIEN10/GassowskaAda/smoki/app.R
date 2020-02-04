#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(r2d3)
library(dplyr)
library(ggplot2)

data <- miceadds::load.Rdata2("dragons.rda")
data$era <- ifelse(data$year_of_birth<0, "Before the Common Era", "Common Era")

# Define UI for application that draws a histogra
ui <- navbarPage(
  "Dragons",
  tabPanel("How many dragons have each number of scars",
           title = "Histogram of number of scars?",
           sidebarLayout(
             sidebarPanel(
               checkboxGroupInput(inputId="birth",label="Show dragons born in : ",
                                  choices = c("Before the Common Era", "Common Era"),
                                  selected=c("Before the Common Era", "Common Era")
               )
             ),
             mainPanel(
               d3Output("d3", height = "900px", width = "1200px")
             )
           )
  ),
  tabPanel("Correlation between height and weight",
           title="Correlation between height and weight",
           sidebarLayout(
             sidebarPanel(
               checkboxGroupInput(inputId="color",label="Dragons of which color do you want to analyse?",
                                  choices = c("black","blue", "green", "red"),
                                  selected=c("black","blue", "green", "red")
               ),checkboxInput(inputId="facet", label="Do you want to see them on separate plots?"),
               checkboxInput(inputId = "trendline", label="Do you want to add a trend line?"),
               sliderInput(inputId="age", label="Dragons of what dying age you want to analyse?",
                           min=511, max=3953, value=c(511,3953))
             ),
             mainPanel(
               plotOutput("plot", height="800px", width="1000px")
             )
           )
  )
)

server <- function(input, output, session) {
  output$plot <- renderPlot({
    
    p <- data%>%filter(colour %in% input[["color"]])%>%filter(life_length>input$age[1] & life_length<input$age[2])%>%
      ggplot(aes(x=height,y=weight,color=colour))+geom_point()+scale_color_manual(values = input[["color"]])
    if(input[["facet"]]==TRUE){
      p <- p + facet_wrap(~colour)}
    if(input[["trendline"]]==TRUE){
      p <- p + geom_smooth(color="yellow")
    }
    p
    
  })
  
  output[["d3"]] <- renderD3({
    r2d3(data.frame(data%>%
           filter(era %in% input[["birth"]]) %>% group_by(scars) %>% count()),
         script = "script.js"
    )
  })
  
}

shinyApp(ui = ui, server = server)
