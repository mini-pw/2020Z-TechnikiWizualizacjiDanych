library(ggplot2)

# dane przed wczytaniem wpisano ręcznie do osobnego pliku
dane <- read.csv("dane.csv")

p <- ggplot(dane, aes(x=reorder(nazwa, liczba), y=liczba)) +
  # kolumny
  geom_col(width=0.8, fill="#c0c0c0") +
  # zamiana współrzędnych
  coord_flip() +
  # nazwy wydarzeń i liczby przy kolumnach
  geom_text(aes(label=paste(nazwa, liczba, sep="\n")), hjust="inward", size=3, color="black") +
  # nazwy osi i tytuł
  labs(x="wydarzenie", y="liczba interwencji", title="Interwencje policji", subtitle="w dniu 7 X 2019") +
  # bez ostatniej linijki nazwy wydarzeń byłyby w dwóch miejscach każda
  theme(axis.text.y = element_blank())

cairo_ps("plot.eps", width = 10, height = 10)
p
dev.off()
