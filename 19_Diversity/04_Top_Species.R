
library(data.table)


EnvA <- 8
EnvB <- 10

SNP_filter <- 20e3 ## top species

setwd("/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/14_InStrain/06_CMH")
cmh_list <- list.files(pattern=(paste0("_Env",EnvA,"xEnv",EnvB,"_snps")))
snp_count <- as.numeric(gsub(".*snps|_CMH.*","",cmh_list))

cmh_list2 <- cmh_list[snp_count>=SNP_filter]

top_species <- gsub("_Env.*","",cmh_list2)



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

