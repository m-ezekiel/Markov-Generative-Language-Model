# Markov Language Model - Shiny App Prototype


#library(shiny)

source("corpusToVector_fxn.R")
source("markov_fxn.R")
source("returnStats_fxn.R")

# Save document
data <- NULL
newText <- NULL

ui <- fluidPage(
  
  textOutput("saveDoc"),
  
  sidebarLayout(
    sidebarPanel(
      
      fileInput( "file1", "Choose Text File",
                 accept = c("text/csv",
                            "text/comma-separated-values,text/plain",
                            ".csv") ),
      
      sliderInput("n", "Maximum number of words",
                  min = 2,  max = 100, value = 50),
      
      actionButton("action", label = "Generate Text"),

      # Right now these are place holders...
      actionButton("saveData", label = "Save Text"),
      
      
      # I still have no clue what hr() does...
      tags$hr() ),
    
    # Show text in main panel
    mainPanel(
      textAreaInput("inText", "Input text", width = "600px", height = "300px"),
      downloadButton("downloadData", label = "Download"),
      verbatimTextOutput("nText")
    )
  )
)

server <- function(input, output, session) {

  observe({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    # Import text corpus-- basically any free text file (see www.archive.org for resources)
    corpusToVector(file = inFile$datapath, nGram = 1) -> wordVector
    head(wordVector)
    
    # Generate text based on default parameters, markov_fxn(n = 30, begin_with = "")
    newText <- markov_fxn(n = input$action - input$action + input$n -1, wordVec = wordVector)
    
    # This will change the value of input$inText, based on x
    updateTextAreaInput(session, "inText", value = newText)
  })

  ntext <- eventReactive(input$saveData, {
    input$inText
  })
  
  output$nText <- renderPrint({
    data[length(data)+1] <<- ntext()
    data
  })

    
  # output$saveData <- renderPrint({
  #   data[length(data)+1] <<- input$inText
  # })
    
  output$downloadData <- downloadHandler(
    filename = function() {
      sysTime <- gsub("[ :]", "-", x = Sys.time())
      paste(sysTime, "_machineText", ".csv", sep="")
    },
    content = function(file) {
      write.csv(data, file)
    }
  )
}


# Run the Shiny application
shinyApp(ui, server)