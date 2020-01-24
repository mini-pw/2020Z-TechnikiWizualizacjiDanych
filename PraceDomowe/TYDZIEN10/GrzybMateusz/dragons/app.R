library(shiny)
library(r2d3)
options(r2d3.shadow = FALSE)
library(dplyr)

load("dragons.rda")

ui <- fluidPage(
  tags$head(
    tags$style(
      HTML("
        .tooltip {
          position: absolute;
          font-size: 12px;
          width:  auto;
          height: auto;
          pointer-events: none;
          background-color: white;
        }"
      )
    )
  ),
    titlePanel("Dragons Data"),
    tags$p("...by Mateusz Grzyb"),
    sidebarLayout(
        sidebarPanel(
          h4("Dragons' color:"),
          checkboxInput("black", label = span("Black", style = "color: black;"), value = FALSE),
          checkboxInput("blue", label = span("Blue", style = "color: blue;"), value = TRUE),
          checkboxInput("green", label = span("Green", style = "color: green;"), value = FALSE),
          checkboxInput("red", label = span("Red", style = "color: red;"), value = TRUE),
          sliderInput("birth", label = h4("Dragons' year of birth:"), min = -1999, 
                      max = 1800, value = c(-1999, 1800)),
          sliderInput("discovery", label = h4("Dragons' year of discovery:"), min = 1700, 
                      max = 1800, value = c(1700, 1705)),
    ),
        mainPanel(
          tabsetPanel(
            tabPanel("Scatter Plot", d3Output("d3_1", width = 600, height = 600),
                     sliderInput("opacity", "Dot opacity:", min = 0, max = 1, step = 0.05, value = 0.75),
                     checkboxInput("show", label = "Scale size by life lenght", value = TRUE)), 
            tabPanel("Histogram 1", d3Output("d3_2", width = 600, height = 600),
                     sliderInput("bins1", "Bins:", min = 5, max = 50, step = 1, value = 10),
                     checkboxInput("divide1", label = "Divide by colors", value = TRUE)), 
            tabPanel("Histogram 2", d3Output("d3_3", width = 600, height = 600),
                     sliderInput("bins2", "Bins:", min = 5, max = 50, step = 1, value = 10),
                     checkboxInput("divide2", label = "Divide by colors", value = FALSE)), 
            tabPanel("Debug", verbatimTextOutput("test"))
          )
        )
    )
)

server <- function(input, output) {

  getData <- reactive({
    colors <- c("black", "blue", "green", "red")[c(input$black, input$blue, input$green, input$red)]
    filter(dragons, year_of_birth >= input$birth[1], year_of_birth <= input$birth[2]) %>%
      filter(year_of_discovery >= input$discovery[1], year_of_discovery <= input$discovery[2]) %>%
        filter(colour %in% colors)
  })
  
  output$test <- renderPrint({
    df <- getData()
    (paste("Dragons included:", length(df[[1]])))
  })
  
  output[["d3_1"]] <- renderD3({
    df <- as.data.frame(getData())
    r2d3(data = df, script = "script1.js", options = list(show = input$show, opacity = input$opacity))
  })
  
  output[["d3_2"]] <- renderD3({
    df <- as.data.frame(getData())
    r2d3(data = df, script = "script2.js", options = list(bins = input$bins1, divide = input$divide1))
  })
  
  output[["d3_3"]] <- renderD3({
    df <- as.data.frame(getData())
    r2d3(data = df, script = "script3.js", options = list(bins = input$bins2, divide = input$divide2))
  })
}

shinyApp(ui = ui, server = server)
