server <- function(input, output) {
  set.seed(42)
  create_df <- function(word_data) {
    text <- word_data$text
    docs <- Corpus(VectorSource(text))
    docs <- docs %>%
      tm_map(removeNumbers) %>%
      tm_map(removePunctuation) %>%
      tm_map(stripWhitespace)
    docs <- tm_map(docs, content_transformer(tolower))
    docs <- tm_map(docs, removeWords, c("conference", stopwords("english")))
    
    dtm <- TermDocumentMatrix(docs) 
    matrix <- as.matrix(dtm) 
    words <- sort(rowSums(matrix),decreasing=TRUE) 
    df <- data.frame(word = names(words),freq=words)
    row.names(df) <- NULL
    df
  }
  
  output$wordcloud <-
    renderWordcloud2({
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
          input$pressRegion
        })
      selected_delegates <-
        reactive(if (is.null(input$delegateHead)) {
          unique(bandung_data$delegate)
        } else {
          input$delegateHead
        })
      selected_address_type <-
        reactive(if (is.null(input$addressType)) {
          unique(bandung_data$address_type)
        } else {
          input$addressType
        })
      
      selected_data <-
        bandung_data |> 
        filter(
          topic        %in% selected_topics(),
          delegate     %in% selected_delegates(),
          press_region %in% selected_regions(),
          address_type %in% selected_address_type(),
        )
      final_selected_data <-
        reactive(if (input$dualNationality) {
          selected_data |> 
            filter(subtopic == "dual nationality")
        } else {
          selected_data
        })
      df <- create_df(final_selected_data())
      wordcloud(
        words = df$word, 
        freq = df$freq, 
        max.words = 100,
        scale=c(4,.2),
        random.order=FALSE,
        colors=wes_palette("GrandBudapest2", 8, type = "continuous")
      )
    }, res = 80)
}
