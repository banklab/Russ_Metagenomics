
## CALCULATE GENOME COPIES PER MILLION READS


calc.abund.function <- function(pick.species){
  
  species.quant <- quant_file[quant_file$Species==pick.species,]
  
  unq.contigs <- unique(species.quant$transcript)
  
  num.contigs <- length(unq.contigs)
  
  species.quant2 <- merge(species.quant, stats[,!names(stats) %in% "Species"], by="transcript", all = FALSE)
  
  species.quant2$abundance <- species.quant2$count * species.quant2$Length
  
  species.base.pairs <- sum(species.quant2$abundance)
  
  species.genome.length <- Species_Length[Species_Length$Species==pick.species,"Length"]
  
  species.abundance <- species.base.pairs / species.genome.length
  
  return(c(species.base.pairs,species.abundance))
  
}



## TPM
## find contig length for each contig within a species
## TPM * contig length = bp of contig in sample
## add up all bp of a given species in sample
## divide bp of a given species by its assembly length
## gives (relative) abundance of species in sample

setwd("/storage/scratch/users/rj23k073/04_DEER/REFERENCES")
stats <- read.table("dRep_ONLY_bin_ref_fastANI_STATS.txt", header=T, stringsAsFactors = F)
#colnames(stats) <- c("transcript","Length")

#stats$Species <- NA

names_list <- read.table("names_list.txt", header=F, stringsAsFactors=F)
names_list$Scaffold <- sub(">","",names_list$V1)
names_list$Species <- gsub("_NODE.*","",names_list$Scaffold)
names_list$transcript <- gsub(".*NODE_","NODE_",names_list$Scaffold)
names_list$V1 <- NULL


#for(i in 1:length(unique(names_list$Species))){
#
# target1 <- unique(names_list$Species)[i]
#
# scaffolds_of_species <- names_list[names_list$Species==target1,"transcript"]
#
# stats[stats$transcript %in% scaffolds_of_species,"Species"] <- target1
#}

cat("Number of ubique species:",length(unique(stats$Species)))
## should be 695 for bin ref + ruminants (dereplicated)

max_species <- 695 ## just for doublechecking my work below


Species_Length <- data.frame(tapply(stats$Length, stats$Species, sum))
Species_Length$Species <- rownames(Species_Length)
rownames(Species_Length) <- NULL
colnames(Species_Length)[1] <- "Length"

setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon")
quant_files <- list.files(pattern="counts")



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
  
  unq_species <- unique(quant_file$Species)
  
  num_species <- length(unq_species)
  
  if(num_species>max_species){message("ERROR");break}
  
  Sys.time() ## 4 min - 3527 species ## 10 seconds - 695 species
  abundance_results <- data.frame(t(mapply(unq_species, FUN=calc.abund.function)))
  Sys.time()
  
  colnames(abundance_results) <- c("base.pairs","abundance")
  abundance_results$Species <- rownames(abundance_results)
  rownames(abundance_results) <- NULL
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon/01_Abundance_Results")
  write.csv(abundance_results,paste0(sample11, "_abundance.csv"), row.names = F)
  
}
