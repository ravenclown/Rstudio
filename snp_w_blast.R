findGenesInRange <- function(chr,snp_loc,search_range,gff_gtf_file_loc,output_loc)
{
  library(writexl)
  print("Loading GFF/GTF File")
  read.delim(gff_gtf_file_loc, header=F, comment.char="#") -> annot
  df = annot[FALSE,]
  print("Loading Done!")
  Downstream_range=snp_loc+search_range;
  if(snp_loc>search_range)
  {
    Upstream_range = snp_loc-search_range;
  }
  else
  {
    Upstream_range=0;
  }
  for (i in 1:nrow(annot)) {
    if(annot$V4[[i]]>=Upstream_range && annot$V5[[i]]<=Downstream_range && annot$V3[[i]]=='gene' && annot$V1[[i]]==chr){
      df<-rbind(df,annot[i,])
      print(annot$V9[[i]])
    }
  }
  write_xlsx(df,path=output_loc)
  print(paste0("Saving to: ", output_loc))
  return(df)
}
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
return(blast_out)
}
for (i in 1:nrow(blast_out))
  {
    findGenesInRange(blast_out[i,]$sseqid,blast_out[i,]$sstart,100050,"~/c.ari.gff",file.path("~/Desktop",paste(blast_out[i,]$qseqid,".xlsx",sep="")))
}
