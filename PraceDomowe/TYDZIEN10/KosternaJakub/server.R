library(shiny)
library(jpeg)
library(grid)
library(ggplot2)

#setwd("/home/samba/kosternaj/Desktop/05Wiz/Tydzień10")
data <- load(file = "dragons.rda")

function(input, output){
  
  dataset <- reactive({data})
  
  output$plot <- renderPlot({
    firstOne = input$first
    
    if (input$howMany == 1)
    {
      if (input$groupByColor == FALSE)
        p <- ggplot(data = dragons, aes_string(x = input$first))
      
      else
        p <- ggplot(data = dragons, aes_string(x = input$first, color = "colour"))
      
      if(input$typeOfPlot == "geom_density()")
        p <- p + geom_density()
      
      else if(input$typeOfPlot == "geom_bar()")
      {
        p <- p + geom_bar()
        if(input$first == "height" | input$first == "weight" | input$first == "life_length")
          p <- p + annotate("text", x = -Inf, y = Inf, label = "Yeah, you can find lots of information here",
                            colour = "red", size = 9, hjust = 0, vjust = 12)
      }
      
      else if(input$typeOfPlot == "geom_freqpoly()")
        p <- p + geom_freqpoly()
      
      else if(input$typeOfPlot == "geom_histogram()")
        p <- p + geom_histogram()
    }
    
    else
    {
      if (input$groupByColor == FALSE)
        p <- ggplot(data = dragons, aes_string(x = input$first, y = input$second))
      
      else
        p <- ggplot(data = dragons, aes_string(x = input$first, y = input$second, color = "colour"))
      
      if(input$typeOfPlot2 == "geom_point()")
        p <- p + geom_point()
      
      else if(input$typeOfPlot2 == "geom_col()" & input$first != input$second)
        p <- p + geom_col()
      
      else if(input$typeOfPlot2 == "geom_violin()")
      {
        p <- p + geom_violin()
      }
      
      else if(input$typeOfPlot2 == "geom_boxplot()")
      {
        p <- p + geom_boxplot()
      }
      
      else if(input$typeOfPlot2 == "geom_jitter()")
        p <- p + geom_jitter()
      
      if(input$isSmooth)
        p <- p + geom_smooth()
      
      if(input$first == input$second)
        p <- p + annotate("text", x = -Inf, y = Inf, label = "Well, it kinda doesn't make sense\nTry using one dimension ones!",
                          colour = "red", size = 9, hjust = 0, vjust = 9)
    }
    
    if(input$first == "year_of_birth")
      p <- p + xlab("Year of birth")
    if(input$first == "height")
      p <- p + xlab("Height")
    if(input$first == "weight")
      p <- p + xlab("Weight")
    if(input$first == "scars")
      p <- p + xlab("Scars")
    if(input$first == "colour")
      p <- p + xlab("Colour")
    if(input$first == "year_of_discovery")
      p <- p + xlab("Year of discovery")
    if(input$first == "number_of_lost_teeth")
      p <- p + xlab("Number of lost teeth")
    if(input$first == "life_length")
      p <- p + xlab("Life length")
    
    if(input$second == "year_of_birth")
      p <- p + ylab("Year of birth")
    if(input$second == "height")
      p <- p + ylab("Height")
    if(input$second == "weight")
      p <- p + ylab("Weight")
    if(input$second == "scars")
      p <- p + ylab("Scars")
    if(input$second == "colour")
      p <- p + ylab("Colour")
    if(input$second == "year_of_discovery")
      p <- p + ylab("Year of discovery")
    if(input$second == "number_of_lost_teeth")
      p <- p + ylab("Number of lost teeth")
    if(input$second == "life_length")
      p <- p + ylab("Life length")
    
    if(input$facetByColor)
      p <- p + facet_wrap(~colour, nrow = 2)
    
    get.xy <- function(p) {
      g_data <- ggplot_build(p)
      data.frame(xmax = max(g_data$data[[1]]$x),
                 ymax = max(g_data$data[[1]]$y),
                 xmin = min(g_data$data[[1]]$x),
                 ymin = min(g_data$data[[1]]$y))
    }
    
    print(p)
    
  }, height = 800)
}