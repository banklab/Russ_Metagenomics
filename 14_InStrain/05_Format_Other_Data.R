
## format genome data, scaffold data, gene data, mapping data


library(data.table)

setwd("/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/14_InStrain/01_One_Population")

instrain_dir <- list.files(pattern = "_InStrain")

for(i in 1:length(instrain_dir)){
  
  setwd(paste0("/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/14_InStrain/01_One_Population/", instrain_dir[i],"/output"))
  genome_df <- data.frame(fread(list.files(pattern = "InStrain_genome_info.tsv"), header=T, stringsAsFactors = F))
  scaff_df <- data.frame(fread(list.files(pattern = "InStrain_scaffold_info.tsv"), header=T, stringsAsFactors = F))
  gene_df <- data.frame(fread(list.files(pattern = "InStrain_gene_info.tsv"), header=T, stringsAsFactors = F))
  map_df <- data.frame(fread(list.files(pattern = "InStrain_mapping_info.tsv"), header=T, stringsAsFactors = F))
  
  sample_id <- gsub("_InStrain","",instrain_dir[i])
  deer_id <- as.numeric(gsub("_.*","",instrain_dir[i]))
  env_id <- as.numeric(gsub(".*_","",sample_id))
  
  genome_df$Sample <- sample_id
  scaff_df$Sample <- sample_id
  gene_df$Sample <- sample_id
  map_df$Sample <- sample_id

  genome_df$Deer <- deer_id
  scaff_df$Deer <- deer_id
  gene_df$Deer <- deer_id
  map_df$Deer <- deer_id
  
  genome_df$Env <- env_id
  scaff_df$Env <- env_id
  gene_df$Env <- env_id
  map_df$Env <- env_id

  if(i == 1){
    
    all_genome <- genome_df
    all_scaff <- scaff_df
    all_gene <- gene_df
    all_map <- map_df
    
  } else {
    
    all_genome <- rbind(all_genome,genome_df)
    all_scaff <- rbind(all_scaff,scaff_df)
    all_gene <- rbind(all_gene,gene_df)
    all_map <- rbind(all_map,map_df)
    
  }
  
  
}

setwd("/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/14_InStrain")
write.csv(all_genome, "Genome_DF.csv", row.names = F)
write.csv(all_scaff, "Scaffold_DF.csv", row.names = F)
write.csv(all_gene, "Gene_DF.csv", row.names = F)
write.csv(all_map, "Mapping_DF.csv", row.names = F)
