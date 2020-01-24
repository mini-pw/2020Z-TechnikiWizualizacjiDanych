#Interactive Exploration: The impact of outlier on regression results
#An R Shiny - d3.js application.

# Downward Bias the $R^2$:

#Consider the outlier on the left side. It does not fit the **line** the rest of the data points create. 
#Click&Drag it on the right in the line with the other points and see what happens to the $R^2$.


# Upward Bias the $R^2$:

#Consider the outlier in the lower right hand corner. It does not fit the **circle** the rest of the data points create. 
#Click&Drag it on the right in the line with the other points and see what happens to the $R^2$.


# Final Remarks
#Credits to unknown: I remember seeing a similar show case in the field of psychology some time ago. I think it was
#pure java-script implementation. Unfortunately, I could not find it again. 

library(shiny)

source("DragableFunctions.R")

options(digits = 2)

df <- data.frame(
  x = seq(from = 20, to = 150, length.out = 10) + rnorm(10)*8,
  y = seq(from = 20, to = 150, length.out = 10) + rnorm(10)*8
)

df$y[1] = df$y[1] + 80

ui <- fluidPage(
  fluidRow(
    width = 3,
    DragableChartOutput("chart")
  ),
  fluidRow(
    width = 9,
    verbatimTextOutput("regression")
  )
)


server <- function(input, output, session) {
  output[["chart"]] <- renderDragableChart({
    df
  }, r = 3, color = "purple")
  
  output[["regression"]] <- renderPrint({
    if (!is.null(input[["JsData"]])) {
      mat <- matrix(
        data = as.integer(input[["JsData"]]), 
        ncol = 2, 
        byrow = TRUE
      )
      
      summary(
        object = lm(formula = mat[, 2] ~  mat[, 1])
      )
      
    } else {
      summary(
        object = lm(df[["y"]] ~  df[["x"]])
      )
    }
  })
}

shinyApp(ui = ui, server = server)
