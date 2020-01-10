library(shiny)
library(shinyjs)
library(r2d3)

ui <- fluidPage(
  useShinyjs(),
  sidebarPanel(title = "Praca domowa D3",
               p("Wykres czasow przebiegu maratonu"),
               div(id = "czas",              
                   checkboxInput("czas", "Pokaz czas", value = TRUE)
               ),
               div(id = "rekord",
                   checkboxInput("rekord", "Pokaz rekord", value = TRUE)
               ),
               div(id = "miejsce",
                   checkboxInput("miejsce", "Pokaz miejsce", value = TRUE)
               ),
               div(id= "form", actionButton("Reset", "Reset") )
  ),
  mainPanel(d3Output("d3"))
)

server <- function(input, output) {
  observeEvent(input$Reset, {
    shinyjs::reset("form")})
  
  output[["d3"]] <- renderD3({
    df <- data.frame(czas1 = "2:05:30",
                     time1 = 7530,
                     czas2 = "2:04:05",
                     time2 = 7445,
                     czas3 = "2:05:00",
                     time3 = 7500,
                     czas4 = "2:04:11",
                     time4 = 7451,
                     czas5 = "2:04:42",
                     time5 = 7482,
                     czas6 = "2:04:00",
                     time6 = 7440,
                     czas7 = "2:03:05",
                     time7 = 7385,
                     czas8 = "2:08:42",
                     time8 = 7722,
                     czas9 = "2:00:25",
                     time9 = 7225,
                     czas10 = "2:03:32",
                     time10 = 7412,
                     czas11 = "2:04:17",
                     time11 = 7457,
                     czas12 = "2:01:39",
                     time12 = 7299,
                     czas13 = "2:02:37",
                     time13 = 7357,
                     czy_rekord = input[["rekord"]],
                     czy_czas = input[["czas"]],
                     czy_miejsce = input[["miejsce"]],
                     miejsce1 = "Hamburg",
                     miejsce2 = "Berlin",
                     miejsce3 = "Roterdam",
                     miejsce4 = "Chicago",
                     miejsce5 = "Londyn",
                     miejsce6 = "Berlin",
                     miejsce7 = "Londyn",
                     miejsce8 = "Rio",
                     miejsce9 = "Breaking2",
                     miejsce10 = "Berlin",
                     miejsce11 = "Londyn",
                     miejsce12 = "Berlin",
                     miejsce13 = "Londyn")
    r2d3(df, 
         script = "wykres.js"
    )
  })
}

shinyApp(ui = ui, server = server)