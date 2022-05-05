library(shiny)
library(tidyverse)
library(wordcloud)
library(wesanderson)
library(tm)
source("ui.R")
source("server.R")

bandung_data <- read.csv("data/bandung_data.csv", na.strings="")

shinyApp(ui = ui, server = server)
