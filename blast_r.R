#taken from https://palfalvi.org/post/local-blast-from-r/
blastn <- function(blast_db,input,evalue=1e-6,format=6)
{
Sys.setenv(PATH=paste(Sys.getenv("PATH"), "~/ncbi-blast-2.12.0+/bin/", sep=":"))
library(tidyverse)
colnames <- c("qseqid",
              "sseqid",
              "pident",
              "length",
              "mismatch",
              "gapopen",
              "qstart",
              "qend",
              "sstart",
              "send",
              "evalue",
              "bitscore")

blast_out <- system2("blastn", 
                     args = c("-db", blast_db, 
                              "-query", input, 
                              "-outfmt", format, 
                              "-evalue", evalue,
                              "-ungapped"),
                     wait = TRUE,
                     stdout = TRUE) %>%
  as_tibble() %>% 
  separate(col = value, 
           into = colnames,
           sep = "\t",
           convert = TRUE)
}
