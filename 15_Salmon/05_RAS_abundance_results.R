
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

setwd("/storage/scratch/users/rj23k073/01_RAS/REFERENCES")
stats <- read.table("RAS_bin_ref_extra_STATS.txt", header=F, stringsAsFactors = F)
colnames(stats) <- c("transcript","Length")

stats$Species <- gsub(".*_asm_","",stats$transcript)

stats2 <- stats

stats2[stats2$Species=="NC_013960.1" | stats2$Species=="NC_013958.1","Species"] <- "Nitrosococcus halophilus"

stats2[grepl("NZ_FUYK010000",stats2$Species),"Species"] <- "Candidatus Nitrosotalea"



cat("Number of unique species:",length(unique(stats2$Species)))
## should be 2575 for bin ref + extra (dereplicated)

max_species <- 2575 ## just for doublechecking my work below


Species_Length <- data.frame(tapply(stats2$Length, stats2$Species, sum))
Species_Length$Species <- rownames(Species_Length)
rownames(Species_Length) <- NULL
colnames(Species_Length)[1] <- "Length"

setwd("/storage/scratch/users/rj23k073/01_RAS/15_Salmon")
quant_files <- list.files(pattern="counts")

for(i in 1:length(quant_files)){

  sample11 <- gsub("\\.quant.*","",quant_files[i])
  
  setwd("/storage/scratch/users/rj23k073/01_RAS/15_Salmon")
  quant_file <- read.table(quant_files[i], header=T, stringsAsFactors = F)
  
  quant_file$Species <- gsub(".*_asm_","",quant_file$transcript)
 
  quant_file[quant_file$Species=="NC_013960.1" | quant_file$Species=="NC_013958.1","Species"] <- "Nitrosococcus halophilus"

  quant_file[grepl("NZ_FUYK010000",quant_file$Species),"Species"] <- "Candidatus Nitrosotalea"


  unq_species <- unique(quant_file$Species)
  
  num_species <- length(unq_species)
  
  if(num_species>max_species){message("ERROR");break}
  
  Sys.time() ## 4 min - 3527 species ## 3 min - 2575 species
  abundance_results <- data.frame(t(mapply(unq_species, FUN=calc.abund.function)))
  Sys.time()
  
  colnames(abundance_results) <- c("base.pairs","abundance")
  abundance_results$Species <- rownames(abundance_results)
  rownames(abundance_results) <- NULL
  
  setwd("/storage/scratch/users/rj23k073/01_RAS/15_Salmon/01_Abundance_Results")
  write.csv(abundance_results,paste0(sample11, "_abundance.csv"), row.names = F)
  
}
