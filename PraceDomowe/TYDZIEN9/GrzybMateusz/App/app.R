library(shiny)
library(r2d3)
options(r2d3.shadow = FALSE)
library(colourpicker)

ui <- fluidPage(
    tags$head(
        tags$style(
            HTML("
                body {
                font: 15px sans-serif;
            }
            .tooltip {
                position: absolute;
                font-size: 12px;
                width:  auto;
                height: auto;
                pointer-events: none;
                background-color: white;
            }"
            )
        )
    ),
    titlePanel("CSGO visualizer"),
    tags$p("...by Mateusz Grzyb"),
    fluidRow(
        column(2,
            tags$hr(),
            fileInput("file1", "Choose CSV File",
                      multiple = FALSE,
                      accept = c("text/csv",
                                 "text/comma-separated-values,text/plain",
                                 ".csv")),
            tags$hr(),
            radioButtons("sep", "Separator",
                         choices = c(Comma = ",",
                                     Semicolon = ";",
                                     Tab = "\t"),
                         selected = ","),
            radioButtons("quote", "Quote",
                         choices = c(None = "",
                                     "Double Quote" = '"',
                                     "Single Quote" = "'"),
                         selected = '"'),
            tags$hr(),
            colourInput("col1",
                        "Team A color*",
                        value = "#6699cc"),
            colourInput("col2",
                        "Team B color*",
                        value = "#ff8c42"),
            colourInput("col3",
                        "Positive color*",
                        value = "#3cb371"),
            colourInput("col4",
                        "Negative color*",
                        value = "#ff5050"),
            tags$p("*All colors affect both plots and tooltips"),
            tags$hr(),
        ),
        column(4,
            d3Output("d3_1", width = "500px", height = "599px")
        ),
        column(4,
            d3Output("d3_2", width = "500px", height = "599px"))
    )
)

server <- function(input, output) {
    output[["d3_1"]] <- renderD3({
      req(input$file1)
      # when reading semicolon separated files,
      # having a comma separator causes `read.csv` to error
      tryCatch({
        df <- read.csv(input$file1$datapath, header = TRUE, sep = input$sep, quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      })
        r2d3(data = df, options = list(col1 = input[["col1"]], col2 = input[["col2"]], col3 = input[["col3"]], col4 = input[["col4"]]), script = "script1.js")
    })
    output[["d3_2"]] <- renderD3({
      req(input$file1)
      # when reading semicolon separated files,
      # having a comma separator causes `read.csv` to error
      tryCatch({
        df <- read.csv(input$file1$datapath, header = TRUE, sep = input$sep, quote = input$quote)
      },
      error = function(e) {
        # return a safeError if a parsing error occurs
        stop(safeError(e))
      })
      df$KDR_1 <- round(df$Kills/df$Deaths, 2)
      df$KDR_2 <- round((df$KDR_1 - mean(df$KDR_1))/sd(df$KDR_1), 2)
      df$KDR_2_type <- ifelse(df$KDR_2 < 0, "Below", "Above")
      df <- df[order(df$KDR_2), ]
      r2d3(data = df, options = list(col1 = input[["col1"]], col2 = input[["col2"]], col3 = input[["col3"]], col4 = input[["col4"]]), script = "script2.js")
      })
}

shinyApp(ui, server)
