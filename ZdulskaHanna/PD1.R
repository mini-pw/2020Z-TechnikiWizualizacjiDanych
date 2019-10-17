---
title: "PD1"
author: "Hanna Zdulska"
date: "10/13/2019"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

```{r}
#install.packages('USAboundaries')
#install.packages('elevatr')
#install.packages('ggridges')

library(USAboundaries)
library(elevatr)
library(sf)
library(ggplot2)
library(dplyr)
library(ggridges)

```

# Przygotowanie danych
```{r}
