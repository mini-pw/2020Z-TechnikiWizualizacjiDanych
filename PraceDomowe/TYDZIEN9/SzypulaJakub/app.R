library(shiny)
library(ggplot2)
library(dplyr)
library(reshape2)
library(zoo)
library(plotly)
library(colourpicker)
library(shinythemes)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(title = "Wykres",
                 colourInput("colourCON",
                             label = "Kolor CON",
                             value = "#0575C9"),
                 colourInput("colourLAB",
                             label = "Kolor LAB",
                             value = "#E91D0E"),
                 colourInput("colourLD",
                             label = "Kolor LD",
                             value = "#EFAC18"),
                 colourInput("colourBRX",
                             label = "Kolor Brexit",
                             value = "#02B6D7"),
                 colourInput("colourGRN",
                             label = "Kolor GRN",
                             value = "#5FB25F"),
                 colourInput("colourUKIP",
                             label = "Kolor UKIP",
                             value = "#712F87"),
                 colourInput("colourSNP",
                             label = "Kolor SNP",
                             value = "#F8ED2E"),
                 colourInput("colourPC",
                             label = "Kolor PC",
                             value = "#159B78"),
                 colourInput("colourTIG",
                             label = "Kolor TIGfC",
                             value = "#414142"),
                 sliderInput("krokiSredniej", label = "Kroki średniej ruchomej: ",
                             min = 1, max = 15, value =7 , step = 1),
    ),
    mainPanel(plotlyOutput("distPlot"))
  ),
  theme = shinytheme("united")
)


server <- function(input, output) {
  #observeEvent(input$Reset)
  output$distPlot <- renderPlotly({
    results <- read.csv("pollsovertime.csv")
    # przekonwertowanie kolumny na date
    results[,"Date"] <- as.Date(results[,"Date"], format="%d/%m/%y") 
    d <- melt(results, id.vars = "Date", na.rm = TRUE) # ramka do wygodnego plotowaia
    results_moving <- results # ramka z przesuwajaca sie srednia
    results_moving[,2:10] <- rollmean(results[,2:10], input[["krokiSredniej"]], fill = "extend")
    results_moving <- melt(results_moving, id.vars = "Date", na.rm=TRUE) 
    
    p <- ggplot(d, aes(Date, value, col = variable), fill = factor(variable)) +
      labs(color="Party: ") + # nazwa legendy
      scale_color_manual( # nadanie odpowiednich kolorow odpowiednim partiom i skrotow
        values = c("CON" = input[["colourCON"]],
                   "LAB" = input[["colourLAB"]],
                   "LD" = input[["colourLD"]],
                   "BRX" = input[["colourBRX"]],
                   "GRN" = input[["colourGRN"]],
                   "SNP" = input[["colourSNP"]],
                   "UKIP" = input[["colourUKIP"]],
                   "PC"= input[["colourPC"]],
                   "TIGfC"= input[["colourTIG"]])) +
      geom_point(alpha=0.7, shape=16, size=1) + # wyniki poszczegolnych sondazy
      geom_line(data=results_moving, aes(Date, value), size=1) + # trend line
      scale_x_date(date_breaks = "1 month", # ustalenie skali takiej jak w oryginale
                   date_labels = "%b", name = "") + 
      scale_y_continuous(name="%", expand = c(0, 0)) + # przesuniecie do 0 jak w oryginale
      ggtitle("Party support: 10 October 2019")+ 
      theme( # nadanie stylu tak jak w oryginalnym wykresie
        legend.position = "top",
        legend.direction = "horizontal",
        legend.background = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.grid.major.y = element_line( size=.2, color="#AEAEB5"),
        panel.grid.minor.y = element_blank(),
        axis.title.y = element_text(angle=0, vjust=1, hjust=1),
        plot.background = element_rect(fill = "#F2F2F2"),
        panel.background = element_rect(fill="white"),
        plot.title = element_text(face="bold", colour = "#3f3f42", size = "18")
      ) + coord_cartesian(ylim=c(0, 52))
    ggplotly(p)
  })
}

shinyApp(ui = ui, server = server)
