library(dplyr)
library(ggplot2)
library(svglite)

data <- read.csv("twd pd 5.csv")
only_questions <- seq(3,27,3)
usable_data <- data[,only_questions]

t12 <- data.frame(value=round(usable_data[,1]/12,2),geom="Kołowy 3D")
t13 <- data.frame(value=round(usable_data[,2]/12,2),geom="Kołowy")
t14 <- data.frame(value=round(usable_data[,3]/12,2),geom="Słupkowy")
t1 <- rbind(t12,t13,t14)

t22 <- data.frame(value=round(usable_data[,4]/111,2),geom="Bąbelkowy")
t23 <- data.frame(value=round(usable_data[,5]/111,2),geom="Funnel3D")
t24 <- data.frame(value=round(usable_data[,6]/111,2),geom="Słupkowy")
t2 <- rbind(t22,t23,t24)
boxData <- rbind(t1,t2)


p <- ggplot(boxData,aes(x=geom,y=value,fill=geom))+
  geom_violin()+
  geom_boxplot(width=0.15)+
  coord_flip()+
  geom_line(aes(y=1),size=1,linetype = "dotted")+
  theme(
    panel.background = element_blank(),
    legend.position = ""
  )


svglite("plot.svg")
p
dev.off()
