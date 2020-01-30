


library(shiny)
library(r2d3)
library(dplyr)

# Define UI for application that draws a histogram
ui <- fluidPage(
    
    tags$head(
        tags$style(HTML("
@import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
      
      h1 {
        font-family: 'Lobster', cursive;
        font-weight: 500;
        line-height: 1.1;
        color: #ad8c05;
      }
      
     body {
  background-color: #ad8c05;
     } 


div.tooltip {
  position: absolute;
  text-align: center;
  /*width: 60px;*/
  height: 28px;
  padding: 2px;
  font: 12px sans-serif;
  background: white;
  border: 0px;
  border-radius: 8px;
  pointer-events: none;
}

    "))
    ),

    # Application title
    headerPanel("Dragons among us"),

    # Sidebar with a slider input for number of bins 
        inputPanel(
            checkboxGroupInput("dragon_colors", "Choose which dragon types to show",
                               choices = c("red","green","black","blue"), selected = c("red","green","black","blue")),
            selectInput("X_axis", "Choose X axis variable",
                                choices = c("year_of_birth","height","weight","year_of_discovery","scars",
                                            "number_of_lost_teeth","life_length"), selected = "height"),
            selectInput("Y_axis", "Choose Y axis variable",
                        choices = c("year_of_birth","height","weight","year_of_discovery","scars",
                                    "number_of_lost_teeth","life_length"), selected = "weight"),
            
            selectInput("w", "Something beautiful here",
                               choices = c("Naaaah","I wanna see..."), selected = "Naaaah"),
            img(src="test.jpg", align = "left")
            
    
        ), 
    d3Output("d3")
    )

# Define server logic required to draw a histogram
server <- function(input, output) {

    output[["d3"]] <- renderD3({
     
        # Wczytanie danych do wykresu
        csvData = read.csv(file = "smoki.csv")
        
        
        Xmax <- csvData[input[["X_axis"]]] %>% max()
        Ymax <- csvData[input[["Y_axis"]]] %>% max()
        
        if(input[["X_axis"]] == "year_of_birth" ){
            Xmin <- csvData[input[["X_axis"]]] %>% min()
        }else(Xmin <- 0 )
        
        if(input[["Y_axis"]] == "year_of_birth" ){
            Ymin <- csvData[input[["Y_axis"]]] %>% min()
        }else(Ymin <- 0 )
        
    
        Data <- csvData %>% filter(colour %in% input[["dragon_colors"]])
        X <- 
        print(head(Data))
        r2d3(data.frame(Data, 
                        X_axis        = input[["X_axis"]],
                        X_max = Xmax , 
                        Y_max = Ymax ,
                        Y_min = Ymin,
                        X_min = Xmin,
                        Y_axis        = input[["Y_axis"]],
                        beauty = input[["w"]]),
             script = "smoki.js", width = 1600, height = 700 ) 
        })
}

# Run the application 
shinyApp(ui = ui, server = server)
