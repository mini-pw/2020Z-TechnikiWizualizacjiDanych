library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(dplyr)
df <- read.csv("Cristiano_Ronaldo.csv")
colnames(df) <- c("Season","Games","Goals")

# Define UI for application that draws a histogram
ui <- fluidPage(
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
    ),

    # Application title
    titlePanel("Christiano Ronaldo - statystyki
               (kliknij na słupki na wykresie)"),

    # Sidebar with a slider input for number of bins 
    fluidRow(
        column(2,
                   sliderInput("red",
                               "Wybierz ilość czerwonego:",
                               min = 0,
                               max = 255,
                               value = 30),
                   sliderInput("green",
                               "Wybierz ilość zielonego:",
                               min = 0,
                               max = 255,
                               value = 50),
                   sliderInput("blue",
                               "Wybierz ilość niebieskiego:",
                               min = 0,
                               max = 255,
                               value = 90)
               ),
               column(8,
                      plotlyOutput("ronaldo"),
               ),
               column(2,
                      tags$div(class="counter-box",
                               htmlOutput("ilosc_gier", class = "counter", container = tags$p),
                               tags$h2(class = "fade-text" ,"Tyle gier rozegrał Ronaldo w danym sezonie")
                      )
                      ),
        tags$script(type="text/javascript", src ="counter.js"),
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$ronaldo <- renderPlotly({
        high_colour <- rgb(input$red,input$green,input$blue,maxColorValue=255)
        diff <- (c(255,255,255) - c(input$red,input$green,input$blue)) * 0.75
        low_vector <- c(input$red,input$green,input$blue) + diff
        low_colour <- rgb(low_vector[1],low_vector[2],low_vector[3],maxColorValue = 255)
        # generate bins based on input$bins from ui.R
        p <- ggplot(df,aes(x = Season, y = Goals, fill = Goals)) +
            geom_bar(stat = "identity") +
            scale_fill_continuous(high = high_colour, low = low_colour)+
            theme(axis.text.x = element_text(angle = 45, hjust = 1))
        ggplotly(p,source = "subset")
    })

    sezon <- reactiveValues(
        selected = as.integer()
    )
    
    observeEvent(event_data("plotly_click", source = "subset"), {
        sezon[["selected"]] <- event_data("plotly_click", source = "subset")[3]
    })
    
    output$ilosc_gier <- renderText({
        sezon_current <- as.integer(sezon[["selected"]])
        as.integer(df[sezon_current,"Games"])
        })
    
}

# Run the application 
shinyApp(ui = ui, server = server)
