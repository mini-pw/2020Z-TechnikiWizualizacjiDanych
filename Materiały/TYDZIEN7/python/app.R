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
                                         choices = colnames(countries), selected = "continent"),
                             includeMarkdown("readme.md"),
                             uiOutput("selectors")),
                mainPanel(
                  tabsetPanel(
                    tabPanel("ggplot2", 
                             plotOutput(outputId = "countries_plot", hover = "countries_hover"),
                             verbatimTextOutput(outputId = "hover_result")),
                    tabPanel("plotly", plotlyOutput(outputId = "countries_plotly"))))
)

server <- function(input, output) {
  
  
  countries_plot_data <- reactive({
    p <- ggplot(countries, aes_string(x = input[["x_select"]], y = input[["y_select"]], 
                                      color = input[["cf_select"]]))
    
    chosen_geom <- if(is.character(countries[[input[["x_select"]]]])) {
      p + geom_boxplot() +
        scale_x_discrete(limits = input[["x_selector"]])
    } else {
      if(is.character(countries[[input[["y_select"]]]])) {
        p + geom_boxploth()
      } else {
        p + geom_point() +
          scale_x_continuous(limits = input[["x_selector"]])
      }
    }
    
    #chosen_coords <- if()
    
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
  
  output[["selectors"]] <- renderUI({
    x_data <- countries[[input[["x_select"]]]]
    selector_x <- if(is.character(x_data)) {
      checkboxGroupInput(inputId = "x_selector", label = "Checbox", 
                         choices = sort(unique(x_data)), 
                         selected = sort(unique(x_data)))
    } else {
      sliderInput(inputId = "x_selector", label = "Slider", min = min(x_data, na.rm = TRUE),
                  max = max(x_data, na.rm = TRUE), 
                  value = range(x_data, na.rm = TRUE))
    }
    
    selector_x
  })
  
}

shinyApp(ui = ui, server = server)
