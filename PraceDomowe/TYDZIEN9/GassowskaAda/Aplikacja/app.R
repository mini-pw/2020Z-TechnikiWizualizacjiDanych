library(shiny)
library(r2d3)
library(dplyr)
library(reshape2)



ui <- fluidPage(
  
  # Application title
  titlePanel("STATYSTYKI POLICYJNE Z DNIA 2019-10-07"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      checkboxGroupInput("checkBox", 
                         h3("Wybierz kategorie"), 
                         choices = list("Wypadki" = "wypadki", 
                                        "Zatrzymania" = "zatrzymania"),
                         selected = c("wypadki", "zatrzymania")),
      selectInput("bar_col", label="Kolor_zatrzymania",choices = c("red", "blue", "green", "yellow")),
      selectInput("bar_col2",label="Kolor_wypadki", choices = c("red", "blue", "green", "yellow"))
      
      
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      d3Output("d3")
    )
  )
)

data <- read.csv("./data.csv")



server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(cbind(data,data.frame(color=c(rep(input[["bar_col"]],3),rep(input[["bar_col2"]],3)))) %>% 
           filter(category %in% input[["checkBox"]]),
         script = "baranims.js"
    )
  })
}

shinyApp(ui = ui, server = server)