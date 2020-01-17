library(shiny)
library(dplyr)
library(ggplot2)
library(colourpicker)
library(stringi)

data <- read.csv("anomalies.csv")
data %>%
    mutate(Year = as.character(Year)) %>%
    mutate(IsWarmer = Value > 0) -> data

labeling <- function(x){
    
    x[ stri_sub(x, -2, -1) != "06" ] <- ""
    x[ stri_sub(x, -2, -1) == "06" ] <- stri_sub( x[ stri_sub(x, -2, -1) == "06" ], 1, 4)
    
    return(x)
}

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Odchylenie średniej temperatury w miesiącu w porównaniu ze średnią temperaturą w XX wieku - na podstawie pracy E. Jowik"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("slider",
                        label = "Lata:",
                        min = 1880,
                        max = 2019,
                        value = c(1970, 2000)),
            colourInput("c1", "Wybierz kolor 1", value = "red"),
            colourInput("c2", "Wybierz kolor 2", value = "blue")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("plot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    reactive_plot <- reactive({
        minValue <- as.character(input$slider[1])
        maxValue <- as.character(input$slider[2]+1)
    
        data %>%
            filter(Year > minValue) %>%
            filter(Year < maxValue) -> data
        
        ggplot(data, aes(x = Year, y = Value, fill = IsWarmer)) +
            geom_bar(stat = "identity") +
            scale_fill_manual(values = c(input$c2, input$c1)) +
            scale_x_discrete(labels = labeling(data[["Year"]]))
        
        
    })
    
    output$plot <- renderPlot({
        reactive_plot()
    })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
