
library(data.table)

instrain_dirs <- list.files(pattern="_LR_InStrain")[!grepl("deer", list.files(pattern="_LR_InStrain"))]

for(i in 1:length(instrain_dirs)){

  sample1 <- gsub("_LR.*","",instrain_dirs[i])
  
  setwd(paste0("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/",instrain_dirs[i],"/output"))

  df <- fread(paste0(sample1,"_LR_InStrain_genome_info.tsv"), header=T, stringsAsFactors=F, sep="\t")

  df$SAMPLE <- 

 
