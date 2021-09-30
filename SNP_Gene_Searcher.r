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
}

findGenesInRange('NC_021160.1',1000000,200000,"~/GCF_000331145.1_ASM33114v1_genomic.gff","~/Desktop/output.xlsx")
