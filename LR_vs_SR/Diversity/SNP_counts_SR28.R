

library(data.table)




setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/CoverM")
coverage <- read.csv("DEER_SR28_CoverM.csv", header=T, stringsAsFactors = F)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/REFERENCES")
genome_sizes <- read.csv("genome_sizes_SR.csv", header=T, stringsAsFactors = F)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/08_InStrain/FORMAT")
instrain_list <- list.files(pattern="SR_InStrain_SNVs_format.csv")


for(i in 1:length(instrain_list)){
  
  snp_df <- fread(instrain_list[i], header=T, stringsAsFactors = F)
  
  snp_count <- data.frame(table(snp_df$bin))
  colnames(snp_count) <- c("bin","snp.count")
  
  intergenic_snps <- snp_df[snp_df$mutation_type=="I",]
  
  intergenic_count <- data.frame(table(intergenic_snps$bin))
  colnames(intergenic_count) <- c("bin","intergenic.count")
  
  snp_count2 <- merge(snp_count, intergenic_count, by="bin", all=TRUE)
  
  snp_count2[is.na(snp_count2$intergenic.count),"intergenic.count"] <- 0
  
  snp_count2$coding.count <- snp_count2$snp.count - snp_count2$intergenic.count
  
  snp_count3 <- snp_count2[,c(1:2,4,3)]
  
  # snp_count3$Sample <- gsub("_LR28_.*|_SR_.*","",instrain_list[i])
  # 
  # snp_count3$Deer <- as.numeric(gsub("_.*","",snp_count3$Sample))
  # 
  # snp_count3$Env <- as.numeric(gsub(".*_","",snp_count3$Sample))
  # 
  # snp_count3$Method <- gsub(".*_","",gsub("_InStrain_SNVs.*","",instrain_list[i]))
  
  if( min(snp_count3$intergenic.count) <0 ){stop("negative snps?")}
  
  
  coverage_sub <- coverage[coverage$Sample==gsub("_LR28_.*|_SR_.*","",instrain_list[i]),]
  
  
  if( length(setdiff(unique(snp_count3$bin),unique(coverage_sub$bin)))>0 ){stop("bin names dont merge")}
  
  snp_count4 <- merge(snp_count3, coverage_sub, by="bin")
  
  
  if( length(setdiff(unique(snp_count4$bin),unique(genome_sizes$bin)))>0 ){stop("bin names dont merge 2")}
  
  snp_count5 <- merge(snp_count4, genome_sizes[,c("bin","genome.size")], by="bin")
  
  snp_count5$polymorphic <- snp_count5$snp.count / snp_count5$genome.size
  snp_count5$coding.polymorphic <- snp_count5$coding.count / snp_count5$genome.size
  snp_count5$intergenic.polymorphic <- snp_count5$intergenic.count / snp_count5$genome.size
  
  
  if( i==1 ){ snp_count33 <- snp_count5 } else { snp_count33 <- rbind(snp_count33,snp_count5) }
  
  cat(i,"\n")
  
}

write.csv(snp_count33, paste0("Snp_counts_SR28.csv"), row.names=F)


