library(shiny)
library(r2d3)
library(dplyr)
library(tidyr)
load('dragons.rda')
dragons2 <- mutate(dragons, 
                   year_of_death = round(year_of_birth + life_length)) 
years <- seq(min(dragons2$year_of_birth), max(dragons2$year_of_death), by = 1)

population <- lapply(split(dragons2, dragons2$colour), function(colored_dragons){
    sapply(years,
           function(year) {
             sum(colored_dragons$year_of_birth <= year & colored_dragons$year_of_death >= year)
           })
  }) %>% as.data.frame() %>% 
    setNames(attr(dragons2$colour, "levels")) %>%
  mutate(Year = years) %>%
pivot_longer(cols = attr(dragons2$colour, "levels"), 
             names_to = "dragon_colour", 
             values_to = "Population")

ui <- fluidPage(titlePanel("Dragon population"),
                sidebarLayout(
                  sidebarPanel(
                    h3("Choose parameters:"),
                    sliderInput(inputId = "yearSelect",
                                label = "Choose year range: ",
                                min = min(as.integer(population$Year)),
                                max = max(as.integer(population$Year)),
                                value = c(min, 2020),
                                step = 1,
                                sep = ""),
                    checkboxGroupInput(inputId = "colourInput",
                                label = "Choose colors: ",
                                choices = unique(population$dragon_colour),
                                selected = unique(population$dragon_colour))
                  ),
                mainPanel(
                  d3Output("d3", height = "600px")
                  )
                )
                )


server <- function(input, output) {
  output[["d3"]] <- renderD3({
    data <- filter(population,
                   dragon_colour %in% input$colourInput,
                   Year >= input$yearSelect[1],
                   Year <= input$yearSelect[2])
    r2d3(data = data,
      script = "linechart.js",
      css = "linechart.css"
    )
  })
}

shinyApp(ui = ui, server = server)