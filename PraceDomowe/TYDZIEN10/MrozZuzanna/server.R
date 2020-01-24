library(shiny)
library(ggplot2)
library(RColorBrewer)

shinyServer(function(input, output) {
    
    dataset <- reactive({
        dragons[sample(nrow(dragons), input$sampleSize),]
    })
    
    output$plot <- renderPlot({
        
        p <- ggplot(dataset(), aes_string(x=input$x, y=input$y)) +
            theme(panel.grid = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank())
        
        if(input$geom == 'Point')
            p <- p + geom_point(alpha=0.5)
        if(input$geom == 'Line')
            p <- p + geom_line()
        if(input$geom == 'Density')
            p <- p + stat_density_2d(aes(fill = ..density..), geom = "raster", contour = FALSE) +
                scale_fill_distiller(palette = 'Oranges')   +
                scale_x_continuous(expand = c(0, 0)) +
                scale_y_continuous(expand = c(0, 0)) +
                theme(legend.position='none')
        if (input$color != 'None' && input$color != 'colour')
            p <- p + aes_string(color=input$color) + scale_color_gradient(low="black", high="orange")
        if (input$color == 'colour')
            p <- p + aes_string(color=input$color) + scale_color_manual(values = c("black", "blue", "green", "red"))
        if (input$jitter)
            p <- p + geom_jitter()
        if (input$smooth)
            p <- p + geom_smooth(color="orange", se = FALSE)
        if (input$facet)
            p <- p + facet_wrap(~ colour, ncol=2)
        
        print(p)
        
    })
    
})