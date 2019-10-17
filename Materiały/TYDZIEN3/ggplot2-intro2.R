ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_quasirandom() +
  geom_point(data = group_by(countries, continent) %>% summarise(mean.death.rate = mean(death.rate)),
             aes(y = mean.death.rate), color = "red", size = 4)

ggplot(data = countries, aes(x = continent, y = death.rate)) +
  geom_quasirandom() +
  geom_point(data = group_by(countries, continent) %>% summarise(mean.death.rate = mean(death.rate)),
             aes(x = continent, y = mean.death.rate), color = "red", size = 4, inherit.aes = FALSE)

# 3b Adekwatność geometrii ------------------------------ 
# wykresy gestosci bywaja czytelniejsze niz punktowe w przypadku duzej liczby punktow
ggplot(countries, aes(x = birth.rate, y = death.rate, color = continent)) +
  geom_point()

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  geom_density_2d(color = "black", contour = TRUE) +
  geom_point()

ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  geom_density_2d(color = "black", contour = TRUE)

# wykorzystujemy stat, a nie geom, poniewaz interesuje nas inna geometria (polygon)
ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  stat_density_2d(color = "black", contour = TRUE, geom = "polygon")

ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  stat_density_2d(aes(alpha = ..level..), color = "black", contour = TRUE, geom = "polygon")

# wykresy zyskuja poprzez pokazanie linii trendu

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

# skrajne przypadki mozna podpisac
na.omit(countries) %>% 
  mutate(label.for.plot = ifelse(birth.rate %in% range(birth.rate) | death.rate %in% range(death.rate),
                                 country, "")) %>% 
  ggplot(aes(x = birth.rate, y = death.rate, label = label.for.plot)) +
  geom_point() +
  geom_text_repel()


# 3. Panele (facets) ---------------------------------
ggplot(countries, aes(x = birth.rate, y = death.rate, fill = continent)) +
  stat_density2d(aes(alpha = ..level..), color = "black", contour = TRUE, geom = "polygon") +
  facet_wrap(~ continent)

ggplot(countries, aes(x = birth.rate, y = death.rate)) +
  stat_density2d(aes(alpha = ..level..), color = "black", contour = TRUE, geom = "polygon") +
  facet_wrap(~ continent)
