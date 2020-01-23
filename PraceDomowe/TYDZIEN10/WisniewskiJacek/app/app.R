library(shiny)
library(tidyverse)
library(plotly)
library(ggthemes)

#setwd("C:/Users/jwisn/OneDrive/Dokumenty/2020Z-TechnikiWizualizacjiDanych/PraceDomowe/TYDZIEN10/WisniewskiJacek/app")
load("dragons.rda")

ui <- fluidPage(

    # Application title
    titlePanel("Dragons"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            img(src="https://i1.wp.com/mobirank.pl/wp-content/uploads/2019/07/hungry-dragon-gra-mobilna-ubisoft.jpg?resize=680%2C406&ssl=1", 
                align = "left", height = "200px", width = "300px"),
            
            checkboxGroupInput("colours", label = "Choose colours of dragons", choices = c("black", "red", "green", "blue"), selected = c("black", "red", "green", "blue")),
            
            sliderInput("slider", "Choose dragons year of birth", min = -1999, max = 1800, value = c(-1999, 1800))
            
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlotly({
        dragons <- dragons %>% filter(colour %in% input$colours) %>%
            filter(year_of_birth >= input$slider[1]) %>%
            filter(year_of_birth <= input$slider[2])
        ggplot(dragons, aes(x = weight, y = height, color = colour)) +
            geom_point() +
            #scale_color_manual(values = c("green" = "#31a354", "red" = "#de2d26", "blue" = "#2b8cbe", "black" = "#000000"))
            scale_color_identity() +
            theme_minimal()
        
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
