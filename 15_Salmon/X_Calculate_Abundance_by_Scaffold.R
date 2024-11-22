
## ADJUST FOR SCAFFOLDS

## CALCULATE !GENOME (scaffold) COPIES PER MILLION READS


setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon")
quant_files <- list.files(pattern="counts")

## currently just using ENV 8 & ENV 10
quant_files <- c(quant_files[grepl("8.quant.counts",quant_files)],quant_files[grepl("10.quant.counts",quant_files)])


setwd("/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/REFERENCES")
stats <- read.table("dRep_ONLY_bin_ref_fastANI_STATS.txt", header=T, stringsAsFactors = F)
#colnames(stats) <- c("transcript","Length")

#stats$Species <- NA

names_list <- read.table("names_list.txt", header=F, stringsAsFactors=F)
names_list$Scaffold <- sub(">","",names_list$V1)
names_list$Species <- gsub("_NODE.*","",names_list$Scaffold)
names_list$transcript <- gsub(".*NODE_","NODE_",names_list$Scaffold)
names_list$V1 <- NULL


cat("Number of ubique species:",length(unique(stats$Species)))
## should be 695 for bin ref + ruminants (dereplicated)

max_species <- 695 ## just for doublechecking my work below


Species_Length <- data.frame(tapply(stats$Length, stats$Species, sum))
Species_Length$Species <- rownames(Species_Length)
rownames(Species_Length) <- NULL
colnames(Species_Length)[1] <- "Length"

setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon")
quant_files <- list.files(pattern="counts")

## currently just using ENV 8 & ENV 10
quant_files <- c(quant_files[grepl("8.quant.counts",quant_files)],quant_files[grepl("10.quant.counts",quant_files)])


for(i in 1:length(quant_files)){
  
  sample11 <- gsub("\\.quant.*","",quant_files[i])
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon")
  quant_file <- read.table(quant_files[i], header=T, stringsAsFactors = F)
  
  quant_file$Species <- NA
  
  for(ii in 1:length(unique(names_list$Species))){
    
    target1 <- unique(names_list$Species)[ii]
    
    scaffolds_of_species <- names_list[names_list$Species==target1,"transcript"]
    
    quant_file[quant_file$transcript %in% scaffolds_of_species,"Species"] <- target1
  } 
  
  
  quant_file$Scaffold <- as.numeric(gsub("NODE_|_length.*","",quant_file$transcript))
  
  quant_file$Size <- as.numeric(gsub(".*length_|_cov_.*","",quant_file$transcript))
  
  quant_file$base.pairs <- quant_file$count * quant_file$Size
  
  quant_file$percent <- quant_file$base.pairs / sum(quant_file$base.pairs) * 100
  
  write.csv(quant_file, paste0(sample11,"_abundance_by_scaffold.csv"), row.names = F)
  
}


