library(shiny)
library(shinydashboard)
library(ggplot2)
library(wordcloud2)
library(plotly)
library(dplyr)
library(tm)
library(rCharts)
library(stringi)
library(ggridges)
library(RColorBrewer)
options(stringsAsFactors = FALSE)

#DANE WOJTAS
# data_msg <- read.csv("E://Pulpit//TWD//projekt_2//moje_dane//messenger.csv", encoding = "UTF-8")
# df1 <- data_msg %>%
#   select(c(4,10,11,14)) #zostawiamy tylko kolumny ktore nas itneresuja
most_popular_both <- read.csv("./dane_Wojtek/most_popular_both_Wojtek.csv", encoding = "UTF-8")
spedzony_czas <- read.csv("./dane_Wojtek/spedzony_czas_Wojtek.csv", encoding = "UTF-8")
spedzony_czas_osoby <- read.csv("./dane_Wojtek/spedzony_czas_osoby_Wojtek.csv", encoding = "UTF-8")
month_message_all <- read.csv("./dane_Wojtek/month_all_Wojtek.csv", encoding = "UTF-8")
hour_message_all <- read.csv("./dane_Wojtek/hour_all_Wojtek.csv", encoding = "UTF-8")
day_message_all <- read.csv("./dane_Wojtek/day_all_Wojtek.csv", encoding = "UTF-8")
df_joychart <- read.csv("./dane_Wojtek/joy_chart_Wojtek.csv", encoding = "UTF-8")
rozmowcy <- most_popular_both[most_popular_both$amount>50,]$rozmowca

#DANE ADA
# most_popular_both <- read.csv("./dane_Ada/most_popular_both_Ada.csv")
# spedzony_czas <- read.csv("./dane_Ada/spedzony_czas_Ada.csv")
# spedzony_czas_osoby <- read.csv("./dane_Ada/spedzony_czas_osoby_Ada.csv")
# month_message_all <- read.csv("./dane_Ada/month_all_Ada.csv")
# hour_message_all <- read.csv("./dane_Ada/hour_all_Ada.csv")
# day_message_all <- read.csv("./dane_Ada/day_all_Ada.csv")
# df_joychart <- read.csv("./dane_Ada/joy_chart_Ada.csv")
# rozmowcy <- most_popular_both[most_popular_both$amount>50,]$rozmowca


#DANE PIOTER
# data_msg <- read.csv("/home/piotr/Programowanie/Projekt_twd_2/messenger.csv", encoding = "UTF-8")
# df1 <- data_msg %>%
#   select(c(4,10,11,14)) #zostawiamy tylko kolumny ktore nas itneresuja
# 
# most_popular_both <- read.csv("./dane_piotrek/most_popular_both_Piotr.csv")
# spedzony_czas <- read.csv("./dane_piotrek/spedzony_czas_Piotr.csv")
# spedzony_czas_osoby <- read.csv("./dane_piotrek/spedzony_czas_osoby_Piotr.csv")
# month_message_all <- read.csv("./dane_piotrek/month_all_Piotr.csv")
# hour_message_all <- read.csv("./dane_piotrek/hour_all_Piotr.csv")
# day_message_all <- read.csv("./dane_piotrek/day_all_Piotr.csv")
# df_joychart <- read.csv("./dane_piotrek/joy_chart_Piotr.csv")
# rozmowcy <- most_popular_both[most_popular_both$amount>50,]$rozmowca

#Colnamesy
colnames(month_message_all) <- c("lp", "rozmowca", "month", "amount")
colnames(day_message_all) <- c("lp", "rozmowca", "day", "amount")
colnames(hour_message_all) <- c("lp", "rozmowca", "hour", "amount")


