library(shiny)
library(tidyverse)
library(jsonlite)
library(shinythemes)
library(lubridate)
# library(r2d3)
library(dplyr)
library(plotly)
library(png)
library(ggplot2)
library(ggjoy)
options(stringsAsFactors = FALSE)


clickme <- readPNG('clickme.png')


ui <- fluidPage(theme = shinytheme("yeti"),
                
                sidebarLayout(
                    sidebarPanel(width=4,
                                 titlePanel("SpotiData - sprawdź swoje statystyki słuchania platformy Spotify", windowTitle = "SpotiData"),
                                 hr(),
                                 actionButton("zima", "Zima", width = "110px"),
                                 actionButton("wiosna", "Wiosna", width = "110px"),
                                 br(),
                                 actionButton("lato", "Lato", width = "110px"),
                                 actionButton("jesien", "Jesień", width = "110px"),
                                 br(),
                                 actionButton("resetdat", "Reset dat", width = "224px"),
                                 # hr(),
                                 # dateRangeInput("daterange1", "Zakres dat:",
                                 #                start = "2018-12-01",
                                 #                end   = "2020-01-31",
                                 #                language = "pl",
                                 #                weekstart = 1,
                                 #                separator = " do "),
                                 hr(),
                                 fileInput('files', 'Załaduj swoje dane:', multiple = TRUE,
                                           accept = c("text/csv",
                                                      "text/comma-separated-values,text/plain",
                                                      ".csv", ".json"),
                                           buttonLabel = "Wgraj pliki",
                                           placeholder = "Brak pliku",
                                           width = "220px"),
                                 tags$script('
                                     pressedKeyCount = 0;
                                     $(document).on("keydown", function (e) {
                                      Shiny.onInputChange("pressedKey", pressedKeyCount++);
                                      Shiny.onInputChange("key", e.which);
                                      });'),
                                 hr(),
                                htmlOutput("Opis")
                                                     ),
                    mainPanel(
                        plotOutput("distPlot",click="click", height = "672px", hover = "hover")
                    )
                )
)

server <- function(input, output, session) {
    
  
    selected_spotidane <- reactiveValues(    #po prostu zbior wartosci reaktywnych - nie sugeruj sie nazwa
        selected = character(),     #nazwa artysty zebrana przez klikniecie na pierwszym wykresie
        x1  = data_frame(),      #ramka danych tworzona do przedstawienia pierwszego wykresu
        choices  = data_frame(),  #zbior wszystkich artystow, ktorzy byli wyswietlani 
        clicked = numeric(),   #potrzebne do sczytania wspolrzednej y klikniecia mysza na pierwszym wykresie
        click = FALSE, # flaga potrzebna do klikania i odklikiwania artystow - wazna!! decyduje ktory wykres sie wyswietla 
        comeback_possible = FALSE, # do powrotu z drugiego wykresu
        maxvalue = numeric(), #tez do powrotu - okresla polozenie guzika
        begin_date = date("2019-01-01"),   #chyba jasne - paczatkowa data zakresu
        end_date = date("2019-12-31"),   #koncowa
        arrow_index = 0,   #wylicza jaka wartosc nalezy dodać do '1:20' aby byli wyswieltani artysci z zakresu 1+array_index:20+array_index
        keep_range = TRUE,  #czy trzymac zakres skali na pierwszym wykresie
        get_range = TRUE, # czy pobrac zakres skali z pierwszego wykresu
        max_value = numeric(),#potrzebne do okreslenia rozpietosci pierwszego wykresu
        twentieth = numeric(), # do okreslenia na jakiej wysokosci ma byc obrazek
        first_plot = TRUE, #flaga uzyta tylko przy pierwszym wczytywaniu wykresu
        x = FALSE,  #za duzo tych flag, ale dziala - potrzebne bo przy pierwszym wczytaniu plikow zmienia sie daterange, co utrudnia
        window = c(FALSE, TRUE, FALSE), #ktore okno na dole ma sie wyswietlic?
        hover_read = FALSE,   # czy zczytywać dane z hovera - true gdy ma to sens
        hover = c(-0.3, -0.3),  # dane odnosnie myszki
        test = character()
    )
    
    spotidane <-reactiveValues(  #tez nie sugerowac sie nazwa: reaktywne tylko ze inne 
        data = data.frame(),   #ramka danych zawierajaca informacje z wczytanych plikow
        toBind = data.frame()  #tymczasowa ramka wykorzystywana przy wczytywaniu danych
    )
    
    #### obserwatorzy inputow
    observeEvent(input$zima, {
        selected_spotidane$begin_date <- date(format(date("2018-12-22"),"%Y-%m-%d"))
        selected_spotidane$end_date <- date(format(date("2019-03-20"),"%Y-%m-%d"))
        updateDateRangeInput(session, "daterange1", start =  date("2018-12-22"), end = date("2019-03-20"))
        selected_spotidane$arrow_index <- 0
        if(!selected_spotidane$x){
          selected_spotidane$x <- TRUE
        }
        else{
          selected_spotidane$get_range <- TRUE
          selected_spotidane$keep_range <- FALSE
        }
        
    })
    observeEvent(input$wiosna, {
        selected_spotidane$begin_date <- date("2019-03-21")
        selected_spotidane$end_date <- date("2019-06-30")
        updateDateRangeInput(session, "daterange1", start =  date("2019-03-21"), end = date("2019-06-21"))
        selected_spotidane$arrow_index <- 0
        if(!selected_spotidane$x){
          selected_spotidane$x <- TRUE
        }
        else{
          selected_spotidane$get_range <- TRUE
          selected_spotidane$keep_range <- FALSE
        }
    })
    observeEvent(input$lato, {
        selected_spotidane$begin_date <- date(format(date("2019-07-01"),"%Y-%m-%d"))
        selected_spotidane$end_date <- date(format(date("2019-09-30"),"%Y-%m-%d"))
        updateDateRangeInput(session, "daterange1", start =  date("2019-06-22"), end = date("2019-09-22"))
        selected_spotidane$arrow_index <- 0
        if(!selected_spotidane$x){
          selected_spotidane$x <- TRUE
        }
        else{
          selected_spotidane$get_range <- TRUE
          selected_spotidane$keep_range <- FALSE
        }
    })
    observeEvent(input$jesien, {
        selected_spotidane$begin_date <- date("2019-10-01")
        selected_spotidane$end_date <- date("2019-12-31")
        updateDateRangeInput(session, "daterange1", start =  date("2019-09-23"), end = date("2019-12-21"))
        selected_spotidane$arrow_index <- 0
        if(!selected_spotidane$x){
          selected_spotidane$x <- TRUE
        }
        else{
          selected_spotidane$get_range <- TRUE
          selected_spotidane$keep_range <- FALSE
        }
        })
    observeEvent(input$resetdat, {
      selected_spotidane$begin_date <- date("2018-12-01") 
      selected_spotidane$end_date <- date("2020-01-31")
      updateDateRangeInput(session, "daterange1", start =  date("2018-12-01"), end = date("2020-01-31"))
      selected_spotidane$arrow_index <- 0
      if(!selected_spotidane$x){
        selected_spotidane$x <- TRUE
      }
      else{
        selected_spotidane$get_range <- TRUE
        selected_spotidane$keep_range <- FALSE
      }
    })
    
    observeEvent(input$daterange1, {
        selected_spotidane$begin_date <- input$daterange1[1]
        selected_spotidane$end_date <- input$daterange1[2]
        selected_spotidane$arrow_index <- 0
        if(!selected_spotidane$x){
          selected_spotidane$x <- TRUE
          }
        else{
          selected_spotidane$get_range <- TRUE
          selected_spotidane$keep_range <- FALSE
          }
        
    })
    observeEvent(input$pressedKey, {
      
        if(!selected_spotidane$click){
      if(input$key %in% c(38, 40)){
        tmp <- selected_spotidane$arrow_index + input$key -39
        if(tmp >=0){
          selected_spotidane$arrow_index <- tmp
          selected_spotidane$first_plot <- FALSE
           selected_spotidane$get_range <- FALSE
          selected_spotidane$keep_range <- TRUE
        }
      }
          
      }
        else{
            if(input$key == 39){ 
            if(which(selected_spotidane$window)==1){
                selected_spotidane$window <- c(FALSE, TRUE, FALSE)
            }
            else if(which(selected_spotidane$window)==2){
                selected_spotidane$window <- c(FALSE, FALSE, TRUE)
            }
            }
            else if(input$key == 37){
                if(which(selected_spotidane$window)==3){
                    selected_spotidane$window <- c(FALSE, TRUE, FALSE)
                }
                else if(which(selected_spotidane$window)==2){
                    selected_spotidane$window <- c(TRUE, FALSE, FALSE)
                }
            }
        }
        
      })
    
    observeEvent(input$hover,{
      if(selected_spotidane$hover_read){
        selected_spotidane$hover[1] <- input$hover$x
        selected_spotidane$hover[2] <- input$hover$y
      }
    })
    
    observeEvent(input$click,{
        if(!selected_spotidane$click) {#w przypadku gdy wyswietlany jest 1. wykres
            selected_spotidane$click = TRUE
            #zapisanie wykonawcy jaki ma byc wyswietlany w drugim oknie - o ile click$y występuje
            selected_spotidane$clicked[1] <-ifelse(!is.null(input$click$y), input$click$y, selected_spotidane$clicked[1])
        }
        else{#gdy drugi wykres jest wyswietlany, zbieramy klikniecie dla przycisku powróć
            if(which(selected_spotidane$window)==1){
            if(input$click$x>0 && input$click$x<3){
                if(input$click$y<selected_spotidane$maxvalue*1.08 && input$click$y>selected_spotidane$maxvalue*1.02){
                    selected_spotidane$click = FALSE
                    selected_spotidane$window = c(FALSE, TRUE, FALSE) #reset informacji ktory wykres ma byc wyswietlony na drugim poziomie
                }
            }
                
              
            }
            else if(which(selected_spotidane$window)==2){
        
              
            }
            else if(which(selected_spotidane$window)==3){
                
            }
        }
        
      selected_spotidane$first_plot <- FALSE
    })
    ######
    
    ######
    # logika wczytywania plikow
    #
    observeEvent(input$files,{
        tryCatch(
            {
                spotidane$data <- data.frame()
                selected_spotidane$click <- FALSE
                selected_spotidane$arrow_index <- 0
                selected_spotidane$first_plot <- TRUE
                selected_spotidane$window = c(FALSE, TRUE, FALSE)
                for(var in 1:length(input$files$datapath)){
                    if(input$files$type[var] %in% c("text/csv", "application/csv")){
                        spotidane$toBind <-  as.data.frame(as_data_frame(read.csv(input$files$datapath[var])))
                        
                        if(all(colnames(spotidane$toBind) == c("endTime", "artistName", "trackName", "msPlayed"))){
                            spotidane$toBind$endTime <- as.character(spotidane$toBind$endTime)
                            spotidane$toBind$endTime <- substr(spotidane$toBind$endTime, start = 1, stop = nchar(spotidane$toBind$endTime)-3)
                            spotidane$data <- rbind(spotidane$data, spotidane$toBind)
                        }
                    }
                    if(input$files$type[var] %in% c("application/json", "text/json")){
                        spotidane$toBind <- as.data.frame(fromJSON(input$files$datapath[var]))
                        if(all(colnames(spotidane$toBind) == c("endTime", "artistName", "trackName", "msPlayed"))){
                            spotidane$data <- rbind(spotidane$data, spotidane$toBind)
                        }
                    }
                }
                if(nrow(spotidane$data)>0){
                spotidane$data$msPlayed <- spotidane$data$msPlayed/(1000*3600)
                spotidane$data$endTime <- as.character(spotidane$data$endTime)
                #spotidane$data$endTime <- fast_strptime(spotidane$data$endTime, "%Y-%m-%d %H:%M",tz="UTC")
                spotidane$data$endTime <- as.POSIXct(spotidane$data$endTime)
                }
                
            },
            error = function(e) {
                # return a safeError if a parsing error occurs
                stop(safeError(e))
            }
        )
        
    #
    #
    ########
      
    
    #####
    #Wczytywanie obu wykresow - ggplot
      
    output$distPlot <- renderPlot({
        if(!selected_spotidane$click){
            ### gdy nie bylo jeszcze klikniecia - pokazujemy pierwszy wykres
            # wczytanie danych
            selected_spotidane[["x1"]] <- spotidane$data %>%
                filter(endTime >= selected_spotidane$begin_date)%>%
                filter(endTime <= selected_spotidane$end_date)%>%
                group_by(artistName) %>% summarise(uniquesongs = length(unique(trackName)), time = sum(msPlayed)) %>%
                arrange(desc(time)) %>% slice((1:20) + selected_spotidane$arrow_index) %>%
                mutate(artistName = paste0(row_number() + selected_spotidane$arrow_index, ". ", artistName))
            
            if(selected_spotidane$get_range){
              selected_spotidane$max_value = selected_spotidane[["x1"]][["time"]][1] #do trzymania zakresu osi godzin
              selected_spotidane$twentieth = selected_spotidane[["x1"]][["time"]][20]
              }
            x <- selected_spotidane[["x1"]]
            selected_spotidane$choices <- selected_spotidane[["x1"]]$artistName
            if(nrow(selected_spotidane[["x1"]])==0 || is.na(selected_spotidane[["x1"]][["artistName"]])) {#jesli nie mamy zadnych danych
                plot.new()
                text(0.5,0.5,"Wybrany zakres dat nie zwrócił żadnych wyników dla danego pliku")
            }
            else{
            p <- ggplot(selected_spotidane[["x1"]], aes(x=reorder(artistName,-time), y=time)) +
                geom_bar(stat="identity", width=.7,fill="#1D428A")+
                theme_minimal()+
                # geom_text(aes(label = ifelse(time==selected_spotidane$max_value,paste0("Liczba przesłuchanych różnych utworów wykonawcy: ", uniquesongs), uniquesongs)),
                #           size = 4.6, hjust = "top", nudge_y = -0.2, color = "white") +
                theme(axis.text.x = element_text(hjust = 1,size=11),
                      axis.text.y =element_text(size=15))+
                xlab(element_blank())+
                ylab("Liczba przesłuchanych godzin wykonawcy") +
              labs(title = "Ranking najdłużej słuchanych wykonawców") +
                scale_x_discrete(limits = rev(as.factor(x$artistName)), label = function(t) ifelse(nchar(t)>20,
                                                                                                   paste0(substr(t, 1, 20), "..."), t)) +
                coord_flip()
            if(selected_spotidane$first_plot){  #jesli ma sie pojawic obrazek - niech sie pojawi
              z <- p + annotation_raster(clickme, ymin =selected_spotidane$twentieth*1.1,
                                         ymax= selected_spotidane$twentieth*1.1 + selected_spotidane$max_value/6,
                                         xmin =0.7, xmax = 3.7)
            }
            else{z <- p}
            if(selected_spotidane$keep_range){
                z + scale_y_continuous(position = "right", limits = c(0, selected_spotidane$max_value))
            }
            else{
              z + scale_y_continuous(position = "right")
            }
            }
        }
        else{
            #####drugi poziom wykresow (po kliknieciu w pierwszy)
            lvls <- selected_spotidane$choices
            artist <- lvls[21 - round(selected_spotidane$clicked[1])]
            selected_spotidane$selected <- paste(unlist(strsplit(artist, split = " "))[-1], collapse = " ")

            if(which(selected_spotidane$window)==2){
              df <- spotidane$data %>%
                filter(endTime >= selected_spotidane$begin_date) %>%
                filter(endTime <= selected_spotidane$end_date) %>%
                filter(artistName == selected_spotidane$selected)
              df$month <- month(df$endTime,label=TRUE)
              df$month <- fct_rev(factor(df$month))
              df$day <- day(df$endTime)
                
              
              if(nrow(df)==0) {
                plot.new()
                text(0.5,0.5,"Wybrany zakres dat nie zwrócił żadnych wyników dla danego pliku")
              }
              else{
              ggplot(df,aes(x=day,y=month,fill=month))+
                geom_density_ridges(scale = 3, rel_min_height = 0.01) +
                xlab('') +
                ylab('')+
                labs(title = paste0("Częstość słuchania zespołu ", selected_spotidane$selected, " z podziałem na miesiące"), caption = "• 2 •") +
                scale_fill_viridis_d(alpha=0.7,guide='none')+
                scale_y_discrete(expand = c(0.1, 0))+
                theme(legend.position = 'none', axis.title.y = element_blank(),
                      plot.caption = element_text(size = 7))+
                # annotate("text", x = 35, y =  13, label = "• 2 •", size = 7, fontface = "bold") +
                theme_ridges()
              }
              
            }
            ##koniec srodkowego wykresu
            
            ##ten z lewej:
            else if(which(selected_spotidane$window) == 1){
                zwroc_czas <- function(d) {
                    weekday = weekdays(d, abbreviate = TRUE)
                    hour = format(strptime(d,"%Y-%m-%d %H:%M:%S"),'%H')
                    hour = as.numeric(hour) %/% 6 * 6
                    paste0(weekday, " ", hour, ":00")
                }
                y <- spotidane$data %>%
                     filter(endTime >= selected_spotidane$begin_date) %>%
                     filter(endTime <= selected_spotidane$end_date) %>%
                      filter(artistName == selected_spotidane$selected) %>%
                    mutate(pora = zwroc_czas(endTime)) %>%
                    count(pora) %>%
                  mutate(grupa = 1)
                
                y2 <- spotidane$data %>%
                  filter(artistName == selected_spotidane$selected) %>%
                  mutate(pora = zwroc_czas(endTime)) %>%
                  count(pora) %>%
                  mutate(grupa = 2)
                
                selected_spotidane$maxvalue <- max(y2$n)
                
                if(nrow(y)==0 && nchar(y2)==0) {
                    plot.new()
                    text(0.5,0.5,"Wybrany zakres dat nie zwrócił żadnych wyników dla danego pliku")
                }
                else{
                    selected_spotidane$hover_read <- TRUE
                    dayparts <- paste(rep(weekdays(date("2020-01-20") + 0:6, abbreviate = TRUE), each = 4), c("0:00","6:00", "12:00", "18:00"))
                    lackingtimey <-which(!dayparts %in% y[["pora"]])
                    lackingtimey2 <- which(!dayparts %in% y2[["pora"]])
                    y <- rbind(y, data_frame(pora = dayparts[lackingtimey], n = rep(0, length(lackingtimey)), grupa = rep(1, length(lackingtimey))))
                    y2 <- rbind(y2, data_frame(pora = dayparts[lackingtimey2], n = rep(0, length(lackingtimey2)), grupa = rep(2, length(lackingtimey2))))
                    
                    
                    y <- y[match(dayparts, y$pora),]   #aby ramka danych byla w kolejnosci dni tygodnia - przydatne do tooltipa
                    y2 <- y2[match(dayparts, y2$pora),]
                    
                    toplot <- rbind(y2, y)

                    p <- ggplot(toplot, aes(x = factor(pora, dayparts), y = n, group = grupa, colour = factor(grupa, 1:2), fill = factor(grupa, 1:2))) +
                      geom_point(size = 2) +
                      geom_area(data = toplot[toplot$grupa==1,], aes(x = factor(pora, dayparts), y = n, colour = NULL ), alpha = 0.3) +
                      geom_area(data = toplot[toplot$grupa==2,], aes(x = factor(pora, dayparts), y = n, colour = NULL), alpha = 0.1) +
                      geom_line(colour = c(rep("red", 28), rep("gray", 28))) + #ponizej - guzik do powrotu do pierwszego wykresu
                      annotate("text", x = 1.5, y =  selected_spotidane$maxvalue*1.05, label = "bold(Powróć)", parse = TRUE)+
                      annotate("segment", x=0, xend = 3, y = selected_spotidane$maxvalue*1.08, yend = selected_spotidane$maxvalue*1.08) +
                      annotate("segment", x=0, xend = 3, y = selected_spotidane$maxvalue*1.02, yend = selected_spotidane$maxvalue*1.02) +
                      annotate("segment", x=0, xend = 0, y = selected_spotidane$maxvalue*1.08, yend = selected_spotidane$maxvalue*1.02) +
                      annotate("segment", x=3, xend = 3, y = selected_spotidane$maxvalue*1.08, yend = selected_spotidane$maxvalue*1.02) +
                      theme_minimal()+
                      theme(axis.text.x = element_text(hjust = 0.8),
                            legend.position = c(0.85, 0.85),
                            legend.title = element_blank(),
                            plot.caption = element_text(size = 12, hjust = 0.98))+
                      labs(title = paste0(selected_spotidane$selected, " - liczba odtworzeń w ciągu tygodnia"),  caption = "1 • •") +
                      ylab("Liczba odtworzeń") +
                      xlab(element_blank()) +
                      scale_x_discrete(breaks = paste(weekdays(date("2020-01-20") + 0:6, abbreviate = TRUE), "12:00"),
                                       limits = dayparts,
                                       labels = weekdays(date("2020-01-20") + 0:6)) +
                      scale_color_manual(values = c("red", "gray"), labels = c("Wybrany zakres dat", "Wszystkie dostępne daty")) +
                      scale_fill_manual(values = c("red", "gray"), labels = c("Wybrany zakres dat", "Wszystkie dostępne daty"))
                      # annotate("text", x = 25, y =  selected_spotidane$maxvalue*1.05, label = "1 • •", size = 7, fontface = "bold")
                     
                    
                  
                    
                    ###robienie tooltipa: 
                    
                     readY <- which(abs(as.vector(toplot[c(round(selected_spotidane$hover[1]),  round(selected_spotidane$hover[1]) + 28), 2]) -
                               selected_spotidane$hover[2]) < selected_spotidane$maxvalue/15)
                    
                     readX <- ifelse(abs(selected_spotidane$hover[1] - round(selected_spotidane$hover[1]))<0.2, round(selected_spotidane$hover[1]) %% 29, -1)
                     if(readX>0 && length(readY)>0){
                       rectY <- ifelse(1 %in% readY, toplot[round(selected_spotidane$hover[1]), 2], toplot[round(selected_spotidane$hover[1]) + 28, 2])
                       rectY <- as.numeric(rectY)
                       if(2 %in% readY){
                         # pokazujemy wartosc dla wybranego zakresu
                         topartist <- spotidane$data %>%
                           filter(endTime >= selected_spotidane$begin_date) %>%
                           filter(endTime <= selected_spotidane$end_date) %>%
                           filter(artistName == selected_spotidane$selected) %>%
                           mutate(pora = zwroc_czas(endTime)) %>%
                           filter(pora == as.character(toplot[readX, 1])) %>%
                           count(trackName) %>%
                           arrange(desc(n)) %>%
                           slice(1) %>% pull(trackName)
                         selected_spotidane$test <- topartist
                       p + annotate("rect", xmin = ifelse(readX>22, 22, readX), ymin = rectY,
                                    xmax = ifelse(readX>22, 22, readX)+6, ymax = rectY + selected_spotidane$maxvalue/6, alpha = 0.2) +
                         annotate("text", x = ifelse(readX>22, 22, readX)+3, y = rectY + selected_spotidane$maxvalue/12, label = paste("Najczęściej słuchany", "utwór w:",
                                                                                                                                  paste0(unlist(strsplit(as.character(toplot[readX, 1]), " "))[1],", ",
                                                                                                                                  unlist(strsplit(unlist(strsplit(as.character(toplot[readX, 1]), " "))[2], ":"))[1], "-",
                                                                                                                                  as.numeric(unlist(strsplit(unlist(strsplit(as.character(toplot[readX, 1]), " "))[2], ":"))[1]) + 6),
                                                                                                                                  #unlist(strsplit(unlist(strsplit(as.character(toplot[readX+1, 1]), " "))[2], ":"))[1]),
                                                                                                                                 ifelse(nchar(topartist)>20,
                                                                                           paste0(substr(topartist, 1, 18), "..."),
                                                                                           topartist),
                                                                                    sep = "\n"))
                       }
                       else{
                         topartist <- spotidane$data %>%
                           filter(artistName == selected_spotidane$selected) %>%
                           mutate(pora = zwroc_czas(endTime)) %>%
                           filter(pora == as.character(toplot[readX, 1])) %>%
                           count(trackName) %>%
                           arrange(desc(n)) %>%
                           slice(1) %>% pull(trackName)
                         selected_spotidane$test <- topartist
                         p + annotate("rect", xmin = ifelse(readX>22, 22, readX), ymin = rectY,
                                      xmax = ifelse(readX>22, 22, readX)+6, ymax = rectY + selected_spotidane$maxvalue/7, alpha = 0.2)+
                           annotate("text", x = ifelse(readX>22, 22, readX)+3, y = rectY + selected_spotidane$maxvalue/14, label = paste("Najczęściej słuchany", "utwór w:",
                                                                                                                                         paste0(unlist(strsplit(as.character(toplot[readX, 1]), " "))[1],", ",
                                                                                                                                                unlist(strsplit(unlist(strsplit(as.character(toplot[readX, 1]), " "))[2], ":"))[1], "-",
                                                                                                                                                as.numeric(unlist(strsplit(unlist(strsplit(as.character(toplot[readX, 1]), " "))[2], ":"))[1]) + 6),
                                                                                                                                                #unlist(strsplit(unlist(strsplit(as.character(toplot[readX+1, 1]), " "))[2], ":"))[1]),                                                                                                                   ifelse(nchar(topartist)>20,
                                                                                               ifelse(nchar(topartist)>20,
                                                                                               paste0(substr(topartist, 1, 18), "..."),
                                                                                               topartist),
                                                                                        sep = "\n"))
                       }
                     }
                     else{
                      p
                    }
                }
                
            }
            ###koniec lewego wykresu
            
            
            ##poczatek prawego wykresu Jacy
            else if(which(selected_spotidane$window) == 3){
              df <- spotidane$data %>%
                filter(endTime >= selected_spotidane$begin_date) %>%
                filter(endTime <= selected_spotidane$end_date) %>%
                filter(artistName == selected_spotidane$selected) %>%
                mutate(endTime = as.Date(endTime)) %>%
                group_by(trackName, endTime) %>% summarise(count = length(trackName), time = sum(msPlayed)) %>%
                arrange(desc(time)) %>% ungroup() %>% mutate(trackName = factor(trackName, unique(trackName)))
              temp <- df %>% group_by(trackName) %>% summarise(count = sum(time)) %>% arrange(desc(count)) %>% slice(1:10)
              df <- df %>% filter(trackName %in% temp$trackName)
              
              selected_spotidane$maxvalue[1] <- min(df$endTime)
              selected_spotidane$maxvalue[2] <- max(df$endTime)
              
              if(nrow(df)==0) {
                plot.new()
                text(0.5,0.5,"Wybrany zakres dat nie zwrócił żadnych wyników dla danego pliku")
              }
              else{
                
              ggplot(df, aes(x=endTime, y=trackName, fill = trackName)) +
                geom_joy(scale=2, alpha = 0.8) +
                scale_fill_manual(values=rep(c('#9ecae1', '#3182bd'), length(unique(df$trackName))/2)) +
                scale_y_discrete(expand = c(0.01, 0), labels = function(d){label = ifelse(nchar(d)>17, paste0(substr(d, 1, 17), "..."), d)}) +
                xlab('') +
                theme_joy() +
                labs(title = "Częstość słuchania utworów", caption = "• • 3") +
                theme(legend.position = 'none', axis.title.y = element_blank(),
                      plot.caption = element_text(size = 12)) 
                  
                #annotate("text", x = selected_spotidane$end_date, y =  10.5, label = "• • 3", size = 7, fontface = "bold")
              }
            }
            
        }
    })
    })
    
    output$Opis <- renderUI({
        req(input$files)
        if(!selected_spotidane$click){
        HTML(paste("WSKAZÓWKA:", "Użyj strzałek na klawiaturze", "   - sprawdź co się stanie!", sep="<br/>"))
        }
        else{
          if(selected_spotidane$window[1]){HTML(paste("WSKAZÓWKA:", "Aby dowiedzieć się więcej,", "najedź na punkt", sep="<br/>"))} #dla wykresu Pawła
          else{HTML(paste("WSKAZÓWKA:", "Użyj strzałek na klawiaturze", "   - tym razem na boki!", sep="<br/>"))}
        }
    })
    
   
}


shinyApp(ui = ui, server = server)


