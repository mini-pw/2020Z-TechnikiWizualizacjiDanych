library("dplyr")
library("shiny")
library("plotly")

ui <- fluidPage(
  titlePanel("Zapotrzebowanie na moc w KSE"),
  checkboxInput( inputId = "diff", label = "Różnica"),
  conditionalPanel("input.diff < 1",
                   plotlyOutput("plot1", height = 600)
  ),
  conditionalPanel("input.diff > 0",
                   plotlyOutput("plot2", height = 600)
  )
)

server <- function(input, output) {
  ##wczytywanie danych
  data <- read.csv("ZAP_KSE_20191017_20191018080531.csv", sep=";")
  
  # ustawiamy kolumne z data i godzina
  godz <- paste(1:24, "00", sep=":")
  data[1] <- paste("2019-10-17", godz)
  # factory - inaczej posortuje stringi
  data$Data <- factor(data$Data, levels = data$Data)
  # stringi jako double - przecinek na kropke
  data$Rzeczywiste.zapotrzebowanie.KSE <- sapply(data$Rzeczywiste.zapotrzebowanie.KSE, function(x){scan(text = toString(x), dec=",")})
  # róznica
  data$Roznica <- data$Rzeczywiste.zapotrzebowanie.KSE - data$Dobowa.prognoza.zapotrzebowania.KSE
  #ustawienia
  theme_set(theme_minimal())
  legenda <- c("red", "blue")
  
  data_df <- as.data.frame( data)
  
  #wykres
  plotly1 <- plot_ly( data_df, type = "scatter", mode = "lines") %>%
    add_trace( x = ~Data, y = ~Dobowa.prognoza.zapotrzebowania.KSE, name = "Prognoza", line = list( color = "red")) %>%
    add_trace( x = ~Data, y = ~Rzeczywiste.zapotrzebowanie.KSE, name = "Zapotrzebowanie", line = list( color = "blue")) %>%
    layout( xaxis = list( title = "", color = "black"),
            yaxis = list( title = "Prognoza i rzeczywiste zapotrzebowanie [MW]", color = "black"),
            paper_bgcolor = 'transparent',
            plot_bgcolor= 'transparent'
    )
    


  output[["plot1"]] <- renderPlotly( plotly1)
  
  #dodatkowy wykres różnica
  ay <- list(
    tickfont = list(color = "green"),
    overlaying = "y",
    side = "right",
    title = "Różnica prognozy i zapotrzebowania [MW]",
    color = "black",
    range = c( -1550, 550),
    gridcolor = "green",
    gridwidth = 2,
    zerolinecolor = "green",
    zerolinewidth = 3
  )
  
  output[["plot2"]] <- renderPlotly({ 
      plotly1 %>%
        add_trace( x = ~Data, y = ~Roznica, name = "Różnica", line = list( color = "green"), yaxis = "y2") %>%
        layout( yaxis2 = ay,
                legend = list( x=100, y=0.92))
  })
}

shinyApp(ui = ui, server = server)
