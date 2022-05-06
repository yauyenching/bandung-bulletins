ui <- fluidPage(
  tags$head(tags$style( 
    HTML("
    @import url('https://fonts.googleapis.com/css2?family=Inter&display=swap');
      .tab-content {margin:50px 100px;}
      h1, h4 {font-family: 'Inter', sans-serif;}
      body {font-family: 'Inter', sans-serif; margin: 40px 0px; padding: 10px 0px;}
         "))),
  theme = shinytheme("slate"),
  h1("1955 Bandung Asian-African Conference Bulletins", 
     align="center",),
  h4("A Visual Summary" |> str_to_upper(), align="center", 
     style="color:#A3A3A3;margin-bottom:25px;"),
  tabsetPanel(
    # br(),
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
            choices = c("All", unique(bandung_data$topic)),
          ),
          
          # Select dual nationality subtopic
          checkboxInput(
            inputId = "dualNationality",
            label = strong("Show only China-Indonesia dual nationality related content")
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
            choices = c("All", unique(bandung_data$delegate)[2:35])
          ),
          conditionalPanel(
            condition = "input.topic.indexOf('address') > -1",
            checkboxGroupInput(
              inputId = "addressType",
              label = "Opening or closing address",
              choices = c("Opening", "Closing")
            )),
          br(),
          br(),
          p("View the ", a(href="https://github.com/yauyenching/bandung-bulletins", "GitHub repo."))
        ),
        mainPanel(wordcloud2Output("wordcloud", width = "100%"))
      )
    ),
    
    # About Bandung Conference panel
    tabPanel(
      title = "About the Bandung Conference",
      br(),
      strong("What is the Bandung Conference?" |> str_to_upper())
    )
  ),
  p("Built with ❤️ by Yau Yen Ching ", 
    a(href="https://github.com/yauyenching", icon("github")), 
    a(href="https://www.linkedin.com/in/yau-yen-ching/", icon("linkedin")),
    align="center", 
    style="position: absolute; left: 50%; top: 725px; margin-left: -125px; padding-bottom: 50px;")
)


# ui <- fluidPage(
#   theme = shinytheme("slate"),
#   h1("1955 Bandung Asian-African Conference Bulletins", align="center"),
#   h3("A Visual Summary", align="center"),
#   tabsetPanel(
#     # br(),
#     # Word cloud tab
#     tabPanel(
#       title = "Word cloud",
#       br(),
#       br(),
#       wordcloud2Output("wordcloud", width = "100%"),
#       br(),
#       br(),
#       # Select topic
#       h4("Content Filters", align="center"),
#       fluidRow(
#         column(3,
#                offset = 1,
#                selectInput(
#                  inputId = "topic",
#                  label = strong("Bulletin content topic"),
#                  choices = unique(bandung_data$topic),
#                  multiple = TRUE
#                ),
#                
#                # Select dual nationality subtopic
#                checkboxInput(
#                  inputId = "dualNationality",
#                  label = strong("Show only China-Indonesia dual nationality related content")
#                ),
#                
#                checkboxInput("removeWords", strong("Remove specific words?"), FALSE),
#                conditionalPanel(
#                  condition = "input.removeWords == 1",
#                  textAreaInput("wordsToRemove", "Words to remove (separated by comma)", rows = 1)
#                )),
#         
#         column(3,
#                offset = 1,
#                # Display select press region only if press is checked
#                # conditionalPanel
#                # condition = "input.topic.indexOf('press') > -1",
#                checkboxGroupInput(
#                  inputId = "pressRegion",
#                  label = "Press region",
#                  choices = c("Asia and Africa", "Australia", "Europe", "America")
#                )),
#         # ),
#         
#         # Select Delegates
#         # conditionalPanel(
#         # condition = "input.topic.indexOf('address') > -1",
#         column(3,
#                selectInput(
#                  inputId = "delegateHead",
#                  label = "Delegate head",
#                  choices = c("All", unique(bandung_data$delegate)[2:35])
#                ),
#                checkboxGroupInput(
#                  inputId = "addressType",
#                  label = "Opening or closing address",
#                  choices = c("Opening", "Closing")
#                ))
#       ),
#     ),
#     
#     # About Bandung Conference panel
#     tabPanel(
#       title = "About the Bandung Conference",
#       br(),
#       "lorem ipsum"
#     )
#   )
# )
