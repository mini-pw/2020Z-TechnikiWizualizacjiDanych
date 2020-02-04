


library(shiny)
library(shinydashboard)
library(lubridate)
library(DT)
library(dplyr)
library(plotly)
library(tidyverse)
library(ggplot2)
library(shinythemes)
library(magrittr)
library(shinyWidgets)


ui <- fluidPage( setBackgroundColor('rgb(239,237,245)'),
 
  tags$style(type="text/css",
             ".shiny-output-error { visibility: hidden; }",
             ".shiny-output-error:before { visibility: hidden; }"
  ),
  


           
  
  fluidRow(
    column(4,
           selectInput("select","Time step", 
                       choices = list("10 Year" = 1, "Year" = 2,
                                      "All time" = 3), selected = 2)),
    column(2,offset = 1, titlePanel("Movie Box Office"))),

    fluidRow(
    uiOutput("go_buttons"),
    plotOutput("timeline",click='myclick',height = 60)
    ),
  
  br(),
  br(),
  br(),
  br(),
 
  plotlyOutput("films_boxoffice"), 
  br(),
  #plotlyOutput("film_rb"),
  br(),
  br(),
  br(),
  
  plotlyOutput("prod"),
  br(),
  br(),
  uiOutput("Slider"),
  br(),
  
  #sliderInput("minprize", "Only films with absolutely box ofice greater than: ", min = 0, max = 10^9, value = 50*10^6, step = 10^6),
  fluidRow(
    splitLayout(cellWidths = c("50%", "50%"), dataTableOutput("tbl"), htmlOutput("instruction"))
  ),
  br(),
  br(),
  br(),
  br(),
    fluidRow(
      plotlyOutput("hisProf")
    ),
  #plotOutput("hisProf")
           )
  #### WSTĘPNE PRZYGOTOWANIE DANYCH ####
# Month calculating Function 
monnb <- function(d) { 
lt <- as.POSIXlt(as.Date(d, origin="1900-01-01"))
lt$year*12 + lt$mon } 
dane <-  read.csv2("data_layer1.csv")
dane2<- dane
dane1<- select(dane,c(2,3,4,5))
dane1$release_date <- as.Date( dane1$release_date,"%d/%m/%Y")
dane$release_date <- as.Date( dane$release_date,"%d/%m/%Y")
dane<- dane [,-1]
dane$profit <- floor(dane$revenue/2.4 - dane$budget)
daneMiki <- dane[,c(5,6,3,2,4,1)]
dane <- dane[,c(5,6,3,2)]
dane1$profit <- floor(dane1$revenue/2.4 - dane1$budget)
daneMiki <- daneMiki[ order( daneMiki$profit, decreasing = TRUE),]
daneMiki$groupProfit <- cut( daneMiki$profit, c(-10^(4:1*2+1), 10^(1:4*2+1)), 
                             labels = c( "[-10^9, -10^7)", "[-10^7, -10^5)","[-10^5, -10^3)", "[-10^3, 10^3)","[10^3, 10^5)", "[10^5, 10^7)", "[10^7, 10^9)"))

#do koloru textu na wykresie o filmach
d <- list(
  family = "sans serif",
  size = 16,
  color = "black")

