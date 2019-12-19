
var <- mpg$class # the categorical data 

## Prep data (nothing to change here)
nrows <- 10
df <- expand.grid(y = 1:nrows, x = 1:nrows)
categ_table <- round(table(var) * ((nrows*nrows)/(length(var))))
vec = c("Cabrio","Kompakt","Sedan","Minivan","Pickup","Miejski","SUV")

df$category <- factor(rep(names(categ_table), categ_table))  
# NOTE: if sum(categ_table) is not 100 (i.e. nrows^2), it will need adjustment to make the sum to 100.
categ_table <- as.data.frame(categ_table)
categ_table$var <- vec
## Plot
a1 <- ggplot(df, aes(x = x, y = y, fill = category)) + 
  geom_tile(color = "black", size = 0.5) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0), trans = 'reverse') +
  scale_fill_brewer(palette = "Set3",labels = vec) +
  labs(title="", subtitle="",x="",y="")+
  theme(axis.text = element_blank(),
        legend.title = element_blank(),
        axis.ticks = element_blank())
ggsave("wafel.png",a1)

a2 <- ggplot(categ_table, aes(x = var,y=Freq,fill=var)) +
  geom_bar(stat = 'identity',color='black')+
  scale_fill_brewer(palette = "Set3")+
  theme_minimal()+
  labs(title="", subtitle="",x="",y="")+
  theme(axis.text = element_blank(),
        axis.ticks = element_blank(),
        legend.title = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank())
ggsave("bar.png",a2)


a3 <- ggplot(categ_table, aes(x = "", y=Freq, fill = var)) + 
  geom_bar(width = 1, stat = "identity") +
  theme(axis.line = element_blank(), 
        plot.title = element_text(hjust=0.5))+
  coord_polar(theta = "y", start=0)+
  labs(title="", subtitle="",x="",y="")+
  scale_fill_brewer(palette= "Set3")+
  theme(axis.text = element_blank(),
        legend.title = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank(),
        panel.grid.major = element_blank())


jpeg(filename="./cos.jpg")
pie3D(categ_table$Freq,labels=categ_table$var)
dev.off()

