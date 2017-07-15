# markov_Fxn.R & corpusToVector
# Author: Mario Ezekiel H. (@m_ezkiel)

# Working directory should be local to parent folder
getwd()

source("corpusToVector_fxn.R")
source("markov_fxn.R")
source("wordFreq_fxn.R")

# Import text corpus-- basically any free text file (see www.archive.org for resources)
textDoc <- "data/c0dez.txt"
corpusToVector(file = textDoc) -> wordVector

# Corpus stats
paste("Words:", length(wordVector))
paste("Variety:", signif(length(unique(wordVector)) / length(wordVector), digits = 2))
wordFreq(file = textDoc)

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


######################################

# Alternatre implementation using mkdir

library('tm')

fileName <- "time_machine_Wells.txt"
fileDir <- gsub(".txt", "", fileName)
tmSource <- paste0("data/", fileDir)
dir.create(paste0("data/", fileDir))
file.copy(from = paste0("data/", fileName), to = paste0("data/", fileDir))
docs <- Corpus(DirSource(tmSource))
docs

# Remove directory
unlink(paste0("data/", fileDir), recursive = TRUE)

######################################

# Wordcloud

library(wordcloud)

freqs <- wordFreq(textDoc, n=40)
wordcloud(names(freqs), freqs, min.freq=20, colors=brewer.pal(6,"Dark2"))
