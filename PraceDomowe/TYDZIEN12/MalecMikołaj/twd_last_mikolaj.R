
library(rpivotTable)

countries <- read.csv2( "Countries.csv", sep =",")[,-1]

rpivotTable(countries, 
            rows = "Name", 
            aggregatorName = "Sum", vals = "GDPPC", 
            rendererName = "Treemap")

rpivotTable(countries, 
            cols = "Literacy",
            rows = "InfantMortality", 
            aggregatorName = "First", vals = "Name", 
            rendererName = "Scatter Chart")
