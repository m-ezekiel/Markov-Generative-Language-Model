# File: corpusToVector_fxn.R
# Desc: Takes an input file (.txt) and returns a string vector separated by whitespace.
# 2017-07-08

corpusToVector <- function(file, nGram = 1, removePunct = FALSE) {

  text_data <- readLines(file)
  gsub("[()_!]", "", text_data) -> text_data
  gsub("--", " ", text_data) -> text_data
  gsub("  ", " ", text_data) -> text_data
  if (removePunct == TRUE) {
    gsub("[,.?\"]", "", text_data) -> text_data
  }
  
  wordVec <- unlist(strsplit(text_data, split = " "))
  
  bigrams <- NULL
  trigrams <- NULL
    
  if (nGram == 2) {
    for (i in 1:length(wordVec)-1) {
      bigrams[i] <- paste(wordVec[i], wordVec[i+1])
      print(i)
    }
    wordVec <- bigrams
  }
  if (nGram == 3) {
    for (i in 1:length(wordVec)-2)
      trigrams[i] <- paste(wordVec[i], wordVec[i+1], wordVec[i+2])
    wordVec <- trigrams
  }
  
  return(wordVec)
}
