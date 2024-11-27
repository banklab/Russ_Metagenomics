## rename CheckM2 columns for dRep
## add file extension to genome name for dRep

checkm <- read.table("quality_report.tsv", header=T, stringsAsFactors=F, sep="\t")

colnames(checkm)[1:3] <- c("genome","completeness","contamination")

checkm$genome <- paste0(checkm$genome,".fa")

write.csv(checkm, "genomeInformation.csv", row.names=F)
