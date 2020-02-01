library(SmarterPoland)
library(ggplot2)

p <- ggplot(countries, aes(x = continent)) +
  geom_bar(alpha = 0.5)

cairo_ps("p1.eps", width = 10, height = 10)
p
dev.off()

# cairo_pdf

library(svglite)

svglite("p2.svg", width = 10, height = 10)
p
dev.off()
# alternatywa svg


