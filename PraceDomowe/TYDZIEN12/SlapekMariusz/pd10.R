library(rpivotTable)

olympiad <- read.csv2( "imo_results.csv", encoding = "UTF-8" ,sep =",")


rpivotTable(olympiad, 
            cols = "problem1", 
            aggregatorName = "Count", 
            rendererName = "Bar Chart")


rpivotTable(olympiad, 
            cols = "country", 
            aggregatorName = "Count", vals = "country", 
            rendererName = "Bar Chart")


rpivotTable(olympiad, 
            cols = "country", 
            aggregatorName = "Count", vals = "country", 
            rendererName = "Table")


rpivotTable(olympiad, 
            cols = "country", 
            aggregatorName = "Count", vals = "country", 
            rendererName = "Heapmap")


rpivotTable(olympiad, 
            aggregatorName = "Count", vals = "year", 
            rendererName = "Area Charts")