# markov_Fxn.R & corpusToVector
# Author: Mario Ezekiel H. (@m_ezkiel)

# Working directory should be local to parent folder
getwd()

source("corpusToVector_fxn.R")
source("markov_fxn.R")
source("returnStats_fxn.R")

# Import text corpus-- basically any free text file (see www.archive.org for resources)
corpusToVector(file = "data/time_machine_Wells.txt") -> wordVector

# Corpus stats
# length(wordVector)
# length(unique(wordVector))
# length(unique(wordVector)) / length(wordVector)

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
