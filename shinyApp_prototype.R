# Markov Language Model - Shiny App Prototype


#library(shiny)
library(wordcloud)

source("corpusToVector_fxn.R")
source("markov_fxn.R")
source("wordFreq_fxn.R")

# Initialize data frame
data <- data.frame()

ui <- fluidPage(
  titlePanel("Markov Generative Language Model"),
  
  sidebarLayout(
    
    sidebarPanel(
      fileInput( "textFile", "Choose Text File", multiple = FALSE,
                 accept = c("text/csv", "text/comma-separated-values,text/plain", ".csv")),
      sliderInput("wordsSlider", label = "Maximum number of words",
                  min = 2,  max = 100, value = 50),
      actionButton("genButton", label = "Generate Text",
                   style="color: #fff; background-color: #337ab7; border-color: #2e6da4"),
      actionButton("saveButton", label = "Save Text")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Text Editor",
                 textAreaInput("inText", "", width = "600px", height = "175px"),
                 verbatimTextOutput("summaryStats"),
                 downloadButton("downloadData", label = "Download"),
                 verbatimTextOutput("nText")),
        tabPanel("Analysis",
                 HTML(paste("<br/>")),
                 verbatimTextOutput("fileName"),
                 plotOutput("wordCloud")), 
        tabPanel("Resources",
                 HTML(paste("<br/>")),
                 # HTML(paste("hello", "world", sep="<br/>")),
                 helpText( a("A visual explanation of Markov chains", 
                             href="http://setosa.io/blog/2014/07/26/markov-chains/",
                             target="_blank")),
                 helpText( a("Download more text files", 
                             href="http://textfiles.com/directory.html",
                             target="_blank")),
                 helpText( a("Rhyming Dictionary", 
                             href="https://muse.dillfrog.com/sound/search",
                             target="_blank")),
                 HTML(paste(rep("<br/>", 4))),
                 helpText("v0.1 |", a("@m-ezekiel", 
                             href="http://www.m-ezekiel.com",
                             target="_blank")))
      )
    )
  )
)




## SERVER 

server <- function(input, output, session) {
  
  # Define session variables
  # wordVector <- NULL
  # inFile <- NULL
  
  observe({
    inFile <<- input$textFile
    if (is.null(inFile))
      return(NULL)
    
    # Import text corpus-- basically any free text file (see www.archive.org for resources)
    wordVector <<- corpusToVector(file = inFile$datapath, nGram = 1)
    
    # Generate text based on default parameters, markov_fxn(n = 30, begin_with = "")
    newText <<- markov_fxn(n = input$genButton*0 + input$wordsSlider - 1,
                           wordVec = wordVector)
    
    # This will change the value of input$inText, based on the given value
    updateTextAreaInput(session, "inText", value = newText)
    
  })
  
  
  ## SAVE AND DISPLAY TEXT
  ntext <- eventReactive(input$saveButton, { input$inText })
  output$nText <- renderPrint({
    data[dim(data)[1]+1, "savedText"] <<- ntext()
    data[dim(data)[1], "timeStamp"] <<- as.character(Sys.time())
    data[dim(data)[1], "sourceDoc"] <<- inFile$name
    data[dim(data)[1]:1 , "savedText"]
  })
  
  ## DOWNLOAD DATA   
  output$downloadData <- downloadHandler(
    content = function(file) {write.csv(data, file)},
    filename = function() {
      sysTime <- gsub("[ :]", "-", x = Sys.time())
      paste(sysTime, "_machineText", ".csv", sep="")
    })
  
  ## SUMMARY STATISTICS
  updateStats <- reactive( {
    inFile <<- input$textFile
    if (is.null(inFile))
      return(NULL)
    wordVector <<- corpusToVector(file = inFile$datapath, nGram = 1)
    paste("File:", inFile$name, "  ",
          "Words:", length(wordVector), "  ",
          "Variety (0-1):", signif(length(unique(wordVector)) / length(wordVector), digits = 2)) 
  })
  output$summaryStats <- renderText( {
    updateStats()
    })
  
  
  ## WORD CLOUD
  updateStats2 <- eventReactive( input$textFile, {
    paste("File:", inFile$name, "  ",
          "Words:", length(wordVector), "  ",
          "Variety (0-1):", signif(length(unique(wordVector)) / length(wordVector), digits = 2)) 
  })
  output$fileName <- renderText({ updateStats2() })
  output$wordCloud <- renderPlot({ wcPlot() })
  wcPlot <- eventReactive( input$textFile, {
    freqs <- wordFreq(file = inFile$datapath, n=40)
    wordcloud(names(freqs), freqs, min.freq=20, colors=brewer.pal(6,"Dark2"),
              random.color = FALSE,
              random.order = FALSE)
  })
  
}


# Run the Shiny application
shinyApp(ui, server)