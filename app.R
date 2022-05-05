library(shiny)
library(shinythemes)
library(tidyverse)
library(wordcloud2)
library(tm)
source("ui.R")
source("server.R")

bandung_data <- read.csv("data/bandung_data.csv", na.strings="")

shinyApp(ui = ui, server = server)
