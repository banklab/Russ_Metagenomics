
## CALCULATE GENOME COPIES PER MILLION READS


calc.abund.function <- function(pick.species){
  
  species.quant <- quant_file[quant_file$bin==pick.species,]
  
  unq.contigs <- unique(species.quant$transcript)
  
  num.contigs <- length(unq.contigs)
  
  species.quant2 <- merge(species.quant, stats[,!names(stats) %in% "bin"], by="transcript", all = FALSE)
  
  species.quant2$abundance <- species.quant2$count * species.quant2$Length
  
  species.base.pairs <- sum(species.quant2$abundance)
  
  species.genome.length <- Species_Length[Species_Length$bin==pick.species,"Length"]
  
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
stats <- read.table("DEER_fa_STATS.txt", header=F, stringsAsFactors = F)
colnames(stats) <- c("transcript","Length")

stats$bin <- gsub(".*_asm_","",stats$transcript)


cat("Number of ubique species:",length(unique(stats$bin)))

max_species <- 909 ## just for doublechecking my work below


Species_Length <- data.frame(tapply(stats$Length, stats$bin, sum))
Species_Length$bin <- rownames(Species_Length)
rownames(Species_Length) <- NULL
colnames(Species_Length)[1] <- "Length"

setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon")
quant_files <- list.files(pattern="counts")



for(i in 1:length(quant_files)){

  sample11 <- gsub("\\.quant.*","",quant_files[i])
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon")
  quant_file <- read.table(quant_files[i], header=T, stringsAsFactors = F)
  
  quant_file$bin <- NA

  for(ii in 1:length(unique(stats$bin))){

   target1 <- unique(stats$bin)[ii]

   scaffolds_of_species <- stats[stats$bin==target1,"transcript"]

   quant_file[quant_file$transcript %in% scaffolds_of_species,"bin"] <- target1
  } 

if(sum(is.na(quant_file$bin))>0){message("error11");break}
  
  unq_species <- unique(quant_file$bin)
  
  num_species <- length(unq_species)
  
  if(num_species>max_species){message("ERROR");break}
  
  
  abundance_results <- data.frame(t(mapply(unq_species, FUN=calc.abund.function)))
  
  
  colnames(abundance_results) <- c("base.pairs","abundance")
  abundance_results$bin <- rownames(abundance_results)
  rownames(abundance_results) <- NULL
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/15_Salmon/01_Abundance_Results")
  write.csv(abundance_results,paste0(sample11, "_abundance.csv"), row.names = F)
  
}