ui <- dashboardPage(
  
  dashboardHeader(
    title = "Analiza Messengera",
    titleWidth = 250
  ),
  
  dashboardSidebar(
    width = 250,
    
    sliderInput(
      inputId = "ilosc_wiadomosci",
      label = "Filtr liczby wiadomości:",
      min = 0,
      max = most_popular_both[1,3],
      value = c(0,most_popular_both[1,3])
      
    ),
    
    radioButtons(
      inputId = "radio",
      label = h3("Sortuj listę rozmowców:"),
      choices = list("Alfabetycznie (A-Z)" = 1, "Alfabetycznie (Z-A)" = 2, "Liczba wiadomości (malejąco)" = 3, "Liczba wiadomości (rosnąco)" = 4), 
      selected = 1
    ),
    
    uiOutput("select_input")
    
  ),
  dashboardBody(
    tags$head(
      HTML("<script src='https://kit.fontawesome.com/88ea72bd2f.js' crossorigin='anonymous'></script>"),
      tags$link(href="https://fonts.googleapis.com/css?family=Roboto&display=swap", rel="stylesheet"),
      tags$link(rel = "stylesheet", type = "text/css", href = "style_wizualizacja.css")
    ),
    fluidRow(
      valueBoxOutput("valuebox_1"),
      valueBoxOutput("valuebox_2"),
      valueBoxOutput("valuebox_3")
      
    ),
    
    fluidRow(
      column(align = "center",
        width = 6,
        fluidRow(
        uiOutput("tytul1"),
        conditionalPanel('input.typ=="Doba"', showOutput("wyszukane_doba", "nvd3")),
        conditionalPanel('input.typ=="Tydzień"', showOutput("wyszukane_dzien", "nvd3")),
        conditionalPanel('input.typ=="Rok"', showOutput("wyszukane_rok", "nvd3"))
        
        ),
        
        uiOutput("doba_rok")
        
        ),
      column(align = "center",
        width = 6,
        fluidRow(
          uiOutput("tytul2"),
          wordcloud2Output("wordcloud", height = 290)
        )
      )
    ), 
    fluidRow(
      column(12,
        align = "center",
             #textOutput("tytul3"),
        uiOutput("tytul3"),
        plotOutput("joychart", height = 285))
      
    )
    # tags$script(type="text/javascript", src ="counter_wizualizacja.js"),
    # tags$script(type="text/javascript", src ="counter_wizualizacja1.js"),
  )
)


