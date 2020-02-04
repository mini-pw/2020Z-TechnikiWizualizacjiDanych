library(shiny)
library(rpivotTable)
library(dplyr)

tbl <- read.csv("Movie Ratings.csv")

tbl %>% select("Genre") %>% unique() %>% as.vector() -> choice

ui <- fluidPage(titlePanel("Hollywood movies per year"), sidebarPanel(sliderInput("Rotten","Rotten Tomates Ratings",value = c(0,100), min = 0, max = 100),
                             sliderInput("Audience", "Audience Ratings", value = c(0,100), min = 0, max = 100),
                             sliderInput("Budget", "Budget of the movie [in mln USD]", value = c(0,300), min = 0, max = 300),
                             checkboxGroupInput("Genre", "Genre", choices = choice[,1], selected = choice[,1])),
  rpivotTableOutput("table"))
server <- function(input, output){
  output$table <- renderRpivotTable({
    colnames(tbl) <- c("Film", "Genre","Rotten_Tomatoes_Ratings", "Audience_Ratings", "Budget", "Year")
    tbl %>% filter(Genre %in% input$Genre) %>%
      filter(Rotten_Tomatoes_Ratings >= input$Rotten[1]) %>%
      filter(Rotten_Tomatoes_Ratings <= input$Rotten[2]) %>%
      filter(Audience_Ratings >= input$Audience[1]) %>%
      filter(Audience_Ratings <= input$Audience[2]) %>%
      filter(Budget >= input$Budget[1]) %>%
      filter(Budget <= input$Budget[2])-> tbl
    rpivotTable(tbl, rows = "n", cols = c("Year"), rendererName = "Bar Chart", height = "100%", width = "100%")})
}
shinyApp(ui = ui, server = server)
