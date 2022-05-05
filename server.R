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
    # col_palette <- viridis::rocket(8)
    col_palette <- rep(col_palette, times = c(1,3,6,10,12,15,20,35))
    
    wordcloud2(
      data = df |> head(100),
      # create_df(final_selected_data()) |> 
      # arrange(desc(freq)) |> 
      # head(100),
      fontFamily = "Century Gothic",
      color = col_palette,
      shape = 'circle',
      shuffle = FALSE,
      size = 0.6,
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
      c(input$delegateHead, NA)
    })
  selected_address_type <-
    reactive(if (is.null(input$addressType)) {
      unique(bandung_data$address_type)
    } else {
      c(input$addressType, NA)
    })
  
  observeEvent(input$windowResize, {
    output$ui <- renderUI({
      wordcloud2Output("wordcloud", width = input$windowResize)
    })
    
    output$wordcloud <-
      renderWordcloud2({
        selected_data <-
          bandung_data |> 
          filter(
            topic        %in% selected_topics(),
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
  })
}
