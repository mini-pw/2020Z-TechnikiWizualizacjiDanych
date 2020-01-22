#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(ggplot2)
#load(file="dragons.rda")
#dragons <- dragons %>% mutate(height = height*0.91) %>%
    mutate(weight = weight*1000) %>%
    mutate(BMI = weight / (height*height))

#dragons <- dragons %>% mutate(waga = ifelse(BMI < 5.1, "Niedowaga", ifelse(BMI < 7, "Optimum", ifelse(BMI < 8.5, "Nadwaga", "Otylosc"))))
#dragons$waga <- factor(dragons$waga, levels =c( "Otylosc", "Nadwaga", "Optimum", "Niedowaga"), ordered = T)

#dragons %>% pull(waga) %>% table()
#zmienna <- "year_of_discovery"
#p <- ggplot(data = dragons, aes_string(x = zmienna, fill = "waga")) + geom_bar(position = "stack") + coord_flip()
#p

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Smocze BMI"),
    

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            tags$div(class="header", checked=NA,
                     HTML("Ponieważ smoki różnią się od ludzi, wymagają innego sposobu interpretowania BMI.
                            <br> BMI < 5.1 - Niedowaga <br> 5.1 <= BMI < 7 - Optimum
                            <br> 7 <= BMI < 8.5 - Nadawaga <br> 8.5 <= BMI - Otyłość")
            ),
            selectInput("statystyka", label = "Statystyka", 
                        choices = c("Liczba blizn" = "scars",
                                    "Rok urodzenia" = "year_of_birth",
                                    "Rok odkrycia" = "year_of_discovery",
                                    "Liczba straconych zębów" = "number_of_lost_teeth",
                                    "Kolory" = "colour")),
            numericInput("rokMax", "Maksymalny rok narodzin:", 1800, min = -2000, max = 1800),
            numericInput("rokMin", "Minimalny rok narodzin:", -2000, min = -2000, max = 1800),
            sliderInput("wzrost", "Zakres wzrostu:",value = c(29, 77), min=29, max = 77),
            sliderInput("waga", "Zakres wagi (w tonach):",value = c(7, 23), min=7, max = 23),
            sliderInput("blizny", "Liczba blizn:",value = c(0, 76), min=0, max = 76),
            numericInput("rokodkryciaMax", "Maksymalny rok odkrycia:", 1800, min = 1700, max = 1800),
            numericInput("rokodkryciaMin", "Minimalny rok odkrycia:", 1700, min = 1700, max = 1800),
            checkboxGroupInput("kolor", "Kolory do pokazania:",
                               choices = c("Czarne" = "black",
                                 "Niebieskie" = "blue",
                                 "Zielone" = "green",
                                 "Czerwone" = "red"),
                               selected = c("black", "blue", "green", "red")),
            sliderInput("zeby", "Liczba straconych zebow:",value = c(0, 40), min=0, max = 40),
            numericInput("wiekMax", "Maksymalna długość życia:", 3953, min = 511, max = 3953),
            numericInput("wiekMin", "Minimalna długość życia:", 511, min = 511, max = 3953)
            
        ),
        

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        load(file="dragons.rda")
        dragons <- dragons %>% mutate(height = height*0.91) %>%
            mutate(weight = weight*1000) %>%
            mutate(BMI = weight / (height*height))
        
        dragons <- dragons %>% mutate(waga = ifelse(BMI < 5.1, "Niedowaga", ifelse(BMI < 7, "Optimum", ifelse(BMI < 8.5, "Nadwaga", "Otylosc"))))
        dragons$waga <- factor(dragons$waga, levels =c("Otylosc", "Nadwaga", "Optimum", "Niedowaga"), ordered = T)
        dragons <- dragons %>% filter(year_of_birth >= input[["rokMin"]]) %>% 
            filter(year_of_birth <= input[["rokMax"]]) %>%
            filter(height <= input[["wzrost"]][2]) %>%
            filter(height > input[["wzrost"]][1]) %>%
            filter(weight <= input[["waga"]][2]*1000) %>%
            filter(weight > input[["waga"]][1]*1000) %>%
            filter(scars <= input[["blizny"]][2]) %>%
            filter(scars >= input[["blizny"]][1]) %>% 
            filter(year_of_discovery >= input[["rokodkryciaMin"]]) %>% 
            filter(year_of_discovery <= input[["rokodkryciaMax"]]) %>%
            filter(colour %in% input[["kolor"]]) %>%
            filter(number_of_lost_teeth >= input[["zeby"]][1]) %>%
            filter(number_of_lost_teeth <= input[["zeby"]][2]) %>%
            filter(life_length >= input[["wiekMin"]]) %>%
            filter(life_length <= input[["wiekMax"]])
        
        p <- ggplot(data = dragons, aes_string(x = input[["statystyka"]], 
                                               fill = "waga")) +
            geom_bar(width = 0.9) +
            scale_fill_manual(values = c("Niedowaga" = "#fef0d9",
                                         "Optimum" = "#fdcc8a",
                                         "Nadwaga" = "#fc8d59",
                                         "Otylosc" = "#d7301f")) +
            coord_flip() +
            ylab("Liczba")
        p
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
