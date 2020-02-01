library(r2d3)
library(shiny)
library(reshape2)
library(dplyr)
library(shinyBS)
load("/tmp/mozilla_pawel0/dragons.rda")



ui <- fluidPage(

    titlePanel("Wyszukaj swojego własnego smoka!"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("birthyear",
                        "Wybierz datę urodzenia smoków:",
                        min = -2000,
                        max = 1800,
                        value = c(-2000, 1900)),
            checkboxGroupInput("checkGroup", 
                               h3("Wybierz kolory interesujących Cię smoków:"), 
                               choices = list("Czarny" = "black", 
                                              "Niebieski" = "blue",
                                              "Zielony" = "green",
                                              "Czerwony" = "red"),
                               selected = c("black", "blue", "green", "red")),
            h3("Kilka słów o projekcie:"),
            p("Użytkownik w prosty sposób - za pomocą suwaka - może wybrać interesujący go przedział
              lat urodzeń smoków. Ponadto widzi podział smoków względem kolorów na różnych wykresach - jest w stanie wybierać
              interesujące go kolory. Aplikacja udostępnia również tooltipy - po najechaniu kursorem na kropkę na wykresie
              w oknie tekstowym wyświetlane są informacje o określonym stworzeniu.")
            
        ),

        mainPanel(
                   titlePanel(title = ""),
                   verbatimTextOutput("info"),
                   plotOutput(outputId = "hjckghcjydtjgcj", height = "600px", hover = "plot_hover")
                   
)
))

server <- function(input, output) {
  
  
  
  birthYears <- reactiveValues(
    years = numeric(),
    color = character()
  )
  
  observeEvent(c(input[["birthyear"]][1], input[["birthyear"]][2], input[["checkGroup"]], input[["plot_hover"]]), {
    birthYears[["years"]] <- c(input[["birthyear"]][1], input[["birthyear"]][2])
    birthYears[["color"]] <- input[["checkGroup"]]
  })
  
  
  
  
  
  output[["hjckghcjydtjgcj"]] <- renderPlot({
    
    drag1 <- dragons %>%
      filter(year_of_birth>=birthYears[["years"]][1] & year_of_birth <= birthYears[["years"]][2])
    
    if(length(input[["checkGroup"]])>0)
    {
      drag2 <- drag1 %>% filter(colour %in% as.character(birthYears[["color"]]))
      
      facetlabels <- c("Czarny", "Niebieski", "Czerwony", "Zielony")
      names(facetlabels) <- c("black", "blue", "red", "green")
      
      #Gdy jest wybrany tylko jeden kolor nie chcemy facetowania
      if(length(unique(drag2$colour)) > 1){
      ggplot(drag2, aes(x = scars, y = life_length)) +
        facet_grid(rows = vars(colour), labeller = labeller(colour = facetlabels)) +
        geom_point(color = as.character(drag2[["colour"]])) +
        ylab("Długość życia smoka") +
        xlab("Liczba blizn") +
        scale_x_continuous(limits = c(0, 80)) +
        scale_y_continuous(limits = c(0, 4100))
      }
      else{
        ggplot(drag2, aes(x = scars, y = life_length)) +
          geom_point(color = as.character(drag2[["colour"]])) +
          ylab("Długość życia smoka") +
          xlab("Liczba blizn") +
          scale_x_continuous(limits = c(0, 80)) +
          scale_y_continuous(limits = c(0, 4100))
      }
    }
    else{
      dragons%>%
        ggplot(aes(x = scars, y = life_length)) +
        ylab("Długość życia smoka") +
        xlab("Liczba blizn")+
        scale_x_continuous(limits = c(0, 80)) +
        scale_y_continuous(limits = c(0, 4100))
      #geom_point()
      
      
    }
  })
  
  tlumaczkolor <- function(nazwa){
    ifelse(nazwa=="red", "czerwonego", ifelse(nazwa=="blue", "niebieskiego", ifelse(nazwa == "green", "zielonego", "czarnego")))
  }
  
  xy_str <- function(e, start, begin) {
    if(is.null(e)) return("\n\n\nNajedź kursorem na punkt, aby poznać więcej szczegółów o smoku. ")
    data <- dragons %>%
      filter(year_of_birth %in% start:begin)
    we <- nearPoints(data, input[["plot_hover"]], maxpoints = 1)
    

    if(length(as.character(we[["colour"]])) < 1) return("\n\n\nW danym miejscu nie ma żadnego smoka.")
     paste0("Wskazany smok urodził się w ", we[["year_of_birth"]], " roku, waży ", round(we[["weight"]], 2),
            " ton,\nma ", round(we[["height"]] * 0.9144, 2),
            " metrów wzrostu. Stracił ", we[["number_of_lost_teeth"]], " zębów.\nOdkryto go w ", we[["year_of_discovery"]],
            " roku, przeżył ", round(we[["life_length"]]/12), " lat.\nJest koloru ",
            tlumaczkolor(we[["colour"]]))
    
  }
  
  output[["info"]] <- renderText({
   xy_str(input$plot_hover, input[["birthyear"]][1], input[["birthyear"]][2])
   
  })
  
  
}



shinyApp(ui = ui, server = server)

