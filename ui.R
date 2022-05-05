ui <- fluidPage(
  theme = shinytheme("slate"),
  titlePanel("1955 Bandung Asian-African Conference Bulletins: A Visual Summary"),
  sidebarLayout(
    sidebarPanel(
      
      # Select topic
      selectInput(
        inputId = "topic",
        label = strong("Bulletin content topic"),
        choices = unique(bandung_data$topic),
        multiple = TRUE
      ),
      
      # Select dual nationality subtopic
      checkboxInput(
        inputId = "dualNationality",
        label = strong("Show only China-Indonesia dual nationality related content")
      ),
      
      checkboxInput("removeWords", "Remove specific words?", FALSE),
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
        )
      ),
      
      # Select Delegates
      conditionalPanel(
        condition = "input.topic.indexOf('address') > -1",
        selectInput(
          inputId = "delegateHead",
          label = "Delegate head",
          choices = c("All", unique(bandung_data$delegate)[2:35])
        ),
        checkboxGroupInput(
          inputId = "addressType",
          label = "Opening or closing address",
          choices = c("Opening", "Closing")
        )
      )
    ),
    mainPanel(
      wordcloud2Output("wordcloud")
    )
  )
)
