library(shiny)
library(rpivotTable)
library(dplyr)
library(shinydashboard)
data <- read.csv("StudentsPerformance.csv")
colnames(data)[2:5] <- c("race_eth.", "par.lvl.of.edu","lunch","tst.prep.cour.")

ui <- dashboardPage(

    dashboardHeader(title = "Student Performance" , 
                    dropdownMenu(type = "messages",
                                 messageItem(
                                     from = "Creator",
                                     message = "On the left sidebar you can filter your data!"
                ))),

    dashboardSidebar(
                        checkboxInput("checkbox1",label="Prepared visualizations"),
                        conditionalPanel(
                            condition = "input.checkbox1 == true",
                            selectInput("select", label = "Select what you want to see", 
                                     choices = c("Lunch affect on student's results",
                                                 "Corelation between writing and reading score", 
                                                 "Race and ethnicity and parents level of education", 
                                                 "Parent level of education"),
                                     selected = "Lunch affect on student's results")),
               
                        checkboxInput("checkbox2",label="Self made visualization"),
                        conditionalPanel(
                            condition = "input.checkbox2 == true",
                            
                            checkboxGroupInput("gender", "Select gender", choices = c("female","male"), selected = c("female","male")),
                            checkboxGroupInput("race.ethnicity", "Select race/ethinicity",
                                               choices = c("group A","group B","group C","group D","group E"),
                                               selected = c("group A","group B","group C","group D","group E")),
                            checkboxGroupInput("parental.level.of.education", "Select parental level of education",
                                               choices = c("high school", "some college", "bachelor's degree", "master's degree", "associate's degree"),
                                               selected =  c("high school", "some college", "bachelor's degree", "master's degree", "associate's degree")),
                            checkboxGroupInput("lunch", "Select type of lunch",
                                               choices = c("free/reduced", "standard"),
                                               selected =  c("free/reduced", "standard")),
                            checkboxGroupInput("test.preparation.course", "Select level of preparation",
                                               choices = c("none", "completed"),
                                               selected =  c("none", "completed")),
                            sliderInput("math.score","Select limits of math score", 
                                        min = 0,max = 100,step = 1, value = c(0,100)),
                            sliderInput("reading.score","Select limits of reading score", 
                                        min = 0,max = 100,step = 1, value = c(0,100)),
                            sliderInput("writing.score","Select limits of writing score", 
                                        min = 0,max = 100,step = 1, value = c(0,100))
                            
                        )
),
                        
    
    dashboardBody(
                  box(title="Pivot Table", solid = TRUE,
                      footer =
                          "With this box, averything fits in one page, always! Feel free to scroll right if content exceeds the screen. \n 
                           If you want to play with data, select `Self made visualization`, filter your data, and than play with pivot table!", 
                      width = 20, 
                      height = 850,
                      # secret to fitting even when out of bounds
                      # but integration of pivot table with shiny is hard
                      tags$div(style = 'overflow-x: scroll' , rpivotTableOutput("myPivot",height = "800px",width = "90%" )))
                  )

)

server <- function(input, output) {
    # Data filtering 
    
    output$myPivot <- renderRpivotTable({
        
        rpivotTable(data,rows = "lunch",cols = c("math.score") ,width="90%", 
                    rendererName = "Stacked Bar Chart")})
        
    observeEvent(input[["select"]],{ 
        
        if (input[["select"]]=="Lunch affect on student's results"){
            output$myPivot <- renderRpivotTable({
            rpivotTable(data,rows = "lunch",cols = c("math.score") ,width="90%", 
                        rendererName = "Stacked Bar Chart")}) }
        
        if (input[["select"]]=="Corelation between writing and reading score"){
            output$myPivot <- renderRpivotTable({
                rpivotTable(data,rows = "writing.score",cols = "reading.score" ,width="90%", 
                            rendererName = "Scatter Chart")}) }
        
        if (input[["select"]]=="Race and ethnicity and parents level of education"){
            output$myPivot <- renderRpivotTable({
                rpivotTable(data,rows = "par.lvl.of.edu",cols = "race_eth." ,width="90%", 
                            rendererName = "Table Barchart", aggregatorName = "Count as Fraction of Total")}) }
        
        if (input[["select"]]=="Parent level of education"){
            output$myPivot <- renderRpivotTable({
                rpivotTable(data,rows = "par.lvl.of.edu",cols = "" ,width="90%", 
                            rendererName = "Treemap")}) }
        
        
        })
    
    observeEvent(input[["checkbox2"]] == TRUE, {
        output$myPivot <- renderRpivotTable({
            dataFiltered <- data %>% filter(gender %in% input[["gender"]]) %>% 
                filter(race_eth. %in% input[["race.ethnicity"]]) %>% 
                filter(par.lvl.of.edu %in% input[["parental.level.of.education"]]) %>%
                filter(lunch %in% input[["lunch"]]) %>%
                filter(math.score >= min(input[["math.score"]]) & math.score <= max(input[["math.score"]])) %>% 
                filter(tst.prep.cour. %in% input[["test.preparation.course"]]) %>% 
                filter(reading.score >= min(input[["reading.score"]]) & math.score <= max(input[["reading.score"]])) %>% 
                filter(writing.score >= min(input[["writing.score"]]) & math.score <= max(input[["writing.score"]]))
            
            colnames(dataFiltered)[2:5] <- c("race_eth.", "par.lvl.of.edu","lunch","tst.prep.cour.")
            rpivotTable(dataFiltered,rows = "gender",cols = c("math.score") ,width="90%", 
                        rendererName = "Stacked Bar Chart")
            
        })
    })
       
 
}


shinyApp(ui = ui, server = server)
