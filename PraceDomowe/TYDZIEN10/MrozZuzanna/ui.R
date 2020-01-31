library(shiny)
library(ggplot2)

dataset <- dragons
dragonsNoColors <- dragons[, c(1:4, 6:8)]

shinyUI(fluidPage(
    
    title = "Dragons Explorer",
    
    HTML('<center><img src="dragon.png" width="250"></center>'),
    
    plotOutput('plot'),
    
    hr(),
    
    fluidRow(
        column(3,
               h4("Dragon Explorer"),
               sliderInput('sampleSize', 'Sample Size', 
                           min=1, max=nrow(dataset),
                           value=min(1000, nrow(dataset)), 
                           step=10, round=0),
               br(),
               checkboxInput('jitter', 'Jitter'),
               checkboxInput('smooth', 'Smooth'),
               checkboxInput('facet', 'Facet by color')
        ),
        column(4, offset = 1,
               selectInput('x', 'X', names(dragonsNoColors)),
               selectInput('y', 'Y', names(dragonsNoColors), names(dragonsNoColors)[[2]])
        ),
        column(4,
               selectInput('color', 'Color', c('None', names(dataset))),
               radioButtons('geom', 'Geometry', c('Point', 'Line', 'Density'))
        )
    )
))