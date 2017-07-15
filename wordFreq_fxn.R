# File: wordFreq_fxn.R
# Desc: Returns top N words from a text file.
# Created: 2017-07-12 by @m_ezkiel

# require('stringr')

wordFreq <- function(file = "", n = 10, dict = "stopWords_english.txt") {
  library('stringr')
  myStops <- suppressWarnings(corpusToVector(dict))
  wordVector <- suppressWarnings(corpusToVector(file, removePunct = TRUE))
  cleanWords <- str_to_lower(wordVector)
  
  for (i in 1:length(myStops)) 
    cleanWords <- cleanWords[cleanWords != myStops[i]]
  
  top_N <- tail(sort(rowSums(as.matrix(table(cleanWords)))), n)
  
  return(top_N)
}

# Sample use case
# wordFreq("data/time_machine_Wells.txt")
