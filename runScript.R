# markov_Fxn.R & corpusToVector
# Author: Mario Ezekiel H. (@m_ezkiel)

# Working directory should be local to parent folder
getwd()

source("corpusToVector_fxn.R")
source("markov_fxn.R")

# Import text corpus-- basically any free text file (see www.archive.org for resources)
corpusToVector(file = "data/hackers_bible.txt") -> wordVector
wordVector

# Generate text based on default parameters, markov_fxn(n = 30, begin_with = "")
markov_fxn()
