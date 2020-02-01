Aplikacja dla danych Wojtka:
https://piotrf.shinyapps.io/messenger_analize/

# Jak skorzystać z apliakcji na swoich danych?

Z góry przepraszamy za mało zautomatyzowany proces robienia tego na swoich danych, ale po prostu nei starczyło nam do tego wszystkeigo czasu, ale mam nadzieję, ze dacie sobie radę mimo tego.

1. Ściagnij swoje dane z facebooka - Settings => Your Facebook Information => Download Your Information =>
=> zaznaczacie tylko messengera, format JSON, media quality LOW i czekacie aż facebook Wam pozowli je ściągnąc (zazwyczaj ok. 4 -5h)
2. Ściągnięte dane przepuszczacie przez skrypt messenges_to_csv, dostajecie csvke
3. Tę csvke przepuszczacie przez skrypt_caly.R, który w foolderze aplikacja tworzy Wam folder dane_WaszeImie, gdzie poajwia się wszystkei potrzebne ramki danych
4. Modyfikujecie kod pliku app.R, tak aby Wasze dane się załadowały (14 - 20, 443 linijka)
5. Instalujecie dokładnie TĘ wersję wordclouda:
install.packages("https://cran.r-project.org/src/contrib/Archive/wordcloud2/wordcloud2_0.2.0.tar.gz", repos = NULL, type = "source")
6. Instalujecie rCharts tą komendą:
devtools::install_github('ramnathv/rCharts')
7. Instalujecie resztę bibliotek, których wymaga program, odpalacie aplikację i voilà - cieszycie się aplikacją opartą na Waszych danych. 

Gdybyście mieli jakieś problemy psizcie do mnie/Piotrka/Ady, postaramy się pomóc.

