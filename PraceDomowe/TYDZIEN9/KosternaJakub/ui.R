library(shiny)
library(ggplot2)

data <- data.frame(names = rev(c("1. Makati City", "2. Quezon City",
                                 "3. City of Manila", "4. Pasig City", "5. Cebu province", "6. Cebu City",
                                 "7. Taguig City", "8. Compostela Valley", "9. Caloocan City", "10. Pasay City")),
                   values = rev(c(230833, 87285, 40711, 38985, 35659, 33884, 24535, 19615, 18381, 18278)))

fluidPage(
  titlePanel("Top 10 richest LGUs in the Philippines"),
  
  sidebarPanel(
    checkboxInput('doWeManipulate', 'Want to manipulate x-axis?'),
    
    conditionalPanel(
      
      condition = "input.doWeManipulate == true",   
      sliderInput('levelOfManipulation', '... in 1-10 scale, how much?',
                  min = 0, max = 10, value = 3, step = 1),
      
      conditionalPanel(
        condition = "input.levelOfManipulation == 0",
        helpText("But you said you wanna!")
      ),
      
      conditionalPanel(
        condition = "input.levelOfManipulation > 8",
        helpText("Now the plot is manipulated like hell ;O")
      )
    ),
    
    selectInput('color', 'Bar color', c("brown", "red", "blue", "black")),
    
    checkboxInput('showMap', 'Showmap', value = TRUE)
    
  ),
  
  mainPanel(
    plotOutput('plot')
  )
)