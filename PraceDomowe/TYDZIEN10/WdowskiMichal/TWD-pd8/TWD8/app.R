library(shiny)
library(r2d3)
library(dplyr)
library(ggplot2)
load(file = "dragons.rda")

normalize <- function(x) {
    return ((x - min(x)) / (max(x) - min(x)))
}

ui <- fluidPage(
    
    titlePanel("Dragons' information overview"),
    
    sidebarLayout(
        sidebarPanel(
            checkboxInput(inputId = "check", label = "Do you want to group by colors?"),
            radioButtons(inputId = "xAxis", label = "Choose data to X Axis:",
                         choices = c("Year of birth" = "year_of_birth",
                                     "Height" = "height",
                                     "Weight" = "weight",
                                     "Scars" = "scars",
                                     "Year of discovery" = "year_of_discovery",
                                     "Number of lost teeth" = "number_of_lost_teeth",
                                     "Life length" = "life_length"),
                         selected = "height"
            ),
            radioButtons(inputId = "yAxis", label = "Choose data to Y Axis:",
                         choices = c("Year of birth" = "year_of_birth",
                                     "Height" = "height",
                                     "Weight" = "weight",
                                     "Scars" = "scars",
                                     "Year of discovery" = "year_of_discovery",
                                     "Number of lost teeth" = "number_of_lost_teeth",
                                     "Life length" = "life_length"),
                         selected = "weight"
            ),
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plot"),
            textOutput("text")
        )
    )
)

server <- function(input, output) {
    a <- reactive({
        
        plot <- ggplot(dragons, aes_string(x = input$xAxis, y = input$yAxis, colour = "colour")) +
            geom_point() +
            scale_colour_manual(values = c("black", "blue", "green", "red"))
        
        if(input$check == TRUE){
            plot <- plot + facet_wrap(~colour)
        }
        
        plot
        
    })
    
    output$plot <- renderPlot({ a() })
    
    output$text <- renderText({
        paste(input$xAxis, input$yAxis)
    })
}

shinyApp(ui = ui, server = server)
