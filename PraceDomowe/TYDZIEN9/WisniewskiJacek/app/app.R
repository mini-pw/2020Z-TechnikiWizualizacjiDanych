library(shiny)
library(ggplot2)
library(tidyverse)
library(shinythemes)
library(plotly)
library(colourpicker)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Import węgla do Polski"),

    # Sidebar with two colour panels and one checkbox
    sidebarLayout(
        sidebarPanel(
            colourInput("barColour1",
                        label = "Wybierz kolor kolumny pierwszej",
                        value = "cadetblue3"),
            colourInput("barColour2",
                        label = "Wybierz kolor kolumny drugiej",
                        value = "cornflowerblue"),
            checkboxInput('procent', 'Pokaż procentowe różnice', value = FALSE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotlyOutput("distPlot")
        )
    ),
    # Set theme
    theme = shinytheme("superhero")
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlotly({
        # Prepare data for drawing plot
        Kierunek <- c("USA", "Kolumbia", "Mozambik", "Australia", "Rosja")
        Import19 <- c(0.4, 0.5, 0.15, 0.7, 3.8)
        Zmiana <- c(-0.26, -0.29, -0.04, 0.66, 0.025)
        Import18 <- Import19 + Import19*(-Zmiana)
        Wzrost <- Import19 - Import18
        Zmiana <- as.character(paste(Zmiana*100, "%"))
        
        IW19 <- data.frame(Kierunek = Kierunek, Import = Import19, Rok = "2019")
        IW18 <- data.frame(Kierunek = Kierunek, Import = Import18, Rok = "2018")
        IW <- rbind(IW18, IW19)
        diff_iw <- data.frame(Kierunek, Import18, Import19, Wzrost, Zmiana)
        
        diff_iw <- diff_iw %>%
            mutate(Maximport = ifelse(Import18 > Import19, Import18, Import19), Wzrost = Wzrost < 0) %>%
            select(Kierunek, Maximport, Wzrost, Zmiana)
        
        # Draw plot
        p <- ggplot(IW, aes(Kierunek, Import))
        
        # Optionally draw differences
        if (input$procent) {
            p <- p + geom_bar(aes(y = Maximport + 0.1), data = diff_iw %>% filter(Wzrost == TRUE), stat = "identity", fill = NA, width = 0.4, colour = "red") +
                geom_bar(aes(y = Maximport + 0.1), data = diff_iw %>% filter(Wzrost == FALSE), stat = "identity", fill = NA, width = 0.4, colour = "green") +
                geom_text(aes(label = Zmiana, y = Maximport + 0.3), vjust=-1.5, data = diff_iw %>% filter(Wzrost == TRUE), colour = "red") +
                geom_text(aes(label = Zmiana, y = Maximport + 0.3), vjust=-1.5, data = diff_iw %>% filter(Wzrost == FALSE), colour = "green")
        }
        
        # Draw the rest of the plot
        p <- p +
            geom_bar(aes(fill = Rok), position = "dodge", stat="identity", width=0.8, colour = "grey20") +
            scale_fill_manual("", values = c("2018" = input$barColour1, "2019" = input$barColour2)) +
            ylab("Wielkość importu węgla (tony)") + xlab("Kraj pochodzenia")
        
        # Present plot as plotly
        ggplotly(p)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
