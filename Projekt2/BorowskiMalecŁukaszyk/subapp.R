library(shiny)
library(DT)
library(dplyr)
library(plotly)
library(tidyverse)

#data początkowa i końcowa
begin <- "2017-01-01"
end <- "2018-01-01"

#to samo co w głównej app
dane <-  read.csv2("data_layer1.csv")
dane2<-dane
dane1<-select(dane,c(2,3,4,5))
dane <- dane [,-1]
dane$profit <- floor(dane$revenue/2.4 - dane$budget)
dane <- dane[,c(5,6,3,2)]
dane1$profit <- floor(dane1$revenue/2.4 - dane1$budget)
dane1$release_date <- as.Date( dane1$release_date,"%d/%m/%Y")
dane1<-filter(dane1,release_date >= as.Date(begin))
dane1<-filter(dane1,release_date<= as.Date(end))
dane1<-aggregate(dane1$profit,by = list(Name=dane1$production_companies), FUN = sum)
dane1<-rename(dane1,value = x)
dane1<-arrange(dane1,desc(value))
dane1<-slice(dane1,1:10)#Można dać do N by wybierało n najmocniejszych firm
names2<-select(dane1,Name)
name<-unlist(names2,use.names = FALSE)
dane2$profit <- floor(dane2$revenue/2.4 - dane2$budget)
dane2$release_date <- as.Date( dane2$release_date,"%d/%m/%Y")
dane2<-filter(dane2,release_date >= as.Date(begin))
dane2<-filter(dane2,release_date<= as.Date(end))
dane2<-subset(dane2, production_companies %in% name)
names3<-add_column(names2,profit = 0,release_date = begin)
names2<-add_column(names2,profit = 0,release_date = end)
names4<-rbind(names2,names3)
names4$revenue<-NA
names4$title<-NA
names4$budget<-NA
names4$X<-NA
names4<-rename(names4,production_companies = Name)
dane2<-rbind(dane2,names4)
dane2<-arrange(dane2,release_date)
dane2<-group_by(dane2,production_companies)
dane2<-mutate(dane2,suma = cumsum(profit))


#dodatkowawo zamiana release_date jako czas
dane$release_date <- as.Date( dane$release_date,"%d/%m/%Y")

ui <- fluidPage(
  titlePanel( paste0( "Time period from ", begin, " to ", end)),
  tabsetPanel(
    #wszystike filmy
    tabPanel("All films back then", dataTableOutput("all_film")), 
    #wykres premier i zarobków filmów
    tabPanel("Flims box office", plotlyOutput("films_boxoffice")), 
    #wykres zarobków producentów w danym czasie
    tabPanel("Producers' earnings", plotlyOutput("prod"))
  )
  
)

server <- function(input, output, session) {
  #przefiltrowanie danych pod wzgledem daty początkowej i końcowej
  data_period_r <- reactive({
    dane %>%
      arrange( desc( profit)) %>%
      filter( release_date >= as.Date( begin) ) %>%
      filter( release_date <= as.Date( end) )
  })
  #tabelka wzytskich filmów
  output$all_film <- renderDataTable(
    data_period_r(),
    rownames = FALSE
  )
  #plotly premier i zarobków filmów
  output$films_boxoffice <- renderPlotly({
    p<-plot_ly( data = data_period_r(), x = ~release_date, y = ~profit,
             text = ~title,
             hovertemplate = paste('<b>%{text}</b><br>',
                                   '<i>Profit</i>: $%{y}<br>',
                                   '<i>Release date</i>: %{x}<br>'
             )
    ) %>%
      layout(
        #nazwy osi
        yaxis = list( title = "Box office"),
        xaxis = list( title = "Release date", range = c(begin, end)),
        showlegend = FALSE
      ) %>%
      add_segments( xend = ~release_date, yend = 0) %>%
      add_trace(mode = 'markers') %>%
      add_text(textfont = t, textposition = "top right")
    
    
  })
  output$prod<- renderPlotly({
    plot_ly(dane2,x = ~release_date,y = ~suma, type = "scatter", mode = "lines",color =~production_companies ,colors = "Set3") %>%
      layout(title = "Całkowite przychody w okresie",
             xaxis = list(title = "Test"),
             yaxis = list(title = "Przychody $")
      )
    
    
  })
}

shinyApp(ui,server)