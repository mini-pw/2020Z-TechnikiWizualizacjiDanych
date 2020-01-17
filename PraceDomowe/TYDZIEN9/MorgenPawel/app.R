library(shiny)
library(r2d3)
library(dplyr)
library(tidyr)
library(stringi)
read.csv("GDP.csv")  %>%
  select(-(2:4)) -> GDPs
colnames(GDPs)[-1] <- stri_replace_first_fixed(str = colnames(GDPs)[-1],pattern = "X",replacement = "")
pivot_longer(GDPs, cols = 2:ncol(GDPs), names_to = "Year", values_to = "Value") %>%
  mutate(Value = Value / 1e+12) -> long_GDPs

ui <- fluidPage(titlePanel("GDP Comparator"),
                sidebarLayout(
                  sidebarPanel(
                    h3("Choose parameters:"),
                    sliderInput(inputId = "yearSelect",
                                label = "Choose year range: ",
                                min = min(as.integer(long_GDPs$Year)),
                                max = max(as.integer(long_GDPs$Year)),
                                value = c(min, max),
                                step = 1,
                                sep = ""),
                    selectizeInput(inputId = "countriesInput",
                                label = "Choose countries: ",
                                choices = attr(long_GDPs$Country.Name, 'levels'),
                                multiple = TRUE,
                                selected = c("United States", "United Kingdom", "China", "Japan"),
                                options = list(maxItems = 9)),
                    helpText("Source: World Bank")
                  ),
                mainPanel(
                  d3Output("d3", height = "600px")
                  )
                )
                )


server <- function(input, output) {
  output[["d3"]] <- renderD3({
    data <- filter(long_GDPs,
                   Country.Name %in% input$countriesInput,
                   Year >= input$yearSelect[1],
                   Year <= input$yearSelect[2])
    r2d3(data = data,
      script = "linechart.js",
      css = "linechart.css"
    )
  })
}

shinyApp(ui = ui, server = server)