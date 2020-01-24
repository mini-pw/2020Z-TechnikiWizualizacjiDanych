library(dplyr)
library(shiny)
library(r2d3)
library(DT)
library(shinythemes)
load("dragons.rda")

dragons$colour <- as.character(dragons$colour)
dragons$where_discovered_alive <- (dragons$year_of_birth + dragons$life_length) <= dragons$year_of_discovery

ui <- 
  fluidPage(theme = shinytheme("journal"),titlePanel(h1("Dragons", align = "center")),
  sidebarPanel( inputPanel( sliderInput("scars", "Number of scars of the dragons: ", min = 0, max = 75, step = 1,
                           value = c(26,50)),
  sliderInput("teeth", "Number of teeth lost by the dragons: ", min = 0, max = 40,step = 1, value = c(15,25)),
  selectInput("info", "What is interesting for you",
              choices = c("What colour are the dragons?","Were they discovered alive?", "Life length of the dragons"), selected = "Colour", width = 150), align = "center")),
  mainPanel(DT::dataTableOutput("mytable")),
  d3Output("d3", width = "100%"), height = "600px",width = "800px", align = "center", 
)

server <- function(input, output){
  
  output$mytable = DT::renderDataTable({
    if (input$info == "What colour are the dragons?"){
      to_present <- cbind(c("red", "green", "blue", "black"), c(" ","  ","   ","     "))
      colnames(to_present) <- c("Colour of the dragon", "Colour")
      datatable(to_present, class = 'cell-border stripe', options = list(paging = FALSE, searching = FALSE)) %>% formatStyle(
        "Colour",
        backgroundColor = styleEqual(c(" ","  ","   ","     "), c("red", "#00BA38", "#619CFF", "black"))) -> dt}
    if (input$info == "Were they discovered alive?"){
      to_present <- cbind(c("Yes","No"), c(" ","  "))
      colnames(to_present) <- c("Were they discovered alive?", "Colour")
      datatable(to_present, class = 'cell-border stripe', options = list(paging = FALSE, searching = FALSE)) %>% formatStyle(
        "Colour",
        backgroundColor = styleEqual(c(" ","  "), c("green", "red"))) -> dt}
    if (input$info == "Life length of the dragons"){
      to_present <- cbind(c("500 - 1000 years","1001 - 1500 years","1501 - 2000 years", "2001 - 4500 years"),
                          c(" ","  ","   ","     "))
      colnames(to_present) <- c("Life length of the dragons", "Colour")
      datatable(to_present, class = 'cell-border stripe', options = list(paging = FALSE, searching = FALSE)) %>% formatStyle(
        "Colour",
        backgroundColor = styleEqual(c(" ","  ","   ","     "),
                                     c("#07ff52","yellow","orange","red"))) -> dt
    }
    dt
  })
  output[["d3"]] <- renderD3({
    dragons %>% filter(dragons$scars >= input$scars[1] & dragons$scars <= input$scars[2]) -> df
    df %>% filter(df$number_of_lost_teeth >= input$teeth[1] & df$number_of_lost_teeth <= input$teeth[2]) -> df
    if (input$info == "What colour are the dragons?"){
      df_final <- df
      df_final[df_final$colour=="green","colour"] <- "#619CFF"
      df_final[df_final$colour=="blue","colour"] <- "#00BA38"
    }
    if (input$info == "Were they discovered alive?"){
      df_final <- df
    
      df_final[df_final$where_discovered_alive == TRUE, "colour"] <- "red"
      df_final[df_final$where_discovered_alive == FALSE, "colour"] <- "green"
    }
    if (input$info == "Life length of the dragons"){
      df_final <- df
      
      df_final[df_final$life_length > 500 & df_final$life_length <= 1000, "colour"] <- "#07ff52"
      df_final[df_final$life_length > 1000 & df_final$life_length <= 1500, "colour"] <- "yellow"
      df_final[df_final$life_length > 1500 & df_final$life_length <= 2000, "colour"] <- "orange"
      df_final[df_final$life_length > 2000 & df_final$life_length <= 4500, "colour"] <- "red"
    }
    r2d3(df_final[order(df_final$weight),], script="file.js", width = 1600, height = 800)})
}

shinyApp(ui = ui, server = server)

