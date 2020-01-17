library(shiny)
library(ggplot2)

ui <- fluidPage(

    titlePanel("Fewer children are dying from malaria"),


    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "colornum", label = "Aesthetic",
                        choices = c("1. Greens", "2. Teals", "3. Purples", "4. Reds", "5. Fire", "6. Water", "7. Dusk")),
            checkboxInput(inputId = "reverse", label = "I don't like children", value = FALSE),
            sliderInput(inputId = "boost", label = "Boost! Or don't.",
                        min = 0.1, max = 1.9, step = 0.3, value = 1)
            
        ),

        mainPanel(
           plotOutput("distPlot")
        )
    )
)


server <- function(input, output) {

    output$distPlot <- renderPlot({
        
        palette <- list( c("#2F394A", "#0B7053", "#09B44B", "#2AE12E", "#7BE86B"),
                         c("#004c4c", "#006666", "#008080", "#66b2b2", "#b2d8d8"),
                         c("#660066", "#800080", "#be29ec", "#d896ff", "#efbbff"),
                         c("#000000", "#400000", "#800000", "#bf0000", "#ff0000"),
                         c("#ff0000", "#ff4d00", "#ff7400", "#ff9a00", "#ffc100"),
                         c("#002bff", "#006bff", "#0092ff", "#00b8ff", "#01dfd9"),
                         c("#5732a8", "#9830b7", "#ed5eb7", "#ef87a9", "#ffbbb1"))
        
        data <- cbind(as.data.frame(c(627^input$boost^2,
                                      545^input$boost^2,
                                      431^input$boost^2,
                                      323^input$boost^2,
                                      288^input$boost^2)),
                      as.factor(c(2004,2007,2010,2013,2016)))
        colnames(data) <- c("Deaths","Year")
        
        orAreThey <- ""
        
        if(input$reverse==1){data$Deaths <- c(sample(150:300, 1)^input$boost^2,
                                              sample(300:500, 1)^input$boost^2,
                                              sample(500:800, 1)^input$boost^2,
                                              sample(800:1100, 1)^input$boost^2,
                                              sample(1100:1500, 1)^input$boost^2)
                            orAreThey <- "...Or are they?"}
        
        ggplot(data,aes(x=Year,y=Deaths,fill=Year)) + 
            geom_bar(stat="identity", width = 0.7,show.legend = FALSE) +
            geom_text(aes(label=round(Deaths)),vjust=-0.5, size=3.2) +
            scale_fill_manual(values = palette[[as.integer(substring(input$colornum,1,1))]]) +
            labs(subtitle = "Thousands of deaths per year", title = orAreThey) +
            theme(plot.title = element_text(face = "bold"),
                  panel.grid = element_blank(),
                  panel.border = element_blank(),
                  axis.text = element_text(size=9))


    })
}


shinyApp(ui = ui, server = server)
