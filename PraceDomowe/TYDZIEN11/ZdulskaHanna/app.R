library(shiny)
library(visNetwork)
source("blackout.R")

#' @inproceedings{nr,
#'     title={The Network Data Repository with Interactive Graph Analytics and Visualization},
#'     author={Ryan A. Rossi and Nesreen K. Ahmed},
#'     booktitle={AAAI},
#'     url={http://networkrepository.com},
#'     year={2015}
#' }

ui <- fluidPage(

    titlePanel("US Blackout Scenario"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("lim",
                        "Sample:",
                        min = 1,
                        max = 6594,
                        value = 100),
            numericInput("kill",
                        "Choose power plant to disturb: ",
                        min = 1,
                        max = 100,
                        value = 42)
        ),
        mainPanel(
            textOutput("info"),
           visNetworkOutput("net")
        )
    )
)

server <- function(input, output, session) {
    
    observeEvent(input$lim,{
        updateNumericInput(session, "kill", "Choose power plant to disturb: ", max = input$lim)
    })
    output$info <- renderText("W książce 'Blackout' Marc Elsberg opisuje potencjalny scenariusz, w którym Europa zostaje pozbawiona prądu w wyniku destablilizacji sieci enegretycznej. Ponieważ spora część elektrowni europejskich jest połączona ze sobą, by mógł zachodzić transer nadwyżek enegii, Mark Elsberg pokazuje, że gdy wyłączy się jedną z nich i cała energia zostaje przetransferowana do połączonych elektrowni zachodzi efekt domina, w wyniku czego dochodzi do globalnej katastrofy. Zainspirowana tą wizją, przy pomocy danych z http://networkrepository.com/power-US-Grid.php zwizualizowałam potencjalne destabilizacje elektrowni w USA. Niestety brakuje w nich identyfikatorów oraz produkcji prądu, dlatego przyjęłam prostą zasadę - im więcej połączeń - tym większa produkcja prądu oraz jego pojemność, dokładne dany można zobaczyć na tooltipie.")
    output$net <- renderVisNetwork({
        kill <- input$kill
        lim <- input$lim
        m <- get_m(lim = lim)
        nei <- get_neighbours_wrapped(lim = lim)
        m_destabed <- destab(m,kill,nei)
        
        group <- ifelse(m_destabed$is_active, "Stable", "Disrupted")
        group[kill] <- "Killed"
        
        
        nodes <- data.frame(id = 1:lim,
                            group = group,
                            label = paste("Power plant ",1:lim),
                            title = paste0("<p>","Power plant no ", 1:lim,
                                           ",Power held: ", m_destabed$p,
                                           ",Capacity: ", m_destabed$capacity,
                                           "</p>"),
                            value = m$p*3
        )
        edges <- get_M(lim = lim)
        visNetwork(nodes, edges) %>%
            visEvents(type = "once", startStabilizing = "function() {
            this.moveTo({scale:0.37})}") %>%
            visPhysics(stabilization = FALSE) %>%
            visLayout(randomSeed = 667)  %>%
            visGroups(groupname = "Stable", color = "#43a2ca") %>%
            visGroups(groupname = "Killed", color = "red") %>%
            visGroups(groupname = "Disrupted", color = "orange") %>%
            visLegend()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
