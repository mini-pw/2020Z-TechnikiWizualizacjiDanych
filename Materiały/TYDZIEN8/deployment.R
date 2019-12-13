  # install.packages("rsconnect")
# token: https://www.shinyapps.io/
rsconnect::setAccountInfo(name='plentycoups',
                          token='F03F1AE32FC36F11A51A0BB76B07BBEB',
                          secret='lNmNNL6jpVYWB1jVmcInHKuAj6Hy55jaPu1KjWxW')
rsconnect::deployApp(appDir = "Materiały/TYDZIEN8/SimpleObserver/")