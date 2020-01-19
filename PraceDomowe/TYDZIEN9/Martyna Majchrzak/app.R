library(shiny)
library(r2d3)
library(dplyr)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Wykres"),
  inputPanel(
    sliderInput("year", label = "Choose years to display:",
                min = 2002, max = 2018, value = c(2002,2018), step = 1),
    checkboxInput("Games", label="Games", value=TRUE),
    checkboxInput("Goals", label="Goals", value=TRUE)
    
  ),
  # tableOutput("data"),
  plotOutput("wykres"),
  
)

server <- function(input, output) {
  
  selected_countries <- reactiveValues(
    selected = character()
  )
  
  # do testów
  # output[["data"]]<-renderTable({
  #   data = read.csv(file = "C:/Users/marty/OneDrive/Dokumenty/TWD/2020Z-TechnikiWizualizacjiDanych/PraceDomowe/TYDZIEN9/Martyna Majchrzak/Cristiano_Ronaldo.csv", sep = ",")
  #   colnames(data)[1]<-"Season"
  #   data<-data%>%
  #     mutate(Season=substr(Season,1,4))%>%
  #     filter(Season >= input[["year"]][1] & Season <= input[["year"]][2])%>%
  #     select(c(Season,input[["checkGroup"]]))
  # }, rownames = TRUE)
  
  
  output[["wykres"]] <- renderPlot({
    
    # pobranie i przygotowanie danych zgodnie z zaznaczeniami z kontrolek
    data = read.csv(file = "Cristiano_Ronaldo.csv", sep = ",")
    colnames(data)[1]<-"Season"
    data<-data%>%
      mutate(Season=substr(Season,1,4))%>%
      filter(Season >= input[["year"]][1] & Season <= input[["year"]][2])


    g<-ggplot(data, aes(x=Season)) 
    
    if (input[["Games"]]) g<-g+geom_line(aes(x = Season, y = Games, group = "Games", color = "Games"), size = 1.5)
    if (input[["Goals"]]) g<-g+geom_line(aes(x = Season, y = Goals, group = "Goals", color = "Goals"), size = 1.5)
    
    g<-g+scale_color_manual(name="", values=c("Games"="deepskyblue3",  
                                           "Goals"="red")) + 
      scale_fill_manual(name="", values=c("Games"="deepskyblue3",
                                          "Goals"="red"))+
      labs(title = "Ronaldo games and goals per season", x = NULL, y = NULL) + 
      scale_y_continuous(limits = c(0,70), breaks = seq(0,70,10)) +
      theme(panel.background = element_blank()) + 
      theme(panel.grid.major.y = element_line(colour = "lightgrey", linetype = "solid", size = 1.2)) +
      theme(axis.line.y = element_line(colour = "lightgrey", linetype = "solid", size = 1.2)) +
      theme(plot.title = element_text(size = 22, face = "bold")) + 
      theme(legend.position = "top", legend.justification = c(0,0), legend.key = element_blank(), 
            legend.text = element_text(size = 16)) +
      theme(axis.text.x.bottom = element_text(colour = "black",size = 16, angle = 45), axis.ticks = element_blank()) +
      theme(axis.text.y = element_text(colour = "black", size = 16), axis.ticks = element_blank())
    
    g
  })
}

shinyApp(ui = ui, server = server)
