library(shiny)
library(r2d3)
library(dplyr)
library(ggplot2)
library(miceadds)

dragons <- miceadds::load.Rdata2("dragons.rda")

ui <- fluidPage(

    titlePanel("Dragons mine"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout( position = "left",
        sidebarPanel(
            
            sliderInput("d_birth",
                        "Year of birth:",
                        min = -1999,
                        max = 1800,
                        value = c(-1999,1800)),
            
            sliderInput("d_life",
                        "Minimial lenght of life:",
                        min = 511,
                        max = 3952,
                        value = 511),
            
            checkboxInput("many_scars",
                        "Has many scars (50+):"),
            
            checkboxInput("many_lost_teeth",
                        "Has many number of teeth lost (30+):"),
            
            checkboxGroupInput("d_colors", "Color of dragon:",
                               choices =  c("black" = "black",
                                 "blue" = "blue",
                                 "green" = "green",
                                 "red" = "red"),
                               selected = c("black", "blue", "green", "red"))
            
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("dragonPlot"),
           tableOutput('table')
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    #not working
    #dragons <- readRDS( file ="dragons.rda")
    
    dragons_df_r <- reactive({
         dragons %>%
            filter( year_of_birth >= input$d_birth[1]) %>%
            filter( year_of_birth <= input$d_birth[2]) %>%
            filter( life_length >= input$d_life) %>%
            filter(if (input$many_scars) scars > 49 else scars >-1) %>%
            filter(if (input$many_lost_teeth) number_of_lost_teeth > 29 else number_of_lost_teeth >-1) %>%
            filter( colour %in% input$d_colors)
    })
    
    output$dragonPlot <- renderPlot({
        ggplot( dragons_df_r(), aes( x = height, y = weight, color = colour))+
            geom_point()
    })
    
    output$table <- renderTable( dragons_df_r())
    
    
}

shinyApp(ui = ui, server = server)