server <- function(input, output, session) {
  
  output$go_buttons <- renderUI({
    
    
    #Setting beggin and end date
    

    begin_date <- "1980-01-01"
    end_date <- "2016-12-31"
    # Selecting data range and calculating buttons number by selected time step 
    # By 10 Year ####
   
    
    number_of_buttons <- 5
    if (input$select== 1){

      Buttons_n <<- c("1980-1989","1990-1999","2000-2009","2010-2016")
      
    }
    #By Year####
    
    if (input$select==2){
     
      number_of_buttons <- ceiling(abs(time_length(interval(as.Date(end_date), as.Date(begin_date)), "years")))
      #Buttons Names
      
      Buttons_n <<- c(1:number_of_buttons)
      d <- as.Date(begin_date)
      Buttons_n[1] <<- substring(begin_date,1,4)
      for (i in 2:number_of_buttons){
        year(d) <- year(d)+1
        Buttons_n[i] <<- substring(as.character(d),1,4)
      }
    }
    #### BY all time ####
    if (input$select==3){
      Buttons_n <<- "1980-2016"
      
    }
   
  
    # Generowanie osi czasu ####
    
    #timeline1 <<- as.data.frame(cbind("v2"=Buttons_n,"v1"=1))
    
    timeline1 <- reactiveValues(dane=as.data.frame(cbind("v2"=Buttons_n,"v1"=1,cold=rep("1",length(Buttons_n)))))
    

    
  
    observeEvent(input$myclick,{
      
      x <- input$myclick$x
      y <- input$myclick$y
      
      i <- floor(x-0.5)+1
      if (x<0.5){i <-  1  }
      if (i>length(Buttons_n)){i <- length(Buttons_n)} 
      cold=rep("1",length(Buttons_n))
      cold[i] <- "2"
      timeline1$dane <- ((dane=as.data.frame(cbind("v2"=Buttons_n,"v1"=1,cold))))
      
      

      
      
    })
  
   
      
     
      output$timeline <- renderPlot({
        
        if (input$select!=3){
        p = ggplot(timeline1$dane,aes(x=v2,y=v1,fill=cold))+geom_bar(stat="identity",width = 0.98)+theme_void()+scale_y_discrete(limits = c(0,1))+scale_fill_manual(values=c("#56B4E9","darkblue"))+
          theme(legend.position = "none",
                text = element_text(face="bold",colour ="white"),
                plot.background = element_rect(fill = '#EFEDF5', color = '#EFEDF5', size = 0))+geom_text(aes(label=v2),size=5,vjust=2.5,color ="white",face="bold")
        p
        }
        else{
          p = ggplot(timeline1$dane,aes(x=v2,y=v1,fill="red"))+geom_bar(stat="identity",width = 0.98)+theme_void()+scale_fill_manual(values="#56B4E9")+
            theme(legend.position = "none",
                  text = element_text(face="bold"),
                  plot.background = element_rect(fill = '#EFEDF5', color = '#EFEDF5', size = 0))+geom_text(aes(label=v2),size=6,vjust=1.98,color ="white",face="bold")
          p
        }
      })
      

   
    buttons <- as.list(1:number_of_buttons)
    # PRZYGOTOWANIE DANYCH ####
          observeEvent(input$myclick,{
          # Prepering Table to show 
          # For Year selection 
            #### TODO poprwa kolory 
          x <- input$myclick$x
          y <- input$myclick$y
          ##### TEKST #####
          output$instruction <- renderUI({
            HTML(paste("<font size='6'>",
                       "This application is used to find the most profitable movies as well",
                       "as the best earning film studios from the beginning of the 80's",
                       "until 2016.The financial summary is available on an annual,",
                       "ten-year and full-time perspective.The time interval can be adjusted",
                       "by using the panel in the upper left-hand corner. Then select on",
                       "axis interval of interest. To search for films with revenues larger",
                       "than the desired value,use the slider on the left.",
                       "</font>",
                       sep="<br/>"))
            })
         
          
          if (input$select == 2){
            ##Data reading 

            i <- floor(x-0.5)+1
            if (x<0.5){i <-  1  }
            if (i>length(Buttons_n)){i <- length(Buttons_n)}
           
            dane_button <- dane %>% filter(Buttons_n[i]==as.character(year(as.Date(release_date,"%d/%m/%Y"))))
            dane_button <- dane_button %>% arrange(desc(profit)) #%>% slice(1:10)
            begin <-  as.Date((paste0(Buttons_n[i],"-01-01")),"%Y-%m-%d")
            end <- as.Date(paste0(Buttons_n[i],"-12-31"),"%Y-%m-%d")
          }
          
          
          if (input$select == 1 ) { 
          
              i <- floor(x-0.5)+1
              if (x<0.5){i <-  1  }
              if (i>length(Buttons_n)){i <- length(Buttons_n)}
              
            start1 <- as.numeric(substring(Buttons_n[i],1,4))
            end1 <- as.numeric(substring(Buttons_n[i],6))
          
            dane_button <- dane %>% filter(start1<=as.numeric(year(as.Date(dane$release_date,"%d/%m/%Y"))) & as.numeric(year(as.Date(dane$release_date,"%d/%m/%Y")))<=end1 )
            dane_button
            dane_button <- dane_button %>% arrange(desc(profit)) #%>% slice(1:10)
            begin <-  as.Date(paste0(start1,"-01-01"),"%Y-%m-%d")
            end <- as.Date(paste0(end1,"-12-31"),"%Y-%m-%d")
            
          }  
          if (input$select==3 ){
            
            dane_button <- dane %>% arrange(desc(profit))# %>% slice(1:10)
            begin <-  as.Date("1980-01-01","%Y-%m-%d")
            end <- as.Date("2016-12-31","%Y-%m-%d")
          }
          
          
          ## GENEROWANIE DANYCH  NWM KTÓRE CZYJE ŻADNIE NIE MOJE J.B. ###################################################
     
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
          
          # TABELA MIKOŁAJ #####  
          # Prepering Month Selection
          sketch <- htmltools::withTags(table(
            class = 'display',
            thead(
              tr(
                
                th(colspan = 5, paste0("Most Profitable Movie : ",dane_button[1,1]))
                ),
              tr(
                th("Title"),
                th("Profit in $"),
                th("Release Date"),
                th("Production Company")
              )
            )
          ))
          output$titlet_layer2 <- renderText({paste0("Time form ",as.character(begin)," to ",as.character(end))})
          output$tbl = renderDataTable({
            # Prepering tabel titel 

        
          datatable(dane_button, container = sketch, rownames = FALSE,filter = "none") %>%formatStyle(columns = "profit", target = "row", backgroundColor = "#F7080880")
          
          })
          ##### SLIDER #####
          output$Slider<-renderUI({
            sliderInput("minprize", "Only films with profit greater than: ", min = min(dane_button$profit),
                        max = max(dane_button$profit)-1000000, value = 50*10^6
                        ,step = 10^6)
          })
          

          ##### WYKRES MIKOŁAJ ####
          data_period_r <- reactive({
            
            daneMiki %>%
              arrange( desc( profit)) %>%
              filter( release_date >= as.Date( begin) ) %>%
              filter( release_date <= as.Date( end) ) %>%
              filter( abs( profit) > input$minprize)
          })
          
       
          
          
          output$films_boxoffice <- renderPlotly({
            
            t <- list(
              family = "sans serif",
              size = 14,
              color = toRGB("grey50"))

            s = input$tbl_rows_selected
            
            d <- data_period_r()
            if (length(s)){
              d <- d[ s,]
            }
            
            #size_v = rep(1, length( data_period_r()[,1]))
            #if (length(s)){
            #  size_v[ s]<- 20
            #}
            
            
            plot_ly( data = d, x = ~release_date, y = ~profit,
                        text = ~title,
                        hovertemplate = paste('<b>%{text}</b><br>',
                                              '<i>Profit</i>: $%{y}<br>',
                                              '<i>Release date</i>: %{x}<br>'
                        )
            ) %>%
              layout(
                #nazwy osi
                title = list(text="Movie in selected time",x=0.5,y=0.98,font=d),
                yaxis = list( title = "Box office"),
                xaxis = list( title = "Release date", range = c(begin, end)),
                showlegend = FALSE,
                plot_bgcolor='rgb(239,237,245)',
                paper_bgcolor='rgb(239,237,245)' #
              ) %>%
              add_segments( xend = ~release_date, yend = 0) %>%
              add_trace(mode = 'markers') %>%
              add_text(textfont = t, textposition = "top right")
            
            
          })         
          
          #producenci######
          
            set1<-c("#f9ca24",
                    "#f0932b",
                    "#eb4d4b",
                    "#6ab04c",
                    "#c7ecee",
                    "#22a6b3",
                    "#be2edd",
                    "#4834d4",
                    "#130f40",
                    "#535c68")
            output$prod<- renderPlotly({
              plot_ly(dane2,x = ~release_date,y = ~suma, type = "scatter", mode = "lines",color =~production_companies,colors = set1 ) %>%
                layout(title = list(text=paste("10 most profitable movie studios",begin,"-",end,sep = " "),x=0.5,y=0.98,font=d),
                       xaxis = list(title = ""),
                       yaxis = list(title = "Profit $"),
                       plot_bgcolor='rgb(239,237,245)',
                       paper_bgcolor='rgb(239,237,245)' ,
                       legend = list(orientation = "h",   
                                     xanchor = "center",  
                                     x = 0.5))
                
            })
          ##### HISTOGRAM #####
          output$hisProf <- renderPlotly({
            
            p2 <- plot_ly(data=dane_button,x = ~profit,
                          type = "histogram") %>% 
              layout(
                plot_bgcolor='rgb(239,237,245)',
                paper_bgcolor='rgb(239,237,245)' ,
                     xaxis = list(title = "Movies profit",
                                  zeroline = FALSE),
                     yaxis = list(title = "Count",
                                  zeroline = FALSE))
            # w  <- ggplot(dane_button, aes(x=profit)) + 
            #   geom_histogram() + xlab("Profit $")+theme_minimal()
            # w <- ggplotly(w)
            # 
            # 
             
            t <- list(
              family = "sans serif",
              size = 14,
              color = toRGB("grey50"))

            s = input$tbl_rows_selected

            d <- data_period_r()
            if (length(s)){
              d <- d[ s,]
            }

            end_polot <- min( c( max( d$budget), max( d$revenue / 2.4)))

            p<- plot_ly( data = d, x = ~budget, y = ~revenue,
                         text = ~title,
                         hovertemplate = paste('<b>%{text}</b><br>',
                                               '<i>Revenue</i>: $%{y}<br>',
                                               '<i>Budget</i>: %{x}<br>'
                         )
            ) %>%
              layout(
                #nazwy osi
                yaxis = list( title = "Revenue"),
                xaxis = list( title = "Budget"),
                showlegend = FALSE,
                plot_bgcolor='rgb(239,237,245)',
                paper_bgcolor='rgb(239,237,245)' 
              ) %>%
              add_segments( x = 0, y = 0, xend = end_polot, yend = end_polot *2.4)%>%
              add_trace( name = ' ', mode = 'markers')

            
            rsult <- subplot(p2,p,titleY = TRUE,titleX = TRUE)
            rsult %>% layout(annotations = list(
             
              list(x = 0.2 , y = 1.05, text = "Histogram of movies profit count",showarrow = F, xref='paper', yref='paper',font = list(size = 16)),
              list(x = 0.7 , y = 1.05, text = "Revenue vs Budget", xref='paper',showarrow = F ,yref='paper',font = list(size = 16)))
            )
          
          })
        })
        
     
        
      
})
  
}


shinyApp(ui, server)

