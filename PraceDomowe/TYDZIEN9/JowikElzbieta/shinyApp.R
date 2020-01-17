library(shiny)
library(r2d3)
library(readr)
library(ggplot2)
library(reshape)
library(ggpubr)
library(scales)
library(shinyjqui)

ui <- fluidPage(
  titlePanel(
    title = "Shiny App"
  ),
  sidebarPanel(
    titlePanel(
      h4("ggplot chart preferences panel")
    ),
    selectInput(inputId = "effect", label = "Show/Hide options", choices = get_jqui_effects(), selected = "fold"),
    actionButton(inputId = "show", label = "Show"),
    actionButton(inputId = "hide", label = "Hide"),
    
    titlePanel(
      h4(" The right D3 charts preferences panel")
      ),
    selectInput(inputId = "col1", label = "Color of the right chart bars", choices = list("#99CC99", "#990000", "#3366CC"), selected = "#990000"),
    selectInput(inputId = "col2", label = "Color of the right chart highlight", choices = list("#99CC33", "#330000", "#BFC2C5"), selected = "#330000"),
    p("Data tables below BOTH D3 barplots are also interactive. Try them out.")
  ),
  mainPanel(
    tabsetPanel(
      tabPanel(title = "ggplot",
               plotOutput("ggplot", height = "500px"),
               tableOutput("tbl")),
      tabPanel(title = "D3 plot (the left one)",
               titlePanel(title = "Unemployment rate (%)"),
               d3Output("d3.1"),
               # Data table preferences
               selectableTableOutput("tbl1", selection_mode = "cell"),
               verbatimTextOutput("selected")),
      tabPanel(title = "D3 plot (the right one)",
               titlePanel(title = "Median usual weekly earnings($)"),
               d3Output("d3.2"),
               verbatimTextOutput("index"),
               sortableTableOutput("tbl2"))
    )
  )
)

server <- function(input, output, session){
  
  degree <- c("Doctoral degree", "Professional degree", "Master's degree", "Bachelor's degree", "Associate's degree", "Some college, no degree", "High school diploma", "Less than high school")
  unemployment <- c(0.017, 0.015, 0.024, 0.028, 0.038, 0.050, 0.054, 0.080) 
  median <- c(1623, 1730, 1341, 1137, 798, 738, 678, 493)
  
  dataset <- data.frame(degree, unemployment, median)
  dataset$degree <- factor(dataset$degree, levels = rev(c("Doctoral degree", "Professional degree", "Master's degree", "Bachelor's degree", "Associate's degree", "Some college, no degree", "High school diploma", "Less than high school")))
  
  output[["d3.1"]] <- renderD3({r2d3(data = data.frame(degree = dataset$degree, unemployment = dataset$unemployment, median = dataset$median, fill = '#E69F00', mouseover = 'brown'),
                                     script = "r2d3_script.js")})
  
  output[["d3.2"]] <- renderD3({r2d3(data = data.frame(degree = dataset$degree, unemployment = dataset$unemployment, median = dataset$median, fill = input[["col1"]], mouseover = input[["col2"]]), script = "d3_script.js")})
  
  output[["tbl1"]] <- renderTable(dataset[, 1:2])
  
  output[["selected"]] <- renderPrint({
    cat("Selected:\n")
    input[["tbl1_selected"]]
  })
  
  output[["tbl2"]] <- renderTable(dataset[, -2])
  
  output[["index"]] <- renderPrint({
    cat("Row index:\n")
    input[["tbl2_row_index"]]
  })
  
  output[["ggplot"]] <- renderPlot({
    plot1 <- ggplot(data = dataset, aes(x = degree, y = unemployment)) +
      ggtitle("Unemployment rate(%)") +
      geom_line() +
      geom_hline(yintercept = 0.043, linetype = "dotted") +
      geom_col(fill = "blue") +
      coord_flip() +
      scale_y_continuous(breaks = c(0, 0.01,0.02,0.03,0.04,0.05,0.06,0.07,0.08), labels=scales::percent_format(accuracy = 1), limits = c(0, 0.08), expand = c(0, 0)) +
      geom_text(aes(label = percent(unemployment, 0.1), y = 0.001), color = "white", position = position_dodge(1), hjust = "left", size = 3) +
      theme_classic() + 
      theme(axis.title.y = element_blank(),
            axis.ticks.x = element_blank(),
            axis.ticks.y = element_blank(),
            axis.line.x = element_blank()) +
      labs(y = "Average: 4,3%")
    
    plot2 <- ggplot(data = dataset, aes(x = degree, y = median)) +
      ggtitle("Median usual weekly earnings($)") +
      geom_line() +
      geom_hline(yintercept = 860, linetype = "dotted") +
      geom_col(fill = "darkgrey") +
      geom_text(aes(label = median, y = 10), color = "white", position = position_dodge(1), hjust = "left", size = 3) +
      coord_flip() +
      scale_y_continuous(breaks = c(400, 800, 1200, 1600), labels = dollar(c(400, 800, 1200, 1600)), limits = c(0, 1800), expand = c(0, 0)) +
      theme_classic() +
      theme(axis.title.y = element_blank(),
            axis.ticks.x = element_blank(),
            axis.ticks.y = element_blank(),
            axis.text.y = element_blank(),
            axis.line.x = element_blank()) +
      labs(y = "Average: $860")
    
    ggarrange(plot1, plot2)
  })
  
  output[["tbl"]] <- renderTable(dataset)
  
  observeEvent(input[["show"]], {
    jqui_show("#ggplot", effect = input[["effect"]])
  })
  
  observeEvent(input[["hide"]], {
    jqui_hide("#ggplot", effect = input[["effect"]])
  })
}

shinyApp(ui = ui, server = server)