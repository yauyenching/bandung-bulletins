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
  div(tabsetPanel(
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
and calling for greater solidarity, mutual respect, non-aggression, and equality.
This event marked an emerging community of developing nations, many of which were 
newly independent from colonial powers.
Today, the Asian-African Conference is recognized as an example of Afro-Asian solidarity and one of the
largest cooperative efforts between Third World countries to articulate a shared vision
in the face of great world powers."),
          br(),
          h4(strong("What is this Project?"), align="center"),
          p("
This project aims to provide an accessible visual summary over the conference
bulletin contents which were made publicly available by the Indonesian ministry
of information. PDFs of the bulletins can be accessed ",
            a(href="https://bandung60.wordpress.com/bandung-bulletin/", "here."),
            "
Each issue contained conference documents, delegate addresses, summaries of world
press opinions, and other material.
I converted the pages in the PDFs to text using an optical character recognition
tool. I left out content pertaining to conference logistics and delegate profiles.
The digitized text can be found in the GitHub repo.
            "
          )
        )
      )
    )
  )),
  p("Built with ❤️ by Yau Yen Ching ", 
    a(href="https://github.com/yauyenching", icon("github")), 
    a(href="https://www.linkedin.com/in/yau-yen-ching/", icon("linkedin")),
    align="center", 
    style="position: relative;")
  # left: 50%; top: 750px; margin-left: -125px;
)