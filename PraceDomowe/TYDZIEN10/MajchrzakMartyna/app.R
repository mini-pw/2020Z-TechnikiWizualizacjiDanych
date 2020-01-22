library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(r2d3)
library(plotly)

dragons <- miceadds::load.Rdata2("dragons.rda")

dragons1<-dragons%>%
  mutate(id=1:2000)%>%
  mutate(year_of_death=year_of_birth+life_length)%>%
  mutate(alive=case_when(
    year_of_death >= 2020 ~ "Alive",
    TRUE ~ "Dead"
  ))%>%
  arrange(year_of_birth)

alive_dragons<-dragons1%>%
  filter(alive=="Alive")%>%
  group_by(colour)%>%
  summarise(count=n())

all<-alive_dragons%>%
  summarise(count=sum(count))%>%
  mutate(colour="all")%>%
  select(2,1)

alive_dragons<-rbind(alive_dragons,all)%>%
  arrange(count)

smths_wrong<-dragons1%>%
  filter(year_of_discovery<year_of_birth)%>%
  mutate(id=1:28)

ui <- fluidPage(theme = shinytheme("superhero"),
                mainPanel(
                  tabsetPanel(
                    tabPanel("Alive Dragons",
                             titlePanel(title = "Are dragons still around in 2020?!"),
                             sidebarPanel(checkboxGroupInput(inputId = "chooseStatus", label = "Show dragons:", 
                                                             choices = unique(dragons1[["alive"]]),
                                                             selected = unique(dragons1[["alive"]]
                                                             ))),
                             plotOutput(outputId = "ggplot", height = "600px")
                    ),
                    tabPanel("How many of them?",
                             titlePanel(title = "How many dragons of each colour are left?"),
                             d3Output(outputId = "d3", height = "600px")),
                    tabPanel("Can scientist tell the future?",
                             titlePanel(title = "Not only predicting when they'll die, but also when they'll be born"),
                             plotlyOutput(outputId = "plotly"))
                    
                  )
                )
)

server <- function(input, output) {
  
  output[["ggplot"]] <- renderPlot({
    
    values<-reactiveValues()
    values$status<-input[["chooseStatus"]]
    dragons1%>%
      filter(alive %in% values$status)%>%
    ggplot()+
      geom_segment( aes(x=id, xend=id, y=year_of_birth, yend=year_of_death), color="grey") +
      geom_point( aes(x=id, y=year_of_birth, colour=alive), size=2 ) +
      geom_point( aes(x=id, y=year_of_death, colour=alive),  size=2 ) +
      coord_flip()+
      facet_wrap(~colour, nrow=2)+
      ggtitle("Dragons in 2020")+
      xlab("")+
      ylab("Year of birth")+
      guides(colour=guide_legend(title="Status"))+
      ylim(-2000,4800)+
      theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
  })
  
  output[["d3"]] <- renderD3({
    
    r2d3(data = data.frame(alive_dragons),script = "script.js")
    })
  
  output[["plotly"]]<-renderPlotly({
    ggplot(smths_wrong)+
      geom_segment( aes(x=id, xend=id, y=year_of_birth, yend=year_of_death), color="grey") +
      geom_point( aes(x=id, y=year_of_discovery, colour="Discovery"),  size=2 ) +
      geom_point( aes(x=id, y=year_of_birth, colour="Birth"), size=1.5 ) +
      geom_point( aes(x=id, y=year_of_death, colour="Death"),  size=1.5 ) +
      coord_flip()+
      ggtitle("Dragons discovered before they were even born")+
      xlab("")+
      ylab("Year of birth")+
      guides(colour=guide_legend(title=""))+
      theme_classic()+
      theme(
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())
  })

}

  



shinyApp(ui = ui, server = server)
