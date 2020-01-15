library(SmarterPoland)
library(rpivotTable)

rpivotTable(countries)

rpivotTable(countries, cols = "continent", aggregatorName = "Average", vals = "population", 
            rendererName = "Bar Chart")

rpivotTable(countries, cols = "continent", aggregatorName = "Average", vals = "population", 
            rendererName = "Table Barchart")

library(visNetwork)

nodes <- data.frame(id = 1:8, 
                    label = c("Abeta", "A-Syn",
                              "S100A9", "Insulin",
                              "HEWL", "PrP", 
                              "Tau", "CsgA"))

edges <- data.frame(from = c(2, 2, 2, 2, 3, 3, 3, 4, 4, 5, 2), 
                    to = c(6, 7, 3, 4, 4, 5, 6, 5, 6, 6, 8), 
                    color = "red",
                    label = "CI",
                    title = "Reference")

net <- visNetwork(nodes, edges, height = 1200, width = 1200) %>%
  visEdges(arrows = "from")  %>% 
  visLayout(randomSeed = 15390) 


# zapisywanie: visSave

library(DiagrammeR)

diagram <- "
graph TB
subgraph linreg
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
end
subgraph questions
A2[no questions]==>B2[no questions]
B2==>C2[no questions]
C2==>D2[no questions]
D2== yes ==>Eyes2[no questions]
D2== no ==>Eno2[no questions]
style A2 fill:#DCEBE3
style B2 fill:#77DFC9
style C2 fill:#DEDBBA
style D2 fill:#77DFC9
style Eyes2 fill:#DEDBBA
style Eno2 fill:#DEDBBA
end
"
DiagrammeR(diagram, type = "mermaid")
