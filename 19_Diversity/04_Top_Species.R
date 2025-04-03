
library(data.table)


setwd("/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/19_Diversity")
outlier_df <- data.frame(fread("outlier_df.csv", header=T, stringsAsFactors = F))

top_species <- unique(outlier_df$bin)



setwd("/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/19_Diversity/Diversity")

div_list <- list.files(pattern="Diversity_by_site.csv")

counter<-0

for(i in 1:length(div_list)){

div_file <- data.frame(fread(div_list[i],header=T, stringsAsFactors=F))

  div_file2 <- div_file[div_file$bin %in% top_species,]

if(dim(div_file2)[1]<1){next}

div_file2$Sample <- gsub("_Diversity.*","",div_list[i])

  counter <- counter + 1

  if(counter==1){ div_full <- div_file2 } else { div_full <- rbind(div_full,div_file2) }
}

write.csv(div_full, "", row.names=F)

