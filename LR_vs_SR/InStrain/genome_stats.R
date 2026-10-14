

library(data.table)

pacbio_samples <- c('2_1','2_10','2_2','2_3','2_4','2_5','2_8','2_9','4_1','4_10','4_2','4_3','4_4','4_5','4_6','4_8','4_9','6_1','6_10','6_2','6_3','6_4','6_5','6_6','6_8','6_9','7_5','7_6')


instrain_list <- paste0(pacbio_samples,"_InStrain")


for(i in 1:length(instrain_list)){
  
  dir_here <- paste0("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/02_InStrain_SR_alignments/",instrain_list[i],"/output")
  
  setwd(dir_here)
  
  gene_df <- data.frame(fread(list.files(pattern="_InStrain_genome_info.tsv"), header=T, stringsAsFactors=F))
  
  gene_df$Method <- "LR28"
  
gene_df$bin <- paste0("LR28_", gsub("\\.fa","",gene_df$genome))
  
  
  gene_df$Sample <- gsub("_InStrain","",instrain_list[i])
  
  if(i==1){ gene_df2 <- gene_df } else { gene_df2 <- rbind(gene_df2,gene_df) }
  
}

gene_df2$Deer <- as.numeric(gsub("_.*","",gene_df2$Sample))
gene_df2$Env <- as.numeric(gsub(".*_","",gene_df2$Sample))

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/02_InStrain_SR_alignments")
write.csv(gene_df2, "Genome_LR_results.csv", row.names = F)


###




library(data.table)

pacbio_samples <- c('2_1','2_10','2_2','2_3','2_4','2_5','2_8','2_9','4_1','4_10','4_2','4_3','4_4','4_5','4_6','4_8','4_9','6_1','6_10','6_2','6_3','6_4','6_5','6_6','6_8','6_9','7_5','7_6')


instrain_list <- paste0(pacbio_samples,"_SR_InStrain")


for(i in 1:length(instrain_list)){
  
  dir_here <- paste0("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/08_InStrain/",instrain_list[i],"/output")
  
  setwd(dir_here)
  
  gene_df <- data.frame(fread(list.files(pattern="_InStrain_genome_info.tsv"), header=T, stringsAsFactors=F))
  
  gene_df$Method <- "SR28"
  
  gene_df$bin <- paste0("SR28_", gsub("\\.fa","",gene_df$genome))
  
  
  gene_df$Sample <- gsub("_SR_InStrain","",instrain_list[i])
  
  
  if(i==1){ gene_df2 <- gene_df } else { gene_df2 <- rbind(gene_df2,gene_df) }
  
}

gene_df2$Deer <- as.numeric(gsub("_.*","",gene_df2$Sample))
gene_df2$Env <- as.numeric(gsub(".*_","",gene_df2$Sample))

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/08_InStrain")
write.csv(gene_df2, "Genome_SR_results.csv", row.names = F)