server <- function(input, output){
  
  output[["tytul2"]] <- renderUI({
    req(input[["osoba_wyszukana"]])
    
    valueBox(
      value = tags$p("Jakich słów używamy?", style = "font-size: 50%;"), 
      subtitle = NULL,
      width = 12,
      color = "light-blue")
  })
  
  output[["tytul1"]] <- renderUI({
    req(input[["osoba_wyszukana"]])
    
    valueBox(
      value = tags$p("Kiedy ze sobą piszemy?", style = "font-size: 50%;"), 
      subtitle = NULL,
      width = 12,
      color = "light-blue")
  })
  
  output[["tytul3"]] <- renderUI({
    req(input[["osoba_wyszukana"]])
    
    valueBox(
      value = tags$p("Aktywność w czasie", style = "font-size: 50%;"), 
      subtitle = NULL,
      width = 12,
      color = "light-blue")
  })
  
  #output[["tytul3"]] <- renderText("Aktywność w czasie")
  
  output$select_input <- renderUI({
    if (input$radio == 1) {
      selectInput(
        inputId = "osoba_wyszukana",
        label = "Wybierz rozmówców",
        choices = stri_sort(most_popular_both %>%
                              filter(amount <= input$ilosc_wiadomosci[2], amount > input$ilosc_wiadomosci[1]) %>%
                              pull(2)), 
        multiple = TRUE,
        selectize = TRUE
      )
    } else if (input$radio == 2){
      selectInput(
        inputId = "osoba_wyszukana",
        label = "Wybierz rozmówców",
        choices = stri_sort(most_popular_both %>%
                              filter(amount <= input$ilosc_wiadomosci[2], amount > input$ilosc_wiadomosci[1]) %>%
                              pull(2), decreasing = TRUE), 
        multiple = TRUE,
        selectize = TRUE
      )
    }else if(input$radio == 3) {
      selectInput(
        inputId = "osoba_wyszukana",
        label = "Wybierz rozmówców",
        choices = most_popular_both %>%
          filter(amount <= input$ilosc_wiadomosci[2], amount > input$ilosc_wiadomosci[1]) %>%
          pull(2),
        multiple = TRUE,
        selectize = TRUE
      )
    }else if(input$radio == 4) {
      selectInput(
        inputId = "osoba_wyszukana",
        label = "Wybierz rozmówców",
        choices = most_popular_both %>%
          filter(amount <= input$ilosc_wiadomosci[2], amount > input$ilosc_wiadomosci[1]) %>%
          pull(2)%>%
          rev(),
        multiple = TRUE,
        selectize = TRUE
      )
    }
    
  })
  
  output[["doba_rok"]] <- renderUI({
    
    req(input[["osoba_wyszukana"]])
    
    radioButtons("typ",
                 label = "",
                 choices = c("Doba", "Tydzień", "Rok"),
                 inline = TRUE)
  })
  
  
  #OUTPUT WYKRES doba-tydzien-rok #################################################################
  
  #Wykres jesli wybrana jest DOBA
  
  output[["wyszukane_doba"]] <- renderChart2({
    
    lista_osob <- input[["osoba_wyszukana"]]
    
    req(input[["osoba_wyszukana"]])
    
    validate(need(input[["typ"]]=="Doba", message = FALSE))
    
    #Dane
    df <- filter(hour_message_all, hour_message_all$rozmowca %in% input[["osoba_wyszukana"]])
    df$hour <- ifelse(df$hour>=5, df$hour-5, 19+df$hour)
    df <- df[order(df$hour),]
    
    #Dodanie 0
    
    n <- length(lista_osob)
    dane <- as.data.frame(cbind(rep(lista_osob, 24), rep(seq(0, 23), each = n), rep(0, 24*n)))
    colnames(dane) <- c("rozmowca", "hour", "amount")
    dane$hour <- as.numeric(dane$hour)
    r <- left_join(dane, df, by = c("rozmowca", "hour"))
    r <- mutate(r, amount = ifelse(is.na(amount.y), 0, amount.y))
    r$amount <- round(r$amount, 2)
    r <- r[,c("rozmowca", "amount", "hour")]
    
    p <-  nPlot(amount ~ hour, group = 'rozmowca', data = r, type = 'lineChart')
    p$params$height <- 340
    p$chart(useInteractiveGuideline=TRUE)
    p$yAxis(axisLabel = "Średnia liczba wiadomości")
    p$chart(margin = list(left = 80, bottom = 90, right = 20))
    p$xAxis(
      tickFormat = "#!function(d) {
      if(d <=18 ) {return d+5}
      else {return d-19};}!#")
    p$xAxis(tickValues=seq(min(r$hour), max(r$hour), 2))
    p$chart(color = brewer.pal(n, "Dark2"))
    #p$templates$script <- "http://timelyportfolio.github.io/rCharts_nvd3_templates/chartWithTitle_styled.html"
    #p$set(title = "Kiedy piszesz do wybranych osób?")
    
    #wywolanie wykresu
    p
  })
  
  #Wykres jesli wybrany jest TYDZIEN
  output[["wyszukane_dzien"]] <- renderChart2({
    
    lista_osob <- input[["osoba_wyszukana"]]
    
    req(input[["osoba_wyszukana"]])
    
    validate(need(input[["typ"]]=="Tydzień", message = FALSE))
    
    #Dane
    df <- filter(day_message_all, day_message_all$rozmowca %in% lista_osob)
    
    #Dodanie 0
    n <- length(lista_osob)
    dni <- c("poniedziałek", "wtorek", "środa", "czwartek", "piątek", "sobota", "niedziela")
    
    dane <- as.data.frame(cbind(
      rep(lista_osob, 7),
      rep(dni, each = n),
      rep(0, 7*n)
    ))
    colnames(dane) <- c("rozmowca", "day", "amount")
    r <- left_join(dane, df, by = c("rozmowca", "day"))
    r <- mutate(r, amount = ifelse(is.na(amount.y), 0, amount.y))
    r <- r[,c("rozmowca", "amount", "day")]
    
    p <-  nPlot(amount ~ day, group = 'rozmowca', data = r, type = 'multiBarChart')
    p$params$height <- 340
    p$chart(margin = list(left = 80, bottom = 90, right = 20))
    p$yAxis(axisLabel = "Średnia liczba wiadomości")
    p$chart(color = brewer.pal(n, "Dark2"))
    #p$templates$script <- "http://timelyportfolio.github.io/rCharts_nvd3_templates/chartWithTitle_styled.html"
    #p$set(title = "Kiedy piszesz do wybranych osób?")
    
    #Wywolanie wykresu
    p
    
  })
  
  # #Wykres jesli wybrany jest ROK
  output[["wyszukane_rok"]] <- renderChart2({
    
    lista_osob <- input[["osoba_wyszukana"]]
    
    req(input[["osoba_wyszukana"]])
    
    validate(need(input[["typ"]]=="Rok", message = FALSE))
    
    #Dane
    df <- filter(month_message_all, month_message_all$rozmowca %in% lista_osob)
    
    #Dodanie 0
    n <- length(lista_osob)
    
    dane <- as.data.frame(cbind(
      rep(lista_osob, 12),
      rep(seq(1, 12), each = n),
      rep(0, 12*n)
    ))
    colnames(dane) <- c("rozmowca", "month", "amount")
    dane$month <- as.numeric(dane$month)
    r <- left_join(dane, df, by = c("rozmowca", "month"))
    r <- mutate(r, amount = ifelse(is.na(amount.y), 0, amount.y))
    r <- r[,c("rozmowca", "amount", "month")]
    
    p <-  nPlot(amount ~ month, group = 'rozmowca', data = r, type = 'multiBarChart')
    p$params$height <- 340
    p$chart(reduceXTicks = FALSE)
    #p$templates$script <- "http://timelyportfolio.github.io/rCharts_nvd3_templates/chartWithTitle_styled.html"
    #p$set(title = "Kiedy piszesz do wybranych osób?")
    p$yAxis(axisLabel = "Średnia liczba wiadomości")
    p$chart(margin = list(left = 80, bottom = 90, right = 20))
    p$chart(color = brewer.pal(n, "Dark2"))
    
    #Wywolanie wykresu
    p
    
  })
   
  ############################################################################################################################
  
  output[["ilosc_czasu_laczna"]] <- renderText({
    as.integer(spedzony_czas[1,4])
  })
  
  output[["ilosc_czasu_wyszukana"]] <- renderText({
    if (length(osoba_wyszukana[["selected"]])>0){
      aktualna_osoba <- as.character(osoba_wyszukana[["selected"]])
      ceiling(as.double(spedzony_czas_osoby[(spedzony_czas_osoby$osoba==aktualna_osoba) & (spedzony_czas_osoby$x=="Total"),4]))
    }})
  
  output[["valuebox_1"]] <- renderValueBox({
    aktualne_osoby <- input$osoba_wyszukana
    suma <- most_popular_both %>%
      pull(3) %>%
      as.double %>%
      sum()
    val <- 0
    if (length(input$osoba_wyszukana > 0)) {
      for (i in 1:length(aktualne_osoby)) {
        tmp <- most_popular_both[most_popular_both$rozmowca == aktualne_osoby[i],3] %>%
          as.double()
        val <- val + tmp
      }
      procent <- round(val/suma * 100, 2)
    } else {
      procent <- 0
    }
    valueBox(
      paste(procent,"%", sep=""),
      subtitle = "Wszystkich wiadomości stanowią te z wybranymi osobami",
      icon = icon("far fa-clock")
    )
  })
  
  
  output[["valuebox_2"]] <- renderValueBox({
    aktualne_osoby <- input$osoba_wyszukana
    val <- 0
    if (length(input$osoba_wyszukana > 0)) {
      for (i in 1:length(aktualne_osoby)) {
        tmp <- spedzony_czas_osoby[spedzony_czas_osoby$rozmowca == aktualne_osoby[i],4] %>%
          as.double() %>%
          ceiling()
        val <- val + tmp
      }
    } else {
      val <- 0
    }
    valueBox(
      paste(val,"h",sep=""),
      subtitle = "Zajęło Tobie napisanie wiadomości do wybranych osób",
      color = "blue",
      icon = icon("fas fa-user-clock")
      
    )
  })
  
  
  output[["valuebox_3"]] <- renderValueBox({
    val <- 0
    if (length(input$osoba_wyszukana > 0)) {
      for (i in 1:length(input$osoba_wyszukana)) {
        val <- val + most_popular_both[most_popular_both$rozmowca == input$osoba_wyszukana[i],3]
      }
      val <- val %>%
        prettyNum(big.mark = ",")
    } else {
      val <- 0
    }
    valueBox(
      val,
      subtitle = "Tyle wiadomości wymieniłeś z wybranymi osobami",
      color = "teal",
      icon = icon("fas fa-envelope")
    )
  })
  
  output[["wordcloud"]] <- renderWordcloud2({
    req(input[["osoba_wyszukana"]])
    
    lista_osob <- input[["osoba_wyszukana"]]
    
    r <- data.frame(word = c(""), freq = c(0))
    
    for (osoba in lista_osob) {
      
      if(osoba %in% rozmowcy){
      
      aktualna_osoba <- paste(strsplit(osoba, split = " ")[[1]], collapse = "")
      current_nazwa <- paste("./dane_Wojtek/wordcloud/wordcloud_",aktualna_osoba,".csv",sep="")
      df <- read.csv(current_nazwa, encoding = "UTF-8")
      
      r <- full_join(r, df, by = "word")%>%
        replace(is.na(.), 0)%>%
        mutate(amount = freq.x + freq.y)%>%
        select(word, freq = amount)
      
      }
    }
    
    if(length(r)>0){
      wordcloud2(data = r, color = 'random-dark', backgroundColor = '#ecf0f5')
    }
  })
  
  output[["joychart"]] <- renderPlot({
    
    req(input[["osoba_wyszukana"]])
    lista_osob <- input[["osoba_wyszukana"]]
    a <- c()
    for(i in 1:length(lista_osob)){
      cur <- df_joychart%>%filter(rozmowca==lista_osob[i])
      a <- c(a,min(which(cur$n>0)))
    }
    b <- max(df_joychart$nr)
    
    kolejnosc <- order(lista_osob)
    kolory <- brewer.pal(8, "Dark2")
    kolory <- kolory[1:length(lista_osob)]
    kolory <- kolory[kolejnosc]
    
    df_joychart %>% filter(rozmowca %in% lista_osob)%>%
      ggplot(aes(x=nr, y=rozmowca, fill=rozmowca, height=density, color=rozmowca))+
      geom_density_ridges2(stat="identity", scale=ifelse(length(lista_osob)==1,50,1), alpha=1)+
      scale_y_discrete(limits = rev(lista_osob))+
      scale_x_continuous(breaks=c(a,b), labels=c(paste(df_joychart[a,2]), "aktualna data"))+
      geom_vline(xintercept = c(a,b), linetype="dashed", color="darkgrey", size=1)+
      theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), 
            panel.background = element_rect(fill = '#ecf0f5', linetype = 0, colour = '#ecf0f5'),
            plot.background = element_rect(fill = '#ecf0f5', linetype = 0, colour = '#ecf0f5'),
            legend.background = element_rect(fill = '#ecf0f5'),
            plot.margin = unit(c(0.5,1,0,1), "cm"),
            legend.title=element_blank(), 
            legend.text=element_text(size=15))+
      labs(x=NULL, y=NULL)+
      scale_fill_manual(name = "Rozmówca",
                        values = kolory,
                        labels = lista_osob[kolejnosc])+
      scale_color_manual(name = "Rozmówca",
                         values = kolory,
                         labels = lista_osob[kolejnosc])+
      theme(axis.text.x = element_text(size=13, angle = 45, color="black"), axis.text.y = element_text(size=15), axis.ticks = element_blank())
    })
  
}

shinyApp(ui, server)
