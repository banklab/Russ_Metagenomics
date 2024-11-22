
INDIR="/storage/scratch/users/rj23k073/04_DEER/11_dRep/02_CheckM/storage"
OUTDIR="/storage/scratch/users/rj23k073/04_DEER/11_dRep"

setwd(INDIR)

checkm_df <- read.table("bin_stats_ext.tsv", header = F, stringsAsFactors = F, sep = "\t")

genomeInformation_df <- data.frame(array(NA, dim = c(dim(checkm_df)[1],3), dimnames = list(c(),c("genome","completeness","contamination"))))

for(i in 1:dim(checkm_df)[1]){
 
  genomeInformation_df[i,1] <- paste0(checkm_df[i,"V1"],".fa")
  genomeInformation_df[i,2] <- as.numeric(gsub(".*Completeness: |, Contamination.*","",checkm_df[i,"V2"]))
  genomeInformation_df[i,3] <- as.numeric(gsub(".*Contamination: |, GC.*","",checkm_df[i,"V2"]))
  
}

setwd(OUTDIR)
write.csv(genomeInformation_df, "genomeInformation_ASM.csv", row.names = F, quote = F)
