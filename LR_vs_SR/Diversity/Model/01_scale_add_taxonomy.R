
snp_long_scale$CoverM.abundance_z <- scale(snp_long_scale$CoverM.abundance)
snp_long_scale$genome.size_z <- scale(log10(snp_long_scale$genome.size))
snp_long_scale$completeness_z <- scale(snp_long_scale$completeness)
snp_long_scale$contamination_z <- scale(snp_long_scale$contamination)
snp_long_scale$Coding_Density_z <- scale(snp_long_scale$Coding_Density)
snp_long_scale$Average_Gene_Length_z <- scale(snp_long_scale$Average_Gene_Length)
snp_long_scale$GC_Content_z <- scale(snp_long_scale$GC_Content)
snp_long_scale$N50_z <- scale(log10(snp_long_scale$N50))
snp_long_scale$auN_z <- scale(log10(snp_long_scale$auN))



## add mapping

setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/Mapping")
mappingDF <- read.csv("Mapping.rate.comparison.csv", header=T, stringsAsFactors = F)

summary(mappingDF$Mapping.rate)

mappingDF$Mapping.rate_z <- scale(mappingDF$Mapping.rate)

mappingDF_LR <- mappingDF[mappingDF$Method=="LR28",]
mappingDF_SR <- mappingDF[mappingDF$Method=="SR28",]

snp_long_scale_LR <- snp_long_scale[snp_long_scale$Method=="LR28",]
snp_long_scale_SR <- snp_long_scale[snp_long_scale$Method=="SR28",]

snp_long_scale_LR2 <- merge(snp_long_scale_LR, mappingDF_LR[,c("Sample","Mapping.rate_z")])
snp_long_scale_SR2 <- merge(snp_long_scale_SR, mappingDF_SR[,c("Sample","Mapping.rate_z")])

snp_long_scale <- rbind(snp_long_scale_LR2,snp_long_scale_SR2)

################################################################################

## Add taxonomy

setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/taxonomy")
tax_LR28 <- data.frame(fread("DEER_LR28_Taxonomy.csv", header=T, stringsAsFactors = F))
tax_SR28 <- data.frame(fread("DEER_SR28_Taxonomy.csv", header=T, stringsAsFactors = F))

snp_long_scale$Tax.Class <- NA
snp_long_scale$Tax.Phylum <- NA

for(i in 1:nrow(snp_long_scale)){
  
  check_method <- snp_long_scale[i,"Method"]
  
  if(check_method=="LR28"){
    
    snp_long_scale[i,"Tax.Phylum"] <- tax_LR28[tax_LR28$user_genome == snp_long_scale[i,"Genome"],"Phylum"]
    snp_long_scale[i,"Tax.Class"] <- tax_LR28[tax_LR28$user_genome == snp_long_scale[i,"Genome"],"Class"]
    
  }
  
  if(check_method=="SR28"){
    
    snp_long_scale[i,"Tax.Phylum"] <- tax_SR28[tax_SR28$user_genome == snp_long_scale[i,"Genome"],"Phylum"]
    snp_long_scale[i,"Tax.Class"] <- tax_SR28[tax_SR28$user_genome == snp_long_scale[i,"Genome"],"Class"]
    
  }
  
}

sum(is.na(snp_long_scale$Tax.Class))
sum(is.na(snp_long_scale$Tax.Phylum))


################################################################################


snp_long_scale$Gut.region <- NA

snp_long_scale[snp_long_scale$Env %in% 1:4, "Gut.region"] <- "Foregut"
snp_long_scale[snp_long_scale$Env %in% 5:6, "Gut.region"] <- "Midgut"
snp_long_scale[snp_long_scale$Env %in% 8:10, "Gut.region"] <- "Hindgut"


###
