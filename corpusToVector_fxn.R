# File: corpusToVector_fxn.R
# Desc: Takes an input file (.txt) and returns a string vector separated by whitespace.
# 2017-07-08

corpusToVector <- function(file) {

  text_data <- readLines(file)
  gsub("[()_!]", "", text_data) -> text_data; 
  gsub("--", " ", text_data) -> text_data
  wordVec <- unlist(strsplit(text_data, split = " "))
  
  return(wordVec)

}