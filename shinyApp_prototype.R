# Markov Language Model - Shiny App Prototype


#library(shiny)

source("corpusToVector_fxn.R")
source("markov_fxn.R")


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      
      fileInput( "file1", "Choose Text File",
                 accept = c("text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv") ),
      
      sliderInput("n", "Maximum number of words",
                  min = 2,  max = 30, value = 10),
      
      sliderInput("novelty", "Degree of fidelity",
                  min = 1,  max = 10, value = 3),
      
      actionButton("action", label = "Generate Text"),
      
      # I still have no clue what hr() does...
      tags$hr() ),
    
    # Show text in main panel
    mainPanel(
      textOutput("contents")
    )
  )
)

server <- function(input, output) {
#  output$value <- renderPrint({ input$action - input$action})
  
  output$contents <- renderText({

    # input$file1 will be NULL initially. After the user selects
    # and uploads a file, it will be a data frame with 'name',
    # 'size', 'type', and 'datapath' columns. The 'datapath'
    # column will contain the local filenames where the data can
    # be found.
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    # Import text corpus-- basically any free text file (see www.archive.org for resources)
    corpusToVector(file = inFile$datapath) -> wordVector
    head(wordVector)

    # Generate text based on default parameters, markov_fxn(n = 30, begin_with = "")
    markov_fxn(n = input$action - input$action + input$n -1, wordVector = wordVector)
    
  })
}


# Run the Shiny application
shinyApp(ui, server)