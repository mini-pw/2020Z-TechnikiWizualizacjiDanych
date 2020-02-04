###not run
#filmy revenue / budget
output$films_rb <- plotlyOutput({
  
  t <- list(
    family = "sans serif",
    size = 14,
    color = toRGB("grey50"))
  
  s = input$tbl_rows_selected
  
  d <- data_period_r()
  if (length(s)){
    d <- d[ s,]
  }
  
  end_polot <- min( c( max( d$budget), max( d$revenue / 2.4)))
  
  p<- plot_ly( data = d, x = ~budget, y = ~revenue,
               text = ~title,
               hovertemplate = paste('<b>%{text}</b><br>',
                                     '<i>Revenue</i>: $%{y}<br>',
                                     '<i>Budget</i>: %{x}<br>'
               )
  ) %>%
    layout(
      #nazwy osi
      title = list(text="Revenue vs Budget",x=0.5),
      yaxis = list( title = "Revenue"),
      xaxis = list( title = "Budget"),
      showlegend = FALSE
    ) %>%
    add_segments( x = 0, y = 0, xend = end_polot, yend = end_polot *2.4) %>%
    add_trace(mode = 'markers') %>%
    add_text(textfont = list(family = "sans serif",size = 14,color = toRGB("grey50")),
             textposition = "top right")
  
  p
})
