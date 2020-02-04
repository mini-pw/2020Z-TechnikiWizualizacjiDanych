library(shiny)
library(shinythemes)
library(dplyr)
library(dplyr)
library(colorRamps)

df<-read.table("rt-retweet.mtx")

ui <- fluidPage(theme = shinytheme("superhero"),
                titlePanel(
                  h1("Retweet network")
                ),
                sidebarPanel(
                  title("Retweet network"),
                  selectInput(inputId = "label_type", label="Koloruj wg liczby krawędzi",
                              choices = c("wszystkich", "wchodzących", "wychodzących"),
                              selected = "wszystkich")
                ),
                mainPanel(
                  visNetworkOutput(outputId = "tweeter")
                )
                )


server <- function(input, output) {
  output$tweeter<-renderVisNetwork({
    n=max(max(df$V1, df$V2))
    color1a <- df%>%
      group_by(V1)%>%
      summarise(count=n())
    
    color1b<-df%>%
      group_by(V2)%>%
      summarise(count=n())
    
    if(input$label_type=="wszystkich"){
      color1<-data.frame(V=1:n)%>%
        full_join(color1a, by=c("V"="V1"))%>%
        full_join(color1b, by=c("V"="V2"))%>%
        mutate_all(~replace(., is.na(.), 0))%>%
        arrange(V)%>%
        transmute(count=count.x+count.y)
    }
    if(input$label_type=="wchodzących"){
      color1<-data.frame(V=1:n)%>%
        full_join(color1a, by=c("V"="V1"))%>%
        mutate_all(~replace(., is.na(.), 0))%>%
        arrange(V)
    
    }
    if(input$label_type=="wychodzących"){
      color1<-data.frame(V=1:n)%>%
        full_join(color1b, by=c("V"="V2"))%>%
        mutate_all(~replace(., is.na(.), 0))%>%
        arrange(V)
      
    }
    
    
    colorvector1<-color1[["count"]]
    colorscale1<-ygobb(max(colorvector1)+1)
    
    nodes1 <- data.frame(id = 1:n,
                         shape = "icon", 
                         icon = list(code = "f007", 
                                     color = colorscale1[colorvector1+1],
                                     size=7*colorvector1+25)
    )
    
    
    edges1 <- data.frame(from = df$V1, 
                         to = df$V2
    )
    
    
      net1 <- visNetwork(nodes1, edges1, height = 600, width = 1000) %>%
        visEdges(arrows = "from")%>% 
        visInteraction(navigationButtons = TRUE)%>%
        addFontAwesome()
    
    
    
    net1
  })
  
}





shinyApp(ui = ui, server = server)
