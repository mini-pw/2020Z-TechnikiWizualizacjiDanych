options(stringsAsFactors = FALSE)

library(shiny)
library(dplyr)
library(ggplot2)
library(reshape2)
library(shinythemes)
library(dqshiny)
library(hrbrthemes)
library(plotly)
library(viridis)


genre_year_count<-read.csv("./year_genre.csv", sep=",", stringsAsFactors = FALSE)
top5000words<-colnames(genre_year_count)[4:5003]
word_count<-readRDS("./word_count.RDS")

words70 <- c("love", "like", "baby", "time", "never",
             "man", "day", "life", "night", "world",
             "people", "heart", "give", "woman", "sweet",
             "soul", "alone", "rain", "face", "friend",
             "believe", "town", "music", "good", "dreams",
             "money", "song", "end", "because", "real",
             "dead", "child", "hope", "brother", "father",
             "eye", "street", "game", "fire", "fear",
             "darling", "spirit", "pain", "lady", "moon",
             "mirror", "blood", "war", "fame", "sister",
             "heaven", "win", "brain", "happiness", "kiss",
             "jesus", "trust", "magic", "kill", "hate",
             "luck", "mercy", "devil", "church", "sex",
             "sorry", "hatred", "pony", "idea", "problem")

genre_year_count70 <- genre_year_count %>%
  select(c("year0", "genre0", "all_songs", words70))

### funkcje

whichpart <- function(x, n = 5){
  nx <- length(x)
  p <- nx - n
  xp <- sort(x, partial=p)[p]
  return(which(x>xp))
}


ui <- fluidPage(
  theme=shinytheme("united"),
  titlePanel("Lyrics analisys"),
  tabsetPanel(
    tabPanel(
      title="Know your lyrics",
      h2("Explore the database of lyrics by specific word or genre"),
      fluidRow(
        width = 3,
        sidebarPanel(
          autocomplete_input(id="word_chosen", label="Choose a word", options=top5000words,
                             value="love", max_options = 20),
          selectInput(inputId = "plot_type", label="Choose type of plot", choices = c("Heatmap", "Line", "Smooth"),
                      selected = "Heatmap"),
          conditionalPanel(
            condition = "input.plot_type != 'Heatmap'",
            checkboxGroupInput("genre_plot", 
                               h3("Choose genre:"), 
                               choices = list("Country",
                                              "Electronic",
                                              "Folk",
                                              "Hip-Hop",
                                              "Indie",
                                              "Jazz",
                                              "Metal",
                                              "Pop",
                                              "R&B",
                                              "Rock"),
                               selected = c("Country","Metal", "Rock", "Pop"))
          )
        ),
        mainPanel(
          conditionalPanel(
            condition = "input.plot_type == 'Heatmap'",
            plotlyOutput(outputId = "word_plotly")
          ),
          conditionalPanel(
            condition = "input.plot_type != 'Heatmap'",
            plotOutput(outputId = "word_plot")
          )
          
        )
      ),
      fluidRow(
        width=3,
        sidebarPanel(
          h3("Wanna know more about this word?"),
          selectInput(inputId = "genre_type", label="Choose genre", 
                      choices=c("Country",
                                "Electronic",
                                "Folk",
                                "Hip-Hop",
                                "Indie",
                                "Jazz",
                                "Metal",
                                "Pop",
                                "R&B",
                                "Rock"), 
                      selected="Pop"),
          sliderInput("years_table",
                      label="Chose period",
                      min = as.Date("1970","%Y"),
                      max = as.Date("2016","%Y"),
                      value=c(as.Date("1970", "%Y"),as.Date("2016", "%Y")),
                      timeFormat="%Y")),
        mainPanel(
          h3("Songs sorted by occurrence"),
          tableOutput(outputId = "about_word1"))
      )
    ),
    tabPanel(
      title="Most popular words",
      h2("What words are most often used in different times and genres?"),
      fluidRow(
        width=3,
        sidebarPanel(
          sliderInput("years",
                    label="Chose period",
                    min = as.Date("1970","%Y"),
                    max = as.Date("2016","%Y"),
                    value=c(as.Date("1970", "%Y"),as.Date("2016", "%Y")),
                    timeFormat="%Y"),
          h4("The presented word come from a set of 70 popular,interesting English words."),
          h4("The most common ones like 'I' , 'you' or 'am' were excluded.")
        
      ),
      mainPanel(
        plotOutput("lyrics_plot" ,click = "lyrics_click")
      )
      )
    )
  )
)







server <- function(input, output) {
  output$word_plotly<-renderPlotly({
    genre_year_to_plot<-genre_year_count%>%select(year0,genre0,input$word_chosen) %>%
      setNames(c("Year", "Genre", "Occurrence")) %>%
      mutate(Year = as.numeric(Year), Occurrence = as.double(Occurrence))
    
    genre_year_to_plot <- genre_year_to_plot %>%
      mutate(text = paste0(Genre, "\n", Year, "\n", "Occurrence: ",round(Occurrence,2), "%"))
    
    # classic ggplot, with text in aes
    # p <- ggplot(genre_year_to_plot, aes(Year, Genre, fill= Occurrence)) + 
    #   geom_tile() +
    #   scale_fill_gradient(low="white", high="blue") +
    #   theme_ipsum() +
    #   ggtitle(input$word_chosen)
    plot_ly(data = genre_year_to_plot,
            zmin = 0,
            zmax = 100,
            x= ~Year,
            y= ~Genre,
            z= ~Occurrence,
            colors=viridis::magma(100),
            reversescale =T,
            hoverinfo = 'text',
            text = ~text,
            type ='heatmap'
    )
    
  })
  
  output$word_plot<-renderPlot({
    
    word_chosen<-input$word_chosen
    genre_year_to_plot<-genre_year_count%>%select(year0,genre0,word_chosen)%>%
      dcast(year0 ~ genre0)%>%
      mutate_at(vars(-year0),as.numeric)
    plot_to_draw<-ggplot(genre_year_to_plot,aes(x=year0))
    
    if(input$plot_type=="Line"){
      if( "Country" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_line(aes(y=Country, color="Country"))
      if( "Electronic" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_line(aes(y=Electronic, color="Electronic"))
      if( "Folk" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_line(aes(y=Folk, color="Folk"))
      if( "Hip-Hop" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_line(aes(y=`Hip-Hop`, color="Hip-Hop"))
      if( "Indie" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_line(aes(y=Indie, color="Indie"))
      if( "Jazz" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_line(aes(y=Jazz, color="Jazz"))
      if( "Metal" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_line(aes(y=Metal, color="Metal"))
      if( "Pop" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_line(aes(y=Pop, color="Pop"))
      if( "R&B" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_line(aes(y=`R&B`, color="R&B"))
      if( "Rock" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_line(aes(y=Electronic, color="Rock"))
      
    }
    else{
      if( "Country" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_smooth(aes(y=Country, color="Country"))
      if( "Electronic" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_smooth(aes(y=Electronic, color="Electronic"))
      if( "Folk" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_smooth(aes(y=Folk, color="Folk"))
      if( "Hip-Hop" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_smooth(aes(y=`Hip-Hop`, color="Hip-Hop"))
      if( "Indie" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_smooth(aes(y=Indie, color="Indie"))
      if( "Jazz" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_smooth(aes(y=Jazz, color="Jazz"))
      if( "Metal" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_smooth(aes(y=Metal, color="Metal"))
      if( "Pop" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_smooth(aes(y=Pop, color="Pop"))
      if( "R&B" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_smooth(aes(y=`R&B`, color="R&B"))
      if( "Rock" %in% input$genre_plot) plot_to_draw<-plot_to_draw+geom_smooth(aes(y=Electronic, color="Rock"))
      
    }
    plot_to_draw+
      ggtitle(word_chosen)+
      labs(color="Genre")+
      # ylim(0.00,100.00)+
      xlab("Year")+
      ylab("Songs in year")+
      scale_y_continuous(limits=c(0,100),
                         #breaks=c(0,10,20,30, 40,50, 60,70,80,90,100),
                         breaks=c(0,25,50,75,100),
                         labels=c("0%", "25%", "50%", "75%", "100%")
                         #labels=c("0%","10%", "20%","30%","40%", "50%","60%", "70%","80%", "90%", "100%")
                         )+
      theme(
        axis.text = element_text(size=11),
        axis.title = element_text(size=12, face="bold"),
        axis.ticks.x =element_blank(),
      )
    
  })
  
  output[["about_word1"]] <- renderTable({
    year_min<-as.integer(substr(as.character(input[["years_table"]][1]),1,4))
    year_max<-as.integer(substr(as.character(input[["years_table"]][2]),1,4))
    # 
    # song_info <- get5songs(word_count, input$word_chosen)
    # colnames(song_info)<-c("Title", "Artist", "Genre", "Year of Release", "Occurences of word")
    # 
    # return(song_info)
    
    song_info<-word_count%>%
      filter(genre0==input$genre_type, year0>=year_min, year0<=year_max)%>%
      select(song0, artist0, genre0, year0, input$word_chosen)
    
    order_word<-order(song_info[[5]], decreasing = TRUE)
    
    song_info<-song_info[order_word,]%>%
      slice(1:10)
    colnames(song_info)<-c("Title", "Artist", "Genre", "Year of Release", "Occurrences of word")
    # print(dim(song_info))
    return(song_info)
  })
  
  update_lyrics<-reactive({
    
    year_min<-as.integer(substr(as.character(input[["years"]][1]),1,4))
    year_max<-as.integer(substr(as.character(input[["years"]][2]),1,4))
    res <- data.frame(rep(list(rep(NA, times = 50)), times = 3))
    colnames(res) <- c("genre0","variable", "value")
    
    lyrics<- genre_year_count70%>%
      filter(year0 >= year_min & year0 <= year_max)
    l <- 0
    # dla kazdego gatunku wyznacza 5 najczestszych slowek:
    for(genre in unique(lyrics$genre0)){
      # srednia wazona(dlugo sie robi):
      aux2 <- lyrics %>% filter(genre0 == genre)
      suma = sum(aux2$all_songs)
      aux2[,4:ncol(aux2)] <- aux2[,4:ncol(aux2)]*aux2$all_songs
      aux2 <- aux2 %>% group_by(genre0) %>% summarise_all(sum)
      aux2 <- aux2[1,4:ncol(aux2)]/suma
      # wybiera 5 najczestszych slowek dla danego gatunku wzgledem sredniej wazonej:
      aux2 <- aux2[,whichpart(as.numeric(aux2), 5)]
      
      
      # uzupelnianie wynikowej ramki danych:
      for(i in 1:5){
        res[,1][i+l] <- genre
        res[,2][i+l] <- colnames(aux2)[i]
        res[,3][i+l] <- as.numeric(aux2[1,])[i]
      }
      l = l + 5
      
    }
    return(res)
    
  })
  
  output[["lyrics_plot"]]<-renderPlot({
    
    ggplot(data=update_lyrics(), aes(x=genre0, y=value, label=variable))+
      geom_text(aes(color=variable),size=5)+
      labs(title="5 Most Popular Words", x="Genre", y="% of songs using this word")+
      ylim(0,100)+
      theme(panel.border = element_blank(),
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            axis.ticks.x =element_blank(),
            axis.text = element_text(size=11),
            title = element_text(size=15, face="bold", hjust=0.5),
            plot.title = element_text(hjust = 0.5),
            legend.position = "none")+
      ylab("Songs in year")+
      scale_y_continuous(limits=c(0,100),
                         breaks=c(0,25,50,75,100),
                         labels=c("0%", "25%", "50%", "75%", "100%")
                         )
    
    
  })
}


shinyApp(ui = ui, server = server)
