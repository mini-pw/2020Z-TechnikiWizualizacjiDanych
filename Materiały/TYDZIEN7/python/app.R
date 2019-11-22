library(SmarterPoland)
library(shiny)
library(ggplot2)
library(ggstance)
library(plotly)
library(shinythemes)

ui <- fluidPage(title = "Aplikacja python",
                theme = shinytheme("cyborg"),
                sidebarPanel(selectInput(inputId = "x_select", label = "Wybierz os x", 
                                         choices = colnames(countries), selected = "birth.rate"),
                             selectInput(inputId = "y_select", label = "Wybierz os y", 
                                         choices = colnames(countries), selected = "death.rate"),
                             selectInput(inputId = "cf_select", label = "Wybierz kolor", 
                                         choices = colnames(countries), selected = "continent")),
                mainPanel(
                  tabsetPanel(
                    tabPanel("ggplot2", 
                             plotOutput(outputId = "countries_plot", hover = "countries_hover"),
                             verbatimTextOutput(outputId = "hover_result")),
                    tabPanel("plotly", plotlyOutput(outputId = "countries_plotly"))))
)

server <- function(input, output) {
  
  
  countries_plot_data <- reactive({
    chosen_geom <- if(is.character(countries[[input[["x_select"]]]])) {
      geom_boxplot()
    } else {
      if(is.character(countries[[input[["y_select"]]]])) {
        geom_boxploth()
      } else {
        geom_point()
      }
    }
    
    #chosen_coords <- if()
    
    ggplot(countries, aes_string(x = input[["x_select"]], y = input[["y_select"]], 
                                 color = input[["cf_select"]])) +
      chosen_geom +
      theme_bw() +
      theme(legend.position = "bottom")
  })
  
  output[["countries_plot"]] <- renderPlot({
    countries_plot_data()
  })
  
  output[["hover_result"]] <- renderPrint({
    nearPoints(countries, input[["countries_hover"]])
  })
  
  output[["countries_plotly"]] <- renderPlotly({
    ggplotly(countries_plot_data())
  })
  
}

shinyApp(ui = ui, server = server)
