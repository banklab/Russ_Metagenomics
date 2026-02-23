
library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity")
fst_files <- list.files(pattern="_FST_deer_v2.csv")

for(i in 1:length(fst_files)){

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity")
  fst_species <- fread(fst_files[i], header=T, stringsAsFactors = F)

  fst_species[!is.na(fst_species$Fst) & fst_species$Fst<0,"Fst"] <- 0

  fst_species$ID <- paste0(fst_species$Scaffold,"_",fst_species$POS)
  
  species_label <- gsub("_FST.*","",fst_files[i])

  
  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites_4")
  snp_df <- data.frame(fread(list.files(pattern=species_label), header=T, stringsAsFactors = F))

  intergenic_id <- snp_df[snp_df$mutation_type=="I","ID"]
  
  intergenic_fst <- fst_species[fst_species$ID %in% intergenic_id,]

  intergenic_fst$bin <- species_label


  if(i==1){ intergenic_full <- intergenic_fst } else { intergenic_full <- rbind(intergenic_full,intergenic_fst) }
  
}


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity")
write.csv(intergenic_full, "Intergenic_FST_deer_v2.csv", row.names=F)

 
