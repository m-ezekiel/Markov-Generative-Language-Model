# Markov Language Model - Shiny App Prototype


#library(shiny)

source("corpusToVector_fxn.R")
source("markov_fxn.R")
source("returnStats_fxn.R")

# Save document
saveText <- NULL
saveTime <- NULL
genText <- NULL
genTime <- NULL
newText <- NULL
data <- data.frame(saveText, saveTime, genText, genTime)


ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      fileInput( "file1", "Choose Text File",
                 accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
      sliderInput("n", label = "Maximum number of words",
                  min = 2,  max = 100, value = 50),
      actionButton("generateText", label = "Generate Text"),
      actionButton("saveData", label = "Save Text"),
      tags$hr() 
      ),
    mainPanel(
      textAreaInput("inText", "Input text", width = "600px", height = "300px"),
      downloadButton("downloadData", label = "Download"),
      verbatimTextOutput("nText")
    )
  )
)



## SERVER 

server <- function(input, output, session) {

  observe({
    inFile <- input$file1
    
    if (is.null(inFile))
      return(NULL)
    
    # Import text corpus-- basically any free text file (see www.archive.org for resources)
    corpusToVector(file = inFile$datapath, nGram = 1) -> wordVector

    # Generate text based on default parameters, markov_fxn(n = 30, begin_with = "")
    newText <- markov_fxn(n = input$generateText - input$generateText + input$n - 1, 
                          wordVec = wordVector)

    # This will change the value of input$inText, based on the given value
    updateTextAreaInput(session, "inText", value = newText)
  })

  
  ## Code for the SAVE button
  ntext <- eventReactive(input$saveData, {
    input$inText
  })
  output$nText <- renderPrint({
    # Save the new text and current system time
    data[dim(data)[1]+1, "savedText"] <<- ntext()
    data[dim(data)[1], "timeStamp"] <<- as.character(Sys.time())
    # Display saved text
    data[dim(data)[1]:1 , "savedText"]
  })


  ## Code for the DOWNLOAD button    
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