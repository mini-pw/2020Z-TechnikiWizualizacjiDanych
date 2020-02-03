library(shiny)
library(rpivotTable)
library(dplyr)

basic_r <- "Heatmap"
basic_a <- "Count"

#options(stringsAsFactors = FALSE)

b <- read.csv('./movies.csv') %>% 
    select(-c(imdb, budget_2013., domgross_2013., intgross_2013., period.code, decade.code, test)) %>%
    mutate(intgross = as.numeric(intgross))

ui <- fluidPage(

    titlePanel("Bechdel Test in movies 1970-2013"),

    sidebarLayout(
        sidebarPanel(
            verbatimTextOutput('info'),
            sliderInput('year', 'Select year: ', min = 1970, max =  2013, step = 1, value = c(1990,2013)),
            checkboxGroupInput('test', 'Select test passed: ', choices = c('nowomen','doubious', 'notalk', 'men',  'ok'), selected = c('nowomen','doubious', 'notalk', 'men',  'ok')),
            selectInput('cols', 'Select columns: ', choices = colnames(b), selected = 'clean_test'),
            selectInput('rows', 'Select rows: ', choices = colnames(b), selected = 'year'),
            selectInput('vals', 'Select value: ', choices = colnames(b), selected = 'clean_test'),
            sliderInput('budget', 'Select budget: ', min = min(b$budget, na.rm = TRUE), max =  max(b$budget), step = 1000, value = c(min(b$budget), max(b$budget))),
            sliderInput('gross', 'Select international gross: ', min = min(b$intgross, na.rm = TRUE), max =  max(b$intgross, na.rm = TRUE), step = 1000, value = c(min(b$intgross, na.rm = TRUE), max(b$intgross, na.rm = TRUE))),
            actionButton('ex1', 'Bar Chart - passing test through years'),
            actionButton('ex2', 'Heatmap - Summed international gross by passing test in years'),
            actionButton('ex3', 'Line Chart - budget by year and passing test')
        ,width = 3),

        mainPanel(
            textOutput('info0'),
           rpivotTableOutput("table")
        )
    )
)

server <- function(input, output, session) {
    output$info0 <- renderText('The Bechdel test (/ˈbɛkdəl/ BEK-dəl),also known as the Bechdel–Wallace test, is a measure of the representation of women in fiction.')
    output$info <- renderText('Rules:\n1. It has to have at least two women in it\n2. Who talk to each other\n3. About something besides a man')
    
    render_piv <- function(basic_r,basic_a){
        renderRpivotTable({
            x <- b %>% 
                filter(clean_test %in% input$test) %>% 
                filter(year >= input$year[1] & year <= input$year[2]) %>%
                filter(budget >=input$budget[1] & budget <= input$budget[2]) %>% 
                filter(intgross >=input$gross[1] & budget <= input$gross[2])
            rpivotTable(x, rows = input$rows, cols = input$cols, vals = input$vals, rendererName = basic_r, aggregatorName = basic_a)
        })
    }
    output$table <- render_piv(basic_r, basic_a)
    
    observeEvent(input$ex1,{
        
        updateSelectInput(session, inputId = 'cols', selected = 'year')
        updateSelectInput(session, inputId = 'rows', selected = 'clean_test')
        updateSelectInput(session, inputId = 'vals', selected = 'clean_test')
        updateSliderInput(session, 'budget', 'Select budget: ', min = min(b$budget, na.rm = TRUE), max =  max(b$budget), step = 1000, value = c(min(b$budget), max(b$budget)))
        updateSliderInput(session, 'gross', 'Select international gross: ', min = min(b$intgross, na.rm = TRUE), max =  max(b$intgross, na.rm = TRUE), step = 1000, value = c(min(b$intgross, na.rm = TRUE), max(b$intgross, na.rm = TRUE)))
        
        output$table <- render_piv('Bar Chart', 'Count')
       })
    
    observeEvent(input$ex2,{
        
        updateSelectInput(session, inputId = 'cols', selected = 'clean_test')
        updateSelectInput(session, inputId = 'rows', selected = 'year')
        updateSelectInput(session, inputId = 'vals', selected = 'intgross')
        updateSliderInput(session, 'budget', 'Select budget: ', min = min(b$budget, na.rm = TRUE), max =  max(b$budget), step = 1000, value = c(min(b$budget), max(b$budget)))
        updateSliderInput(session, 'gross', 'Select international gross: ', min = min(b$intgross, na.rm = TRUE), max =  max(b$intgross, na.rm = TRUE), step = 1000, value = c(min(b$intgross, na.rm = TRUE), max(b$intgross, na.rm = TRUE)))
        
        output$table <- render_piv('Row Heatmap', 'Sum')
    })
    
    observeEvent(input$ex3,{
        
        updateSelectInput(session, inputId = 'cols', selected = 'year')
        updateSelectInput(session, inputId = 'rows', selected = 'clean_test')
        updateSelectInput(session, inputId = 'vals', selected = 'budget')
        updateSliderInput(session, 'budget', 'Select budget: ', min = min(b$budget, na.rm = TRUE), max =  max(b$budget), step = 1000, value = c(min(b$budget), max(b$budget)))
        updateSliderInput(session, 'gross', 'Select international gross: ', min = min(b$intgross, na.rm = TRUE), max =  max(b$intgross, na.rm = TRUE), step = 1000, value = c(min(b$intgross, na.rm = TRUE), max(b$intgross, na.rm = TRUE)))
        
        output$table <- render_piv('Line Chart', 'Sum')
    })

    
}

shinyApp(ui = ui, server = server)
