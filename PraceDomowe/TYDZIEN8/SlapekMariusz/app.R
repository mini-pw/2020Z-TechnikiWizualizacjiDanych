library(shiny)
library(r2d3)
library(shinythemes)


ui <- fluidPage(
  theme = shinytheme("simplex"),
  headerPanel("Christmas tree"),
  sidebarLayout(position = "right",
                sidebarPanel(
                             code("Baubles:"),
                             selectInput("colorBaubles", label = "Christmas baubles color", 
                                         choices = c("random", "gold", "orchid", "coral")),
                             
                             sliderInput("numBaubles", label = "Number of christmas baubles: ",
                                         min = 1, max = 70, value = 35 , step = 1),
                             sliderInput("sizeBaubles", label = "Size of christmas baubles: ",
                                         min = 1, max = 5, value = 3 , step = 1),
                             strong("You can move baubles!!!"),
                             br(),
                             code("Tree:"),
                             selectInput("colorTree", label = "Tree color:",
                                         choices = c("forestgreen", "lightgreen","lawngreen","mediumseagreen", "limegreen")),
                             br(),
                             code("Star:"),
                             sliderInput("sizeStar", label = "Size of the star: ",
                                         min = 1, max = 5, value = 3 , step = 1),
                             checkboxInput('boolStar', 'Star (yes/no)'),
                             br(),
                             code("Tinsel:"),
                             selectInput("colorTinsel", label = "Tinsel color:",
                                         choices = c("yellow","orange","red", "random")),
                             sliderInput("sizeTinsel", label = "Size of the tinsel: ",
                                         min = 1, max = 5, value = 3 , step = 1),
        
                             strong("You can move tinsel!!!")
                ),
                mainPanel(title = "Christmas tree",
                          br(),
                          #fluidRow(column(12, align="center", mainPanel(d3Output("d3")))))
                          d3Output("d3"))
  )
  
)


server <- function(input, output) {
  output[["d3"]] <- renderD3({
         r2d3(data.frame(colBaubles = input[["colorBaubles"]],
                         numBaubles = input[["numBaubles"]],
                         sizeBaubles = input[["sizeBaubles"]],
                         sizeStar = input[["sizeStar"]],
                         boolStar = input[["boolStar"]],
                         colorTinsel = input[["colorTinsel"]],
                         colorTree = input[["colorTree"]],
                         sizeTinsel = input[["sizeTinsel"]]
                         
         ), 
         script = "christmas-tree.js"
    )
  })

}

shinyApp(ui = ui, server = server)