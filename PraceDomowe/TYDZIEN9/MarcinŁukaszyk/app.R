library(shiny)

ui <- fluidPage(

   titlePanel("Wzorst PKB Chinskiej Republiki Ludowej na przestrzeni lat"),
   
   sidebarLayout(
      sidebarPanel(
         sliderInput("year",
                     "Wybierz rok:",
                     min = 2000,
                     max = 2015,
                     value = 2005)
      ),
      
      mainPanel(
         plotOutput("distPlot")
      )
   )
)

server <- function(input, output) {
   
   output$distPlot <- renderPlot({
     time <- seq(1999,2016,1)
     val <-c(1,1.21,1.33,1.47,1.66,1.95,2.28,2.75,3.52,5.59,5.11,6.1,7.57,8.56,9.6,10.48,11.06,12)
     zeros <-replicate(18,0)
     zeros[input$year-1998] <-val[input$year-1998]
     # hist(zeros,breaks = 15, col = 'darkgray', border = 'white')
     plot(time,zeros,type = "s",ylim = c(0,15),main = "Wzrost PKB Chin ",xlab = "Rok",ylab = "PKB (bld$)")
     
   })
}

# Run the application 
shinyApp(ui = ui, server = server)

# library(rsconnect)
# rsconnect::deployApp('C:/Users/lukas/Documents/PD9/app')

