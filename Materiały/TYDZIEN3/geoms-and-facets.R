
library(ggplot2)
library(SmarterPoland)
library(dplyr)

# Otwarte pytania

library(latex2exp)

ggplot() +
  ggtitle(TeX("$\\degree ugabuga$"))


set.seed(1410)
dat <- data.frame(imie = c("Michal", "Michalina", "Michail"),
                  losowa_liczba = sample(1L:100, 3))

mutate(dat, imie = factor(imie, levels = rev(levels(imie)))) %>% 
  ggplot(aes(x = imie, y = losowa_liczba, label = losowa_liczba)) +
  geom_col() +
  geom_text(aes(y = losowa_liczba*0.8), color = "white") +
  scale_y_continuous(labels=scales::percent)

# 1. Adekwatność geometrii ------------------------------ 
# wykresy gestosci bywaja czytelniejsze niz punktowe w przypadku duzej liczby punktow
ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point()

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_density_2d(color = "black", contour = TRUE) +
  geom_point()

ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  geom_density_2d(color = "black", contour = TRUE)

# 2. Geom i stat
# wykorzystujemy stat, a nie geom, poniewaz interesuje nas inna geometria (polygon)
ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  stat_density_2d(color = "black", contour = TRUE, geom = "polygon")

ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  stat_density_2d(aes(alpha = ..level..), color = "black", contour = TRUE, geom = "polygon")

ggplot(countries, aes(x = continent)) + 
  geom_bar()

ggplot(countries, aes(x = continent, y = death.rate)) + 
  stat_summary(fun.y = "length", geom = "bar")

ggplot(countries, aes(x = continent, y = birth.rate)) + 
  stat_summary(fun.y = "length", geom = "point")

library(ggbeeswarm)
ggplot(countries, aes(x = continent, y = birth.rate)) + 
  geom_quasirandom(method = "smiley") +
  stat_summary(fun.y = "mean", geom = "point", color = "red", size = 6)

ggplot(countries, aes(x = continent, y = birth.rate)) + 
  stat_summary(fun.y = "median", geom = "bar")

ggplot(countries, aes(x = birth.rate)) + 
  stat_bin(geom = "bar")

ggplot(countries, aes(x = birth.rate)) + 
  geom_histogram()

# linie trendu

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() 

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  geom_smooth() 

ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point() + 
  geom_smooth() 

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_point() + 
  geom_smooth(se = FALSE) 

# 3. Panele (facets) ---------------------------------
ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  stat_density2d(aes(alpha = ..level..), color = "black", contour = TRUE, geom = "polygon") +
  facet_wrap(~ continent)

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_density_2d() +
  facet_wrap(~ continent)

set.seed(16182019)
small_diamonds <- diamonds[sample(1L:nrow(diamonds), size = 500), ]

p <- ggplot(small_diamonds, aes(x = cut, y = price)) +
  geom_boxplot()

p + facet_wrap(~ clarity)

p + facet_wrap(~ clarity, scales = "free_x")

p + facet_wrap(~ clarity, scales = "free_y")

p + facet_wrap(~ clarity, scales = "free")

p + facet_wrap(~ clarity + color, drop = FALSE)

p + facet_wrap(~ clarity + color, labeller = label_both)

p + facet_wrap(~ clarity, nrow = 1)

p + facet_grid(clarity ~ color)

p + facet_grid(color ~ clarity, scales = "free_y")

mutate(small_diamonds, troche_srednio = price > 10000) %>% 
  ggplot(aes(x = cut, y = price)) +
  geom_boxplot() +
  facet_grid(color ~ clarity + troche_srednio, drop = FALSE)

p + facet_grid(clarity ~ color, switch = "x")

p + facet_grid(clarity ~ color, switch = "y")

p + facet_grid(clarity ~ color, switch = "both")

p + facet_grid(clarity ~ color, margins = c("clarity", "color"))

as.symbol("x")

lapply(list(list(mean, sd, "mean"), list(median, mad, "median")), function(ith_fun) {
  lapply(c("birth.rate", "death.rate"), function(i) {
    countries %>% 
      select(-population, -country) %>% 
      group_by(continent) %>% 
      summarise(y = ith_fun[[1]](!!as.symbol(i), na.rm = TRUE), 
                disp = ith_fun[[2]](!!as.symbol(i), na.rm = TRUE)) %>% 
      mutate(ymax = y + disp, ymin = y - disp,
             type = ith_fun[[3]],
             what = i)
  }) %>% bind_rows()
}) %>% bind_rows() %>% 
  ggplot(aes(x = continent, y = y, 
             ymax = ymax, ymin = ymin, color = type)) +
  geom_point() +
  geom_errorbar() +
  facet_wrap(~ what)


# 4. Transformacje danych
library(ggrepel)

# skrajne przypadki mozna podpisac
na.omit(countries) %>% 
  mutate(label_for_plot = ifelse(birth.rate %in% range(birth.rate) | death.rate %in% range(death.rate),
                                 country, "")) %>% 
  ggplot(aes(x = birth.rate, y = death.rate, label = label_for_plot)) +
  geom_point() +
  geom_text_repel()