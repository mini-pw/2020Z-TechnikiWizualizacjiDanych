library("shiny")
library("visNetwork")

###
#
#   App can take a few minutes to display nodes and it's quite laggy 
#   Since data provided by http://networkrepository.com/ contained only edges 
#   (and that seems to be the case for all datasets),
#   nodes display only numbers, which have no meaning. 
#
###

ui <- fluidPage({
  #Show network created by server
  visNetworkOutput("network", height = "950px")
})

server <- function(input,output){
  
  #Create edges data frame
  edges <- read.table("inf-euroroad.edges", skip=2, sep=" ")
  colnames(edges) <- c("from","to")
  edges$color="black"
  
  #Create node dataframe
  max_nodes <- max(dat[1])
  nodes <- data.frame(id = 1:max_nodes,
                      label=paste("ID:",1:max_nodes),
                      color="grey"
                      )
  
  
  output$network <- renderVisNetwork({
    
    #Create network
    visNetwork(nodes, edges, width = "100%",height = "1080px", main= "Sieć dróg w Europie")%>%
      visOptions(highlightNearest = TRUE)%>%
      visInteraction(navigationButtons = TRUE)%>% 
      visOptions(manipulation = TRUE)%>% 
      visInteraction(dragNodes = FALSE, dragView = TRUE, zoomView = TRUE)
  })
}

shinyApp(ui=ui,server=server)