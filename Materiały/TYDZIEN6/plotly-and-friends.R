library(dplyr)
library(ggplot2)
library(SmarterPoland)
library(plotly)

# plotly ------------------------

p <- ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point()

ggplotly(p)

# obrazki rasterowe w ggplot2 ---------------------------

library(magick)

dat <- data.frame(variable = c("Liczba studentów", "Liczba pracowników"),
                  value = c(1000, 153))

p <- ggplot(dat, aes(x = variable, y = value)) +
  geom_col() + 
  theme_bw() +
  scale_x_discrete("") +
  scale_y_continuous("")


mini <- image_read("https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Gmach_Wydzia%C5%82u_MiNI.jpg/467px-Gmach_Wydzia%C5%82u_MiNI.jpg")

mini_mini <- mini %>%
  image_scale("140") %>% 
  image_border("grey", "50x50") %>%
  image_annotate("MiNI", color = "black", size = 40, 
                 location = "+0+10", gravity = "north")

p + annotation_raster(as.raster(mini_mini), 0.75, 1.25, 400, 800)

# obrazki w geometriach ------------------------------

library(rsvg)
library(ggimage)

dat <- data.frame(kraj = c("Niemcy", "Polska", "Dania"),
                  populacja = c(82793800, 38433600, 5749000),
                  flaga = c("https://upload.wikimedia.org/wikipedia/commons/b/ba/Flag_of_Germany.svg",
                            "https://upload.wikimedia.org/wikipedia/en/1/12/Flag_of_Poland.svg",
                            "https://upload.wikimedia.org/wikipedia/commons/9/9c/Flag_of_Denmark.svg"))

ggplot(dat, aes(x = kraj, y = populacja, image = flaga)) + 
  geom_image(size = .05) 

# waffle ----------------------
# devtools::install_github("liamgilbey/ggwaffle")
library(ggwaffle)
library(emojifont)  
library(dplyr)
library(SmarterPoland)

mutate(countries, continent = as.character(continent)) %>% 
  waffle_iron(aes_d(group = continent)) %>% 
  ggplot(aes(x, y, fill = group)) + 
  geom_waffle() + 
  coord_equal() + 
  scale_fill_waffle() + 
  theme_waffle()

# alternatywa: 
# https://github.com/hrbrmstr/waffle

# łatwe annotacje wykresow ---------------------------

# devtools::install_github("bbc/bbplot")
library(bbplot)

p <- ggplot(data = countries, aes(x = continent, y = death.rate, color = continent)) +
  geom_boxplot() +
  bbc_style()

finalise_plot(plot_name = p,
              source = "Source: PW",
              save_filepath = "bbplot.png",
              width_pixels = 640,
              height_pixels = 550)
