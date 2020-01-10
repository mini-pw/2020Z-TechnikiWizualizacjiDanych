library(shiny)
library(r2d3)
library(colourpicker)
library(sp)


gen_frag_lancuch <- function(a,b,poly){
    #ax = b
    d <- data.frame( x = c(0,100), y = c(b, a*100+b) )
    l <- sp::Line(d)
    len <- sp::LineLength(l)
    coords <- sp::spsample(l, len/4, type = "regular") 
    
    p <- Polygons(list(Polygon(poly)),"poly")
    
    pp <- SpatialPolygons(list(p))
    srdf <- SpatialPolygonsDataFrame(pp, data.frame(cbind(1), row.names = 'poly'))
    
    inter <- over(coords, srdf)
    c <- coordinates(coords)[!is.na(inter$cbind.1.),]
    if(is.vector(c)){return(data.frame(x = c[1], y = c[2]))}
    if(dim(c)[1] == 0){return(data.frame(x = -10,y= -10))}
    colnames(c) <- c("x","y")
    return(c)
}

ui <- fluidPage(

    titlePanel("Choinka"),

    sidebarLayout(
        sidebarPanel(
            sliderInput("bomb",
                        "Ilość bombek:",
                        min = 1,
                        max = 50,
                        value = 15),
            sliderInput("r",
                        "Średnica bombek:",
                        min = 1,
                        max = 30,
                        value = 8),
            sliderInput("rl",
                        "Średnica lancucha:",
                        min = 1,
                        max = 14,
                        value = 6),
            colourInput("col",
                        "Kolor choinki: ",
                        value = "#1DA31D"),
            colourInput("colb",
                        "Kolor bombek: ",
                        value = "#D1C779"),
            selectInput("prog",
                        "Program łańcucha: ",
                        choices = c("Migoczący 2", "Migoczący 1","Stały")),
            conditionalPanel( condition = "input.prog.localeCompare(\"Stały\")",
                              numericInput("freq", "Częstość migotania", 520,  min = 10, max = 1000)),
            numericInput("a","Nachylenie łańcucha:", 0.5, min = -1,max=1)
        ),
            mainPanel(
            d3Output("choinka")
        )
    )
)

server <- function(input, output) {

    output[["choinka"]] <- renderD3({
        
        ziel <- sp::Polygon(data.frame(x = c(50,30,38,20,28,10,90,72,80,63,70),
                                       y = c(100,75,75,45,45,10,10,45,45,75,75)))
        
        coords <- coordinates(spsample(ziel, input[["bomb"]], type = 'random'))
        lancuch <- as.data.frame(rbind(gen_frag_lancuch(input$a, -70, ziel), 
                                       gen_frag_lancuch(input$a, -50, ziel),
                                       gen_frag_lancuch(input$a, -30, ziel),
                                       gen_frag_lancuch(input$a, -10, ziel),
                                       gen_frag_lancuch(input$a, 10, ziel),
                                       gen_frag_lancuch(input$a, 30, ziel),
                                       gen_frag_lancuch(input$a, 50, ziel),
                                       gen_frag_lancuch(input$a, 70, ziel)))
        
        # wyrownaj dlugosci coord i lancuch
        n = abs(dim(coords)[1] - dim(lancuch)[1])
        if(dim(coords)[1] > dim(lancuch)[1]){
            lancuch <- rbind(lancuch, data.frame( x = rep(lancuch[1,1],n), y = rep(lancuch[1,2],n))) 
        } else if(dim(coords)[1] < dim(lancuch)[1]){
            coords <- rbind(coords, data.frame(x = rep(coords[1,1],n), y = rep(coords[1,2],n))) 
        }
        kolory_l <- rep(c("green", "blue", "red", "yellow"), length.out = dim(lancuch)[1])
        r2d3(data.frame(  bombkx = coords$x,
                            bombky = coords$y,
                            col = input[["col"]],
                            colb = input[["colb"]],
                            r = input[["r"]],
                            rl = input[["rl"]],
                            prog = input[["prog"]],
                            lx = lancuch$x,
                            ly = lancuch$y,
                            coll = kolory_l,
                            freq = input$freq),
                            script = "choinka.js")})
}

shinyApp(ui = ui, server = server)
