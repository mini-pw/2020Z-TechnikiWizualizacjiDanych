library(shiny)
library(ggplot2)
library(dplyr)

ui <- fluidPage(
   titlePanel("Smoki"),
   
   sidebarLayout(
      sidebarPanel(
         sliderInput("size",
                     "Size of sample(%):",
                     min = 1,
                     max = 100,
                     value = 100),
         checkboxInput("trendLine",
                       "Linia trendu",
                       value = TRUE),
         selectInput("yZmienna",
                     "Na osi y:",
                     choices = c("year_of_birth",
                                 "height",
                                 "weight",
                                 "scars",
                                 "colour",
                                 "year_of_discovery",
                                 "number_of_lost_teeth",
                                 "life_length")),
         selectInput("xZmienna",
                     "Na osi x:",
                     choices = c("year_of_birth",
                                 "year_of_discovery",
                                 "life_length"))
      ),
      
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

server <- function(input, output) {
   
   output$distPlot <- renderPlot({
      n <- dim(dragons)[1]
      wiersze <- sample(n, size = input$size*n/100)
     
      
      data <- dragons[sort(wiersze),c(input$xZmienna, input$yZmienna)]
      colnames(data) <- c("xZmienna", "yZmienna")
      
      if(input$trendLine){
        ggplot(data, aes(x=xZmienna, y=yZmienna)) +
          geom_point() +
          geom_smooth(method = "lm") +
          xlab(input$xZmienna) +
          ylab(input$yZmienna)
      }else{
        ggplot(data, aes(x=xZmienna, y=yZmienna)) +
          geom_point() +
          xlab(input$xZmienna) +
          ylab(input$yZmienna)
      }
      
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

