


library(data.table)

count.maf.function <- function(one.gene){
  
  sites.in.gene <- diversity_sub[diversity_sub$Scaffold==as.numeric(one.gene["Scaffold"]) & diversity_sub$POS>=as.numeric(one.gene["Start"]) & diversity_sub$POS<=as.numeric(one.gene["End"]),]
  
  polymorphic.sites <- sum(sites.in.gene$allele_count>1)
  
  output <- data.frame(array(NA, dim = c(1,13), dimnames = list(c(),c("bin","Gene","Type","Size","S","prop.S","num01","num05","num10","num25","num25over","num40over","multiallelic"))))

  output[,"bin"] <- one.gene["bin"]
  output[,"Gene"] <- one.gene["Gene"]
  output[,"Type"] <- one.gene["Type"]
  output[,"Size"] <- one.gene["Size"]
  output[,"S"] <- polymorphic.sites
  output[,"Scaffold"] <- one.gene["Scaffold"]
  output[,"Start"] <- one.gene["Start"]
  output[,"End"] <- one.gene["End"]
  
  if(polymorphic.sites>0){
    
    output[,"num01"] <- sum(sites.in.gene$min.freq < 0.01)
    output[,"num05"] <- sum(sites.in.gene$min.freq < 0.05)
    output[,"num10"] <- sum(sites.in.gene$min.freq < 0.10)
    output[,"num25"] <- sum(sites.in.gene$min.freq < 0.25)
    output[,"num25over"] <- sum(sites.in.gene$min.freq >= 0.25)
    output[,"num40over"] <- sum(sites.in.gene$min.freq >= 0.40)
    
    output[,"multiallelic"] <- sum( rowSums(sites.in.gene[,c("A","C","G","T")]>0) >2 )
    
  }
  
  return(output)
  
}




setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal")
gene_intergenic_data <- data.frame(fread("DEER_Gene_and_Intergenic.csv", header=T, stringsAsFactors = F))


setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity/02_Diversity")
diversity_files <- list.files(pattern = "Diversity_by_site.csv")


for(i in 1:length(diversity_files)){
  
  diversity <- data.frame(fread(diversity_files[i], header=T, stringsAsFactors = F))
  
  SAMPLE <- gsub("_Diversity.*","",diversity_files[i])
  
  species_list1 <- unique(diversity$bin)
  
 Sys.time()
  for(s in 1:length(species_list1)){
    
    SPECIES <- species_list1[s]
    
    diversity_sub <- diversity[diversity$bin==SPECIES,]

    maf_list <- apply(gene_intergenic_data[gene_intergenic_data$bin==SPECIES,], MARGIN=1, FUN=count.maf.function)
    
    maf_results <- as.data.frame(do.call(rbind, maf_list))
    
    if(s==1){ maf_results2 <- maf_results } else { maf_results2 <- rbind(maf_results2,maf_results) }
    
  } # species
 Sys.time()
 
  maf_results2$Scaffold <- as.numeric(maf_results2$Scaffold)
  maf_results2$Start <- as.numeric(maf_results2$Start)
  maf_results2$End <- as.numeric(maf_results2$End)
  maf_results2$Size <- as.numeric(maf_results2$Size)
  
  maf_results2$prop.S <- maf_results2$S / maf_results2$Size
  
  maf_results2$prop.01 <- maf_results2$num01 / maf_results2$Size
  maf_results2$prop.05 <- maf_results2$num05 / maf_results2$Size
  maf_results2$prop.10 <- maf_results2$num10 / maf_results2$Size
  maf_results2$prop.25 <- maf_results2$num25 / maf_results2$Size
  maf_results2$prop.over.25 <- maf_results2$num25over / maf_results2$Size
  maf_results2$prop.over.40 <- maf_results2$num40over / maf_results2$Size
  maf_results2$prop.multi <- maf_results2$multiallelic / maf_results2$Size
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity")
  write.csv(maf_results2, paste0(SAMPLE,"_MAF_results.csv"), row.names = F)
  
} # div
