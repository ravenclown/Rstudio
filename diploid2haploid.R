diploid2haploid <- function(vcf)
{
  gt <- extract.gt(vcf)
  head(gt)
  is.na(vcf@gt[,-1][is_het(gt)]) <- TRUE
  gt <- extract.gt(vcf)
  gt[gt=="0|0"] <- 0
  gt[gt=="0/0"] <- 0
  gt[gt=="1/1"] <- 1
  gt[gt=="1|1"] <- 1
  gt[gt=="2|2"] <- 2
  gt[gt=="2/2"] <- 2
  gt[gt=="3|3"] <- 3
  gt[gt=="3/3"] <- 3
  gt[gt=="4|4"] <- 4
  gt[gt=="4/4"] <- 4
  gt[gt=="5|5"] <- 5
  gt[gt=="5/5"] <- 5
  gt[gt=="6|6"] <- 6
  gt[gt=="6/6"] <- 6
  gt2 <- extract.gt(vcf, extract = FALSE)
  unique(as.vector(gt))
  gt <- matrix( paste(gt, gt2, sep=":"), nrow=nrow(gt), dimnames=dimnames(gt) )
  is.na(gt[gt == "NA:NA"]) <- TRUE
  vcf@gt[,-1] <- gt
  return(vcf)
}

