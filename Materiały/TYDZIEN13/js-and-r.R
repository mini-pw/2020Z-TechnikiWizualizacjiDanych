library(SmarterPoland)
library(rpivotTable)


head(countries)
qnt <- quantile(countries$birth.rate, na.rm = TRUE)
countries$birth.rate.quant<- cut(countries$birth.rate, unique(qnt), include.lowest=TRUE)

rpivotTable(countries)

rpivotTable(countries, 
            cols = "continent", 
            aggregatorName = "Average", vals = "population", 
            rendererName = "Bar Chart")

rpivotTable(countries, cols = "continent",
            rows = "birth.rate.quant",
            aggregatorName = "Average", vals = "population", 
            rendererName = "Table Barchart")


# Zadanie 1
# a) Wygenerować plik R Markdown z trzema różnymi tabelami przestawnymi.
# b) Przygotować aplikację Shiny pozwalającą załadować własny zbiór danych.










library(visNetwork)

nodes <- data.frame(id = 1:8, 
                    label = c("Białystok", "Warszawa",
                              "Radom", "Sosnowiec",
                              "Kraków", "Wrocław", 
                              "Gdańsk", "Lądek Zdrój"))

edges <- data.frame(from = c(2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 2), 
                    to = c(6, 7, 3, 4, 4, 5, 6, 5, 6, 6, 8), 
                    color = "red",
                    label = "droga",
                    title = "Miasta")

net <- visNetwork(nodes, edges, height = 600, width = 1000) %>%
  visEdges(arrows = "from")  %>% 
  visLayout(randomSeed = 123) 

net



# Zadanie 2
# Stworzyć własny graf przedstawiający stacje metra w Warszawie (obie linie) i zapisać go do pliku html (funkcja visSave).







library(DiagrammeR)

diagram <- "
graph TB
A[raw sample]==>B{set baseline to <br/> minimum observation}
B== BL != 0 ==>C[substract baseline]
C==>D{check for amplification <br/> Samples are skipped when less than seven times <br/> increase in fluorescence values is observed}
D== yes ==>Eyes[Determine SDM cycle: <br/> end of the exponential phase <br/> the approximate derivative is a difference of two values]
D== no ==>Eno[skip sample]
Eyes==>F[Move to Part I]
B== BL != 0 ==>Cbis[if the observed minimum fluorescence is 0 <br/> and machine BL is constant, add any value. <br/> Get raw values in case of baseline trend]
style A fill:#DCEBE3
style B fill:#77DFC9
style C fill:#DEDBBA
style Cbis fill:#DEDBBA
style D fill:#77DFC9
style Eyes fill:#DEDBBA
style Eno fill:#DEDBBA
"
DiagrammeR(diagram, type = "mermaid")


# Zadanie 3
# Odtworzyć drzewo https://www.sqlshack.com/wp-content/uploads/2019/09/sample-of-a-decision-tree.png






