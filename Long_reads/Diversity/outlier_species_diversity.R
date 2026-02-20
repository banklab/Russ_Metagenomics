

out_species <- c('Hy_Me_4_8_bin.143','Hy_Se_2_10_bin.105','Hy_Se_2_8_bin.23','Hy_Se_2_8_bin.24','Hy_Se_4_8_bin.39','LR_Se_2_10_bin.36','LR_Se_6_10_bin.83')

library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity")
div_files <- list.files(pattern="Diversity_by_site.csv")

for(i in 1:length(div_files)){

  div_data <- fread(div_files[i], header=T, stringsAsFactors=F)

  sub_div_data <- div_data[div_data$bin %in% out_species,]

  if(i==1){ comb_div <- sub_div_data } else { comb_div <- rbind(comb_div,sub_div_data) }

  }

write.csv(comb_div, "Top_species_diversity_DEER_v2.csv", row.names=F)

