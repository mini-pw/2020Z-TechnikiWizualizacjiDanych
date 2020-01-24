library(shiny)
library(shinyjs)
library(r2d3)

drzewko <- function(k, d){
  # przyjmuje liczbe k, a zwraca rogi(jako napis) w których drzewko choinki bedzie narysowane
  najmniej <- 30
  najwiecej <- 370
  
  max_szerokosc <- (najwiecej-najmniej)*d
  rogi <- paste(as.character(c(190, najmniej)), collapse=",")
  
  for(i in 1:k){
    rogi <- paste(rogi, as.character(200-max_szerokosc/2/k*i), sep = " ")
    rogi <- paste(rogi, najmniej+(najwiecej-najmniej)/(k+1)*i, sep = ",")
    if(180-max_szerokosc/(4*k)*i>200-max_szerokosc/2/k*i){
      rogi <- paste(rogi, as.character(180-max_szerokosc/(4*k)*i), sep = " ")
    }else{
      rogi <- paste(rogi, as.character(210-max_szerokosc/2/k*i), sep = " ")
    }
    rogi <- paste(rogi, najmniej+(najwiecej-najmniej)/(k+1)*i, sep = ",")
  }
  glebokosc <- najmniej+(najwiecej-najmniej)/(k+1)*i
  for(i in k:1){
    if(220+max_szerokosc/(4*k)*i<200+max_szerokosc/2/k*(i)){
      rogi <- paste(rogi, as.character(220+max_szerokosc/(4*k)*i), sep = " ")
    }else{
      rogi <- paste(rogi, as.character(190+max_szerokosc/2/k*(i)), sep = " ")
    }
    rogi <- paste(rogi, najmniej+(najwiecej-najmniej)/(k+1)*i, sep = ",")
    rogi <- paste(rogi, as.character(200+max_szerokosc/2/k*(i)), sep = " ")
    rogi <- paste(rogi, najmniej+(najwiecej-najmniej)/(k+1)*i, sep = ",")
  }
  rogi <- paste(rogi, as.character(210), collapse=" ")
  rogi <- paste(rogi, as.character(najmniej), collapse=",")
  
  attr(rogi, "glebokosc") <- glebokosc
  rogi
}

ui <- fluidPage(
  useShinyjs(),
  
  div(id = "input_pane",
    inputPanel(
    sliderInput("max_szerokosc", label = "Szerokosc choinki",
                min = 0, max = 1, value = 1, step = 0.05),
    sliderInput("wielkosc_choinki", label = "Wielkosc choinki",
                min = 1, max = 10, value = 7, step = 1),
    sliderInput("ilosc_bombek", label = "Ilosc bombek",
                min = 0, max = 40, value = 30, step = 1),
    selectInput("kolor_bombek", label = "Kolor bombek", 
                choices = c("red", "blue", "magenta", "yellow", "green"))
    )
  ),
  mainPanel(d3Output("d3"))
)

server <- function(input, output) {
  
  output[["d3"]] <- renderD3({
    rogi <- drzewko(input[["wielkosc_choinki"]], input[["max_szerokosc"]])
    df <- data.frame(max_szerokosc = 340*input[["max_szerokosc"]],
                     rogi = rogi,
                     glebokosc = attr(rogi, "glebokosc"),
                     ilosc_bombek = input[["ilosc_bombek"]],
                     kolor_bombek = input[["kolor_bombek"]])
    print(df)
    
    r2d3(df, 
         script = "choinka.js"
    )
  })
}

shinyApp(ui = ui, server = server)