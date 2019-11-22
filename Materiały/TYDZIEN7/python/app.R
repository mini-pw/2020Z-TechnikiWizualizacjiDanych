library(SmarterPoland)
library(shiny)
library(ggplot2)
library(ggstance)

ui <- fluidPage(title = "Aplikacja python",
                plotOutput(outputId = "countries_plot"),
                selectInput(inputId = "x_select", label = "Wybierz os x", 
                            choices = colnames(countries), selected = "birth.rate"),
                selectInput(inputId = "y_select", label = "Wybierz os y", 
                            choices = colnames(countries), selected = "death.rate"),
                selectInput(inputId = "cf_select", label = "Wybierz kolor", 
                            choices = colnames(countries), selected = "continent"))

server <- function(input, output) {
  
  output[["countries_plot"]] <- renderPlot({
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
  
}

shinyApp(ui = ui, server = server)
