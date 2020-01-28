library(shiny)
library(rpivotTable)
library(dplyr)
library(shinydashboard)

data <- read.csv("StudentsPerformance.csv")

ui <- dashboardPage(

    dashboardHeader(title = "Student Performance" , 
                    dropdownMenu(type = "messages",
                                 messageItem(
                                     from = "Creator",
                                     message = "On the left sidebar you can filter your data!"
                ))),

    dashboardSidebar(
                    
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
                                     min = 0,max = 100,step = 1, value = c(0,100))),
    
    
    dashboardBody(fluidRow(
        rpivotTableOutput("myPivot")
        ))
        
    
)

server <- function(input, output) {
    # Data filtering 
    
    
    rpivotTableOutput("myPivot")
    
    output$myPivot <- renderRpivotTable({
        dataFiltered <- data %>% filter(gender %in% input[["gender"]]) %>% 
                                 filter(race.ethnicity %in% input[["race.ethnicity"]]) %>% 
                                 filter(parental.level.of.education %in% input[["parental.level.of.education"]]) %>%
                                 filter(lunch %in% input[["lunch"]]) %>%
                                 filter(math.score >= min(input[["math.score"]]) & math.score <= max(input[["math.score"]])) %>% 
                                 filter(test.preparation.course %in% input[["test.preparation.course"]]) %>% 
                                 filter(reading.score >= min(input[["reading.score"]]) & math.score <= max(input[["reading.score"]])) %>% 
                                 filter(writing.score >= min(input[["writing.score"]]) & math.score <= max(input[["writing.score"]]))
            
        colnames(dataFiltered)[2:5] <- c("race/eth.", "par.lvl.of.edu","lunch","tst.prep.cour.")
        rpivotTable(dataFiltered,rows = "gender",cols = c("math.score") ,width="50%", 
                                height="400px", rendererName = "Stacked Bar Chart")
    
        })
}

shinyApp(ui = ui, server = server)
