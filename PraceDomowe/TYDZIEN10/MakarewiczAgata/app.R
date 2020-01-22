library(shiny)
library(r2d3)
library(dplyr)

data <- miceadds::load.Rdata2("dragons.rda")

ui <- fluidPage(
  #titlePanel( div(HTML(" <em>Dragons - dead or alive?</em> "))),
  titlePanel( div(HTML("<em><font face='Comic Sans MS'>Dragons - dead or alive?</font></em>"))),
  sidebarLayout(
    sidebarPanel(
      selectInput("dragon_color", "Choose dragons' colour: ", 
                  choices = c("All","Black","Blue","Green","Red")),
      sliderInput("bins_number", label = "Select number of bins", min = 1, max = 100, value = 10),
      div(HTML(" <em>Place the mouse over bars to see how many dragons in chosen age range are left</em> "))
    ),
    mainPanel(
      d3Output("d3")
    )
  )
)

server <- function(input,output){
  
  # tworzymy dodatkowe kolumny - date smierci, status (zyje/nie zyje) oraz wiek (jesli nie zyje to 0)
  dead_or_alive <- dragons%>%
    mutate(year_of_death = year_of_birth + life_length)%>%
    mutate(Status = case_when(
      year_of_death >= 2020 ~ "Alive", TRUE ~ "Dead"))%>%
    mutate(Age = case_when(
      Status == "Alive" ~ year_of_death - year_of_birth, TRUE ~ 0))
    
  # wybieramy tylko żyjące smoki
  dragons_alive <- dead_or_alive%>%
    filter(Status == "Alive")%>%
    mutate(Age = round(Age, digits = 0))
  # domyślny kolor wykresu
  color = "#cc99ff"
  
  # w zależnosci od wyboru koloru smoków, filtrujemy dane i dostosowujemy kolor wykresu
  observeEvent(input$dragon_color, {
    if(input$dragon_color=="Black"){
      dragons_alive <- dragons_alive%>%
        filter(colour=="black")
      color = "#000000"
    }else if(input$dragon_color=="Blue"){
      dragons_alive <- dragons_alive%>%
        filter(colour=="blue")
      color = "#4da6ff"
    }else if(input$dragon_color=="Green"){
      dragons_alive <- dragons_alive%>%
        filter(colour=="green")
      color = "#80ff80"
    }else if(input$dragon_color=="Red"){
      dragons_alive <- dragons_alive%>%
        filter(colour=="red")
      color = "#e60000"
    }
   
    output[["d3"]] <- renderD3({
      
      r2d3(data = data.frame(dragons_alive, color,
                             bins_number = input[["bins_number"]]), script = "smoki.js")
    })
  })


  
}

shinyApp(ui = ui, server = server)