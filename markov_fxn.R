# File: markov_fxn.R
# Desc: Input max number of n-grams and optional regex parameter, returns machine generated text.
# 2017-07-08


# Markov Function with Added parameter for "begins_with = " and return array

markov_fxn <- function(n = 30, begin_with = "", wordVec = wordVector) {
  
  emptyArray <- rep(NA, n + 1)
  beginning <- wordVec[grep(begin_with, wordVec)]
  sample(beginning, 1) -> context; 
  emptyArray[1] <- context;
  ## print(context) 
  
  for(i in 1:n) {
    sample(wordVec[which(wordVec == context) + 1], size = 1) -> context; 
    emptyArray[i+1] <- context;
    ## print(context)
    if (grepl("[.]$", context) == TRUE)
      break
  }
  
  filledArray <- na.exclude(emptyArray)
  machineText <- ""
  
  for (i in 1:length(filledArray)) {
    machineText <- paste0(machineText, filledArray[i], " ")
  }
  
  return(machineText)
}