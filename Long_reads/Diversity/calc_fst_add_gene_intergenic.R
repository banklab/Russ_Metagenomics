
library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity")
fst_files <- list.files(pattern="_FST_deer_v2.csv")

for(i in 1:length(fst_files)){

  
  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity")
  fst_species <- fread(fst_files[i], header=T, stringsAsFactors = F)

  fst_species[!is.na(fst_species$Fst) & fst_species$Fst<0,"Fst"] <- 0

  species_label <- gsub("_FST.*","",fst_files[i])

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity")

  
  
}


 
