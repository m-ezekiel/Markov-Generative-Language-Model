# markov_Fxn.R & corpusToVector
# Author: Mario Ezekiel H. (@m_ezkiel)

# Working directory should be local to parent folder
getwd()

source("corpusToVector_fxn.R")
source("markov_fxn.R")
source("returnStats_fxn.R")

# Import text corpus-- basically any free text file (see www.archive.org for resources)
corpusToVector(file = "data/time_machine_Wells.txt") -> wordVector

cleanWords <- wordVector

# Need to figure out how to make a stopword dictionary
myStops <- c("the", "I", "of", "and", "a", "to", "was", "in", "my", "that", "had", "as", "it", "with", "at", "on", "were", "this", "have", "his", "from", "into", "but", "by", "is")

for (i in 1:length(myStops)) {
  cleanWords <- cleanWords[cleanWords != myStops[i]]
}

sort(rowSums(as.matrix(table(cleanWords))))

# Corpus stats
paste("Words:", length(wordVector))
paste("Variety:", signif(length(unique(wordVector)) / length(wordVector), digits = 2))

# Generate text based on default parameters, markov_fxn(n = 30, begin_with = "")
markov_fxn()

# Save
saveDocument <- NULL

newText <- markov_fxn()
newText

saveDocument[length(saveDocument)+1] <- newText
saveDocument

# Write document: timeStamp_fileName.txt
write.csv(saveDocument, "newFile.txt")
