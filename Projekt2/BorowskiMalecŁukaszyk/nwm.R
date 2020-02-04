ui <- fluidPage(
  titlePanel("Movie buissnes"),
  
  fluidRow(
    column(4,
   dateRangeInput("daterange", "Date range:",
                    start  = "2015-01-01",
                    end    = "2010-01-01",
                    min    = "180-01-01",
                    max    = "2020-12-21",
                    format = "yyyy-mm-dd",
                    separator = " - ")),
  
  column(4,
    selectInput("select","Time step", 
                choices = list("Month" = 1, "Year" = 2,
                               "10 Year" = 3), selected = 1))
    
  )
  
  
  
  
  
)

# Define server logic ----
server <- function(input, output) {
  observe(
  print(paste(as.character(input$daterange), collapse = " to "))
  )
}

# Run the app ----
shinyApp(ui = ui, server = server)