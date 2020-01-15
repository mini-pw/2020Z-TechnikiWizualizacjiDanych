library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(r2d3)
library(plotly)

data <- miceadds::load.Rdata2("dragons.rda")

ui <- fluidPage(theme = shinytheme("superhero"),
                sidebarPanel(checkboxGroupInput(inputId = "colour_choose", label = "Wybierz kolory smoków", 
                                                choices = sort(unique(data[["colour"]])),
                                                selected = sort(unique(data[["colour"]])))),
                mainPanel(
                  tabsetPanel(
                    tabPanel("Plotly",
                             titlePanel(title = "How does the dragon's body mass index affect his life expectancy? "),
                             plotlyOutput(outputId = "plotly", height = "600px"),
                            p("The body mass index was calculated according to the BMI = mass (kg) / (height (m)) ^ 2 formula.
                              Thanks to the side panel we can see the relationships for dragons of each color.")),
                    tabPanel("Ggplot",
                             titlePanel(title = "Relationship between the number of teeth lost by the dragon and the length of its life."),
                             plotOutput(outputId = "ggplot", height = "600px"),
                             p("Thanks to the side panel we can see trend lines for dragons of all colors.")),
                    tabPanel("D3",
                             titlePanel(title = "The number of dragons discovered in the years 1700 - 1730."),
                             d3Output(outputId = "d3", height = "600px"))
                    
                    
                  )
                )
)

server <- function(input, output) {

  # Wzrost przeliczamy z jardów na metry
  data$height <- data$height * 1.0936
  # a wagę z ton na kilogramy
  data$weight <- data$weight * 1000
  
  # interaktywny wykres ggplot
  data <- data %>%
    mutate(bmi = data$weight / (data$height)^2)
  
  r_dragons_plot <- reactive({
    unique_colors <- unique(data[["colour"]])
    lazy_palette <- rainbow(length(unique_colors)) %>% 
      setNames(unique_colors)
    
    data %>%
      filter(data$colour %in% input[["colour_choose"]]) %>%
    ggplot(aes(x = bmi, y = life_length, color = colour)) + 
      geom_point() + 
      theme_bw() + 
      theme(title = element_text(),
            panel.grid = element_blank()) + 
      scale_color_manual(values = unique_colors) +
      ylab("Life length") + 
      xlab("Body Mass Index")
  })
  
  
  output[["plotly"]] <- renderPlotly({
    r_dragons_plot() %>% 
      ggplotly()
  })
  
  output[["ggplot"]] <- renderPlot(
    data %>%
      filter(data$colour %in% input[["colour_choose"]]) %>%
    ggplot(aes(x = life_length, y = number_of_lost_teeth)) + 
      geom_point() + 
      geom_smooth() + 
      theme_bw() + 
      ylab("Number of lost teeth") + 
      xlab("Life length") + 
      theme(
        panel.background = element_blank(),
        panel.grid = element_blank()
      )
  )
  output[["d3"]] <- renderD3({
    data %>% 
      filter(year_of_discovery >= 1700 & year_of_discovery <= 1730) %>%
      group_by(year_of_discovery) %>%
      summarise(count = n()) -> df
    
    r2d3(data = data.frame(df, fill = '#E69F00', mouseover = 'brown'),script = "script.js")})

}
  



shinyApp(ui = ui, server = server)
