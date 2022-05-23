library(shiny)
library(shinythemes)
library(tidyverse)
library(wordcloud2)
library(tm)

bandung_data <- read.csv("data/bandung_data.csv", na.strings="")

ui <- fluidPage(
  tags$head(tags$style( 
    HTML("
    @import url('https://fonts.googleapis.com/css2?family=Inter&display=swap');
      .tab-content {margin:50px 100px;}
      h1, h4 {font-family: 'Inter', sans-serif;}
      body {font-family: 'Inter', sans-serif; margin: 40px 0px; padding: 10px 0px;}
         "))),
  theme = shinythemes::shinytheme("slate"),
  h1("1955 Bandung Asian-African Conference Bulletins", 
     align="center",),
  h4("A Visual Summary" |> str_to_upper(), align="center", 
     style="color:#A3A3A3;margin-bottom:25px;"),
  div(tabsetPanel(
    # Word cloud tab
    tabPanel(
      title = "Word Cloud",
      sidebarLayout(
        sidebarPanel(
          h4("Content Filters"),
          br(),
          selectInput(
            inputId = "topic",
            label = strong("Bulletin content topic"),
            choices = c("All", "general", "purpose", "communique", "press", "address"),
          ),
          
          # Select dual nationality subtopic
          checkboxInput(
            inputId = "dualNationality",
            label = strong("Show only Sino-Indonesia dual nationality related content")
          ),
          
          checkboxInput("removeWords", strong("Remove specific words?"), FALSE),
          conditionalPanel(
            condition = "input.removeWords == 1",
            textAreaInput("wordsToRemove", "Words to remove (separated by comma)", rows = 1)
          ),
          
          # Display select press region only if press is checked
          conditionalPanel(
            condition = "input.topic.indexOf('press') > -1",
            checkboxGroupInput(
              inputId = "pressRegion",
              label = "Press region",
              choices = c("Asia and Africa", "Australia", "Europe", "America")
            )),
          
          # Select Delegates
          selectInput(
            inputId = "delegateHead",
            label = "Delegate head",
            choices = c("All", unique(bandung_data$delegate)[2:35] |> sort())
          ),
          conditionalPanel(
            condition = "input.topic.indexOf('address') > -1",
            radioButtons(
              inputId = "addressType",
              label = "Opening or closing address",
              choices = c("All", "Opening", "Closing")
            )),
          br(),
          br(),
          p("View the dataset and code on the ", a(href="https://github.com/yauyenching/bandung-bulletins", "GitHub repo."))
        ),
        mainPanel(wordcloud2Output("wordcloud", width = "100%"))
      )
    ),
    
    # About Bandung Conference panel
    tabPanel(
      title = "About the Bandung Conference",
      fluidRow(
        column(4, img(src="https://images.news18.com/ibnlive/uploads/2017/08/Bandung-Conference.jpg?impolicy=website&width=510&height=356", 
                      style="display:block;margin-left:auto;margin-right:auto;width:100%")),
        column(
          8, 
          h4(strong("What is the Bandung Conference?"), align="center"),
          br(),
          p("
In April, 1955, 
delegates from 29 Asian and African countries and regions
gathered in Bandung, Indonesia to discuss navigating a postcolonial world
and call for greater solidarity, mutual respect, non-aggression, and equality.
This event, the Bandung Confernce (also known as the Asian-African Conference), marked an emerging community of developing nations, many of which were 
newly independent from colonial powers.
Today, the Bandung Conference is recognized as a key example of international Afro-Asian solidarity and one of the
largest cooperative efforts between Third World countries to articulate a shared vision
in the face of great world powers."),
          br(),
          h4(strong("What is this Project?"), align="center"),
          p("
This project aims to provide an accessible visual summary of the conference
bulletin contents which were made publicly available by the Indonesian ministry
of information. PDFs of the bulletins can be accessed ",
            a(href="https://bandung60.wordpress.com/bandung-bulletin/", "here."),
            "
Each issue contained conference documents, delegate addresses, summaries of world
press opinions, and other material.
            ",
          ),
          p("
I digitized the contents (leaving out delegate profiles and conference logistics)
which can be found ",
            a(href="https://github.com/yauyenching/bandung-bulletins/tree/main/document_text", "here."),
            "
Then, I produced an interactive word cloud to provide a visual summary of the most",
            strong(" frequent words "),
            "
in the bulletin text. We removed the word 'conference' from the output.
The text can be filtered according to content categories, delegate head,
and press region. You can also remove specific
words from the word cloud through text input.
            "),
          p("
This project is not perfect. The word cloud does not dynamically resize in the event
of window resizing, so one should refresh the browser page to resize the word cloud.
In the event the word cloud disappears/ceases to load, one should refresh the page
as well. Currently, there is no plan to revisit these issues.
In addition, my digitization of the bulletin documents is not fully accurate due to the
low quality of the PDFs, so mispelled words (e.g., 'asianafrican') can be found which
may have affected the accuracy of the output. However, I found the digitized text to be
mostly accurate.
            ")
        )
      )
    )
  )),
  p("Built with ❤️ by Yau Yen Ching ", 
    a(href="https://github.com/yauyenching", icon("github")), 
    a(href="https://www.linkedin.com/in/yau-yen-ching/", icon("linkedin")),
    align="center", 
    style="position: relative;")
)

server <- function(input, output) {
  set.seed(42)
  create_wordcloud <- function(word_data) {
    text <- word_data$text
    text <- iconv(text, to = "UTF-8")
    docs <- Corpus(VectorSource(text))
    docs <- docs %>%
      tm_map(removeNumbers) %>%
      tm_map(removePunctuation) %>%
      tm_map(stripWhitespace)
    docs <- tm_map(docs, content_transformer(tolower))
    words_to_remove <- 
      if (input$removeWords) {
        str_split(input$wordsToRemove, ",")[[1]]
      } else {
        NA
      }
    docs <- tm_map(docs, removeWords, c("conference", words_to_remove, stopwords("english")))
    
    dtm <- as.matrix(TermDocumentMatrix(docs)) 
    words <- sort(rowSums(dtm),decreasing=TRUE) 
    df <- data.frame(word = names(words),freq=as.numeric(words))
    row.names(df) <- NULL
    df
    
    col_palette <- wesanderson::wes_palette("GrandBudapest2", 8, type = "continuous")
    col_palette <- rev(col_palette)
    col_palette <- rep(col_palette, times = c(1,3,6,10,12,15,20,35))
    
    wordcloud2(
      data = df |> head(100),
      fontFamily = "Century Gothic",
      color = col_palette,
      shape = 'circle',
      shuffle = FALSE,
      size = 0.65,
      backgroundColor = "#272B30"
    )
  }
  
  selected_topics <-
    reactive(if (is.null(input$topic)) {
      unique(bandung_data$topic)
    } else {
      input$topic
    })
  selected_regions <-
    reactive(if (is.null(input$pressRegion)) {
      unique(bandung_data$press_region)
    } else {
      c(input$pressRegion, NA)
    })
  selected_delegates <-
    reactive(if (is.null(input$delegateHead)) {
      unique(bandung_data$delegate)
    } else {
      input$delegateHead
    })
  selected_address_type <-
    reactive(if (input$addressType != "All") {
      input$addressType
    } else {
      c("Opening", "Closing", NA)
    })
  
  output$wordcloud <-
    renderWordcloud2({
      selected_data <-
        if (selected_topics() != "All") {
          bandung_data |> 
            filter(topic %in% selected_topics())
        } else {
          bandung_data
        }
      selected_data <-
        selected_data |> 
        filter(
          press_region %in% selected_regions(),
          address_type %in% selected_address_type(),
        )
      if (selected_delegates() != "All") {
        selected_data <-
          selected_data |> 
          filter(delegate %in% selected_delegates())
      }
      final_selected_data <-
        reactive(if (input$dualNationality) {
          selected_data |> 
            filter(subtopic == "dual nationality")
        } else {
          selected_data
        })
      create_wordcloud(final_selected_data())
    })
}

shinyApp(ui = ui, server = server)
