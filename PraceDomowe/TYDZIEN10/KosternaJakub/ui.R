library(shiny)
library(ggplot2)

data <- load(file = "dragons.rda")


fluidPage(
  titlePanel("Dragons visualization generator"),
  
  sidebarPanel(
    checkboxInput('groupByColor', 'Do we want to group dragons by colors?', value = TRUE),
    checkboxInput('facetByColor', 'Or maybe even facet by them?', value = FALSE),
    
    sliderInput('howMany', 'Choose number of properties to compare',
                min = 1, max = 2, value = 1, step = 1),
    
    conditionalPanel(
      condition = "input.howMany == 1",
      
      radioButtons("typeOfPlot", "Type of plot:",
                   c("Density" = "geom_density()",
                     "Bar" = "geom_bar()",
                     "Freqpoly" = "geom_freqpoly()",
                     "Histogram" = "geom_histogram()"))
    ),
    
    conditionalPanel(
      condition = "input.howMany == 2",
      
      checkboxInput('isSmooth', 'Want to add a smoother line?', value = TRUE),
      
      radioButtons("typeOfPlot2", "Type of plot:",
                   c("Point" = "geom_point()",
                     "Box" = "geom_boxplot()",
                     "Column" = "geom_col()",
                     "Violin" = "geom_violin()",
                     "Jitter" = "geom_jitter()"))
    ),
    
    radioButtons("first", "First coordinate:",
                 c("Year of birth" = "year_of_birth",
                   "Height" = "height",
                   "Weight" = "weight",
                   "Scars" = "scars",
                   "Year of discovery" = "year_of_discovery",
                   "Number of lost teeth" = "number_of_lost_teeth",
                   "Life length" = "life_length"), selected = "number_of_lost_teeth"),
    
    conditionalPanel(
      condition = "input.howMany == 2", 
      
      radioButtons("second", "Second coordinate:",
                   c("Year of birth" = "year_of_birth",
                     "Height" = "height",
                     "Weight" = "weight",
                     "Scars" = "scars",
                     "Year of discovery" = "year_of_discovery",
                     "Number of lost teeth" = "number_of_lost_teeth",
                     "Life length" = "life_length"), selected = "life_length")
    )
  ),
  
  mainPanel(
    plotOutput('plot')
  )
)