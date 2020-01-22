library(shiny)
library(shinythemes)
library(r2d3)



ui <- fluidPage(theme = shinytheme('united'),
    sidebarLayout(
        sidebarPanel( width = 2,
            h2("Opis",align="center"),
            
            "Aplikacja ta ma na celu ułatwienie zrozumienia danych zestawu Dragons,
            jak i być prostym narzędziem pozwalającym ten zbiór przedstawić",
            br(),br(),
            checkboxGroupInput("kolory",
                               h2("Kolory rodziny smoków",align="center"),
                               choiceNames =  c("Zielone","Niebieskie","Czerwone","Czarne"),
                               choiceValues = c("green","blue","red","black"))
        ),
        
        mainPanel(
            tabsetPanel(type="tabs",
                        tabPanel("Waga i Wzrost",d3Output("wh",height = "600px")),
                        tabPanel("Długość życia i blizny", d3Output("scars",height = "600px")),
                        tabPanel("Pełne dane",tableOutput('table')))
        )
    )
    
    
    
)




server <- function(input,output){

    load("dragons.rda")

  
    output[["wh"]] <- renderD3({r2d3(dragons[dragons$colour%in%input[["kolory"]],],script = "wh.js")})
    output[["scars"]] <- renderD3({r2d3(dragons[dragons$colour%in%input[["kolory"]],],script="scars.js")})
    
    output[['table']] <- renderTable(dragons)
    
}



shinyApp(ui,server)