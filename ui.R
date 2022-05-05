ui <- fluidPage(
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
      
      # Display select press region only if press is checked
      conditionalPanel(
        condition = "input.topic == 'press'",
        checkboxGroupInput(
          inputId = "pressRegion",
          label = "Press region",
          choices = unique(bandung_data$press_region)
        )
      ),
      
      # Display select delegate only if address is selected
      conditionalPanel(
        condition = "input.topic == 'delegate'",
        selectInput(
          inputId = "delegateHead",
          label = "Delegate head",
          choices = unique(bandung_data$delegate),
          multiple = TRUE
        ),
        checkboxGroupInput(
          inputId = "addresstype",
          label = "Opening or closing address",
          choices = unique(bandung_data$address_type)
        )
      )
    ),
    mainPanel(
      plotOutput(outputId = "wordcloud", width="100%")
    )
  )
)
