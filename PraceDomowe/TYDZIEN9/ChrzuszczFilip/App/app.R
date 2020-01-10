library(shiny)
library(ggplot2)
library(tidyverse)
library(shinythemes)
library(plotly)
library(colourpicker)
ui <- fluidPage(
  
  # Application title
  titlePanel("Marka pojazdu a kwota OC"),
  
  # Sidebar with two colour panels and one checkbox
  sidebarLayout(
    sidebarPanel(
      colourInput("barColour1",
                  label = "Wybierz kolor 2019",
                  value = "black"),
      colourInput("barColour2",
                  label = "Wybierz kolor 2018",
                  value = "red"),
      checkboxInput('rok', 'Pokaż tylko 2019', value = FALSE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotlyOutput("distPlot"),width=12
      
      
    )
  ),
  # Set theme
  theme = shinytheme("superhero")
)
data <- read.csv('dane.csv')
# Define server logic required to draw a histogram
server <- function(input, output) {

  
  output$distPlot <- renderPlotly({
    if(input$rok){
      data <- data[data$rok=="OC_2019",]
      p <- ggplot(
        data,
        aes(x = reorder(marka, OC), weight = OC,fill=input$barColour1)) +
        theme_minimal() +
        geom_bar(
          fill=input$barColour1,
          position = position_dodge(width = 0.8),
          width = 0.6)+
        coord_cartesian(
          ylim = c(530, 980)) +
        theme(
          axis.text = element_text(size = 16,angle=45),
          plot.title = element_text(
            size = 24,
            hjust = 0.5,
            margin = margin(t = 0, r = 0, l = 0, b = 20)),
          legend.position = 'none' )+
        labs(x = "", y = "", fill = "")
      
      
    }
    else{
    p <- ggplot(
      data,
      aes(x = reorder(marka, OC), weight = OC, fill = rok)) +
      theme_minimal() +
      scale_fill_manual(
        values = c(input$barColour2,input$barColour1),
        labels = c("OC w III kwartale 2018 r", "OC w III kwartale 2019 r")) +
      geom_bar(
        position = position_dodge(width = 0.8),
        width = 0.6) +
      coord_cartesian(
        ylim = c(530, 980)) +
      geom_text(
        aes(label = OC, x = marka, y = OC),
        vjust=-1,
        color=rep(c(input$barColour2,input$barColour1), times=11),
        size=5.5,
        position = position_dodge(width = 0.8))+
      theme(
        axis.text = element_text(size = 16,angle=45),
        
        plot.title = element_text(
          size = 24,
          hjust = 0.5,
          margin = margin(t = 0, r = 0, l = 0, b = 20)),
        legend.position = "bottom",
        legend.box = "horizontal",
        legend.justification = "center",
        legend.text = element_text(size=12),
        axis.text.y = element_blank()) +
      labs(x = "", y = "", fill = "")
    }
    ggplotly(p)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
