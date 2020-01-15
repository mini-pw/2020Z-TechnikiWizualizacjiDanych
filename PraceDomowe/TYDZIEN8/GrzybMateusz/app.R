library(shiny)
library(r2d3)
library(colourpicker)

ui <- fluidPage(
  
  tags$div(class = "snowflakes",
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake"),
    tags$div("*", class = "snowflake")
  ),
    
  tags$head(
    tags$style(HTML("
      @import url('//fonts.googleapis.com/css?family=Lobster|Cabin:400,700');
      
      h1 {
        font-family: 'Lobster', cursive;
        font-weight: 500;
        line-height: 1.1;
        color: #000;
      }
      
      body {
        background: url('https://lh3.googleusercontent.com/-8yGCBzF9F_s/XCHzZ5t7sJI/AAAAAAAAAlA/fnnU7Cma8UM9oE9ztOtlcqFs_aZiRI-aQCK8BGAs/s0/2018-12-25.jpg') no-repeat center center fixed;
        -webkit-background-size: cover;
        -moz-background-size: cover;
        -o-background-size: cover;
        background-size: cover;
      }
      
      .snowflake {
        color: #fff;
        font-size: 2em;
        font-family: Arial;
        text-shadow: 0 0 1px #000;
      }

      @-webkit-keyframes snowflakes-fall{0%{top:-10%}100%{top:100%}}@-webkit-keyframes snowflakes-shake{0%{-webkit-transform:translateX(0px);transform:translateX(0px)}50%{-webkit-transform:translateX(80px);transform:translateX(80px)}100%{-webkit-transform:translateX(0px);transform:translateX(0px)}}@keyframes snowflakes-fall{0%{top:-10%}100%{top:100%}}@keyframes snowflakes-shake{0%{transform:translateX(0px)}50%{transform:translateX(80px)}100%{transform:translateX(0px)}}.snowflake{position:fixed;top:-10%;z-index:9999;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;cursor:default;-webkit-animation-name:snowflakes-fall,snowflakes-shake;-webkit-animation-duration:10s,3s;-webkit-animation-timing-function:linear,ease-in-out;-webkit-animation-iteration-count:infinite,infinite;-webkit-animation-play-state:running,running;animation-name:snowflakes-fall,snowflakes-shake;animation-duration:10s,3s;animation-timing-function:linear,ease-in-out;animation-iteration-count:infinite,infinite;animation-play-state:running,running}.snowflake:nth-of-type(0){left:1%;-webkit-animation-delay:0s,0s;animation-delay:0s,0s}.snowflake:nth-of-type(1){left:10%;-webkit-animation-delay:1s,1s;animation-delay:1s,1s}.snowflake:nth-of-type(2){left:20%;-webkit-animation-delay:6s,.5s;animation-delay:6s,.5s}.snowflake:nth-of-type(3){left:30%;-webkit-animation-delay:4s,2s;animation-delay:4s,2s}.snowflake:nth-of-type(4){left:40%;-webkit-animation-delay:2s,2s;animation-delay:2s,2s}.snowflake:nth-of-type(5){left:50%;-webkit-animation-delay:8s,3s;animation-delay:8s,3s}.snowflake:nth-of-type(6){left:60%;-webkit-animation-delay:6s,2s;animation-delay:6s,2s}.snowflake:nth-of-type(7){left:70%;-webkit-animation-delay:2.5s,1s;animation-delay:2.5s,1s}.snowflake:nth-of-type(8){left:80%;-webkit-animation-delay:1s,0s;animation-delay:1s,0s}.snowflake:nth-of-type(9){left:90%;-webkit-animation-delay:3s,1.5s;animation-delay:3s,1.5s}
    "))
  ),
  
  headerPanel("Christmas tree"),
  sidebarLayout(
    sidebarPanel(
      colourInput("col1",
                  "Kolor gwiazdy",
                  value = "blue"),
      colourInput("col2",
                  "Kolor drzewa",
                  value = "darkgreen"),
      colourInput("col3",
                  "Kolor pnia",
                  value = "brown"),
      sliderInput("decor",
                  "Liczba bombek",
                  min = 0,  max = 50, value = 20),
      tags$div(class="header", checked=NA,
               tags$p("Instrukcja:"),
               tags$p("1. Ustaw kolory"),
               tags$p("2. Ustaw liczbę bombek"),
               tags$p("3. Przeciągaj bombki myszą")
    )),
    column(2, offset = 1,
    mainPanel(
      d3Output("d3", width = "400px", height = "500px"),
    )),
  )
)

server <- function(input, output) {
  output[["d3"]] <- renderD3({
    r2d3(data.frame(col1 = input[["col1"]],
                    col2 = input[["col2"]],
                    col3 = input[["col3"]],
                    decor = input[["decor"]]),
                    script = "tree.js")
  })
}

shinyApp(ui = ui, server = server)