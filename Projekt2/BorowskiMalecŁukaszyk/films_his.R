###not run
#histogram profitów
output$hisProf <- renderPlot({
  ggplot( data_period_r(), aes(groupProfit)) + geom_bar() + xlab("Profit $")
})
