library(dplyr)
library(shiny)
library(shinythemes)
library(plotly)

data <- read.csv(file = "gielda.csv")[,2:17]
colnames(data) <- c("Data","Alior Bank SA", "Banco Santander SA", "Bank Handlowy SA", "Bank Millennium SA",
                    "Bank Pekao SA", "BNP Paribas Bank Polska SA", "BOŚ SA", "Getin Holding SA",
                    "Idea Bank SA", "ING Bank SA", "MBank SA", "PKO BP SA", "Santander Bank Polska SA",
                    "UniCredit SA", "Suma")
colors <- cbind(colnames(data)[2:15],
                c("rgb(255, 204, 255)","rgb(250, 255, 204)", "rgb(255, 178, 102)","rgb(0, 220, 0)",
            "rgb(255, 255, 0)","rgb(255, 0, 107)","rgb(96, 196, 96)","rgb(0, 0, 204)",
            "rgb(153, 76, 0)", "rgb(0, 150, 85)", "rgb(204, 0, 0)", "rgb(102, 102, 26)",
            "rgb(10, 10, 10)","rgb(30, 20, 140)"))
colors
ui <- fluidPage(titlePanel("Ceny akcji banków na GPW"),
                mainPanel(
                  dateRangeInput(inputId = "date", label = "Przedział dat", min = "2019-05-06",
                                 max = "2019-11-06", start = "2019-05-06", end = "2019-11-06", 
                                 startview = "year"),
                  checkboxGroupInput(inputId = "banki", label = "Banki", choices = colnames(data)[2:15],
                                     inline=FALSE),
                  plotlyOutput("Plot"),width=12),
                theme = shinytheme("journal"))


server <- function(input, output) {
  
  output$Plot <- renderPlotly({
    data <- data %>% filter((data$Data >= paste(substr(input$date[1],1,4),substr(input$date[1],6,7),
                                        substr(input$date[1],9,10),sep = "")) & 
                      (data$Data <= paste(substr(input$date[2],1,4),substr(input$date[2],6,7),
                                          substr(input$date[2],9,10),sep = ""))) %>% 
      select(c("Data",input$banki, "Suma"))
    data$Data <- paste(substr(data$Data,1,4),substr(data$Data,5,6),substr(data$Data,7,8), sep = "-")
   
  
      p <- plot_ly(data, x = ~data[,1], y = ~data[,"Suma"], type = 'scatter', mode = 'markers+lines', 
                   name = "Uśredniona cena akcji z indeksu WIG-Banki", 
                   marker = list(color = "rgba(20, 20, 20)", line = list(color = "rgb(20, 20, 20)"))) %>%
        layout(title = "WIG-Banki na GPW", xaxis = list(title = "Data", tickangle=45), 
               yaxis = list (title = "Ceny akcji (w PLN)"), showlegend = TRUE, 
               legend = list(orientation = "h", xanchor = "center", x = 0.5, y=-0.5))
        if (length(input$banki)>0){
          for(i in 1:length(input$banki)){
            p <- add_trace(p,y=data[,input$banki[i]],x=data[,1],  type = 'scatter', mode = 'markers+lines',
                           name = input$banki[i], marker = list(color = colors[colors[,1]==input$banki[i],2]),
                           line = list(color = colors[colors[,1]==input$banki[i],2]))}}
      p})
}

shinyApp(ui = ui, server = server)

