library(shiny)
library(tidyverse)
library(plotly)
library(shinythemes)

load("./dragons.rda")


ui <- fluidPage(theme = shinytheme("flatly"),

    titlePanel("Dragons!"),

    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "x", 
                        label = "Select X variable:", 
                        choices = colnames(dragons), 
                        selected = "weight",
                        multiple = FALSE), 
            
            selectInput(inputId = "y",
                        label = "Select Y variable:", 
                        choices = colnames(dragons),
                        selected = "height",
                        multiple = FALSE)
        ),
        mainPanel(
           plotlyOutput("plot")
        )
    )
)

server <- function(input, output, session) {

    output$plot <- renderPlotly({
        
        updateSelectInput(
            session = session,
            inputId = "x",
            selected = input$x,
            choices = colnames(dragons)
        )
        
        updateSelectInput(
            session = session,
            inputId = "y",
            selected = input$y,
            choices = colnames(dragons)
        )
        
        p <- ggplot(dragons, aes(x = dragons[[input$x]], y = dragons[[input$y]], color = dragons$colour)) + 
            geom_point() +
            xlab(input$x) +
            ylab(input$y) + 
            theme_minimal() + 
            scale_color_manual(values = c("black", "blue", "green", "red")) + 
            theme(legend.position = "none")
        
        ggplotly(p)
    })
}

shinyApp(ui = ui, server = server)
