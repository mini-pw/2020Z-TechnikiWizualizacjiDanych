library(shiny)
library(jpeg)
library(grid)
library(ggplot2)

function(input, output){
  dataset <- reactive({
    
    data.frame(names = rev(c("1. Makati City", "2. Quezon City",
                                        "3. City of Manila", "4. Pasig City", "5. Cebu province", "6. Cebu City",
                                        "7. Taguig City", "8. Compostela Valley", "9. Caloocan City", "10. Pasay City")),
                          values = rev(c(230833, 87285, 40711, 38985, 35659, 33884, 24535, 19615, 18381, 18278)))
  })
  
  output$plot <- renderPlot({
    options(scipen = 10000) # for "pretty"" x axis numbers
    
    if(input$doWeManipulate) # change length of bars if decided to manipulate
      data$values <- data$values + 10000 * input$levelOfManipulation
    
    p <- ggplot(data, aes(x = names, y = values, width = .5)) # width - between the bars
    
    if (input$showMap) # showing map if user wants it
    {
      background <- readJPEG('philippinesMap.jpg') # from file
      g <- rasterGrob(background, width = unit(1, "npc"), height = unit(1, "npc"))
      p <- p + annotation_custom(g, -Inf, Inf, -Inf, Inf) # loading the background
    }
    
    p <- p + ylab("Billions of philippine pesos in revenue (2018)") # ... x-axis name
    
    p <- p + geom_col(fill = input$color) # add columns and color them
    
    if(input$doWeManipulate == FALSE) # standard plot full of truth
      p <- p + scale_y_continuous(limits = c(0, 300000),
                         breaks = seq(0, 300000, 50000),
                         position = "left") + # x comparments
                geom_text(aes(label = data$values), # numbers next to bars
                position = position_nudge(y = 5),
                hjust = -0.15,
                size = 6,
                color = "#545454")
        
    else
    {
      if(input$levelOfManipulation < 5) # depending on the level of manipulation, different y scale
        p <- p + scale_y_continuous(limits = c(0, 350000),
                                    breaks = seq(0, 350000, 50000),
                                    position = "left") # x comparments
      
      else
        p <- p + scale_y_continuous(limits = c(0, 400000),
                                    breaks = seq(0, 400000, 50000),
                                    position = "left") # x comparments
      
      p <- p + geom_text(aes(label = data$values - input$levelOfManipulation * 10000), # numbers next to bars
         position = position_nudge(y = 5),
         hjust = -0.15,
         size = 6,
         color = "#545454")
    }
      
    p <- p + coord_flip(clip = "off") + # let's knock over the columns!
      theme(plot.title = element_text(size = 28, # some visual extras
                                      face = "bold",
                                      hjust = -3,
                                      color = "#545454"),
            axis.text.y = element_text(hjust = 0,
                                       color = "#545454",
                                       face = "bold",
                                       size = 14),
            axis.title.y = element_blank(),
            axis.title.x = element_text(size = 14, face = "italic"),
            axis.ticks.y = element_blank())
    
    if(input$doWeManipulate) # delete x-axis numbers - they don't make sense if we manipulate!
    {
      p <- p + theme(axis.text.x = element_blank(),
                     axis.ticks.x = element_blank())
    }
  
    print(p)

  }, height = 500)
}