library(shiny)
library(r2d3)


fluidPage(
  titlePanel("Monthly surface temperature anomalies (°C)."),
  inputPanel(
    sliderInput("time_range", label = h3("Shown Years"), min = 1979, 
                max = 2019, value = c(1997, 1999)),
    selectInput("scope", label = "World/Europe", 
                choices = c("World", "Europe"))
  ),
  d3Output("d3")
)