

# This many sites in at least 2 deer shared between Environments 
SNPs_Threshold <- 10e3


EnvA <- 8

EnvB <- 10



library(data.table)


setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/05_Original_Sites_and_REF_Sites")

pop1 <- data.frame(fread(paste0("Env",EnvA,"x",EnvB,"_ALL_snps.csv"), header=T, stringsAsFactors = F))

pop2 <- data.frame(fread(paste0("Env",EnvB,"x",EnvA,"_ALL_snps.csv"), header=T, stringsAsFactors = F))



pop1_sites <- pop1$Sp.ID.deer
pop2_sites <- pop2$Sp.ID.deer

### duplicated or unique sites by deer ###

# same sites in the same deer
sites_in_both_pops_by_deer <- c(pop1_sites,pop2_sites)[duplicated(c(pop1_sites,pop2_sites))]
# unique sites to a pop, or same sites but not in same deer
unique_sites_by_deer <- c(pop1_sites,pop2_sites)[!duplicated(c(pop1_sites,pop2_sites))]

if(sum(dim(pop1)[1],dim(pop2)[1]) != sum(length(sites_in_both_pops_by_deer), length(unique_sites_by_deer))){message("ERROR");break}


sites_in_both_pops <- gsub("_d.*","",sites_in_both_pops_by_deer)
sites_in_both_Table <- table(sites_in_both_pops)

## keep only sites that are at least 2x (sites that are common to both pops and in at least 2 of the same deer)
# (This is irrespective of species currently)
good_sites_TAB <- sites_in_both_Table[sites_in_both_Table>=2]
good_sites <- names(good_sites_TAB)
number_of_deer_per_site <- table(good_sites_TAB)

## count number of good sites by species now
species_good_sites <- gsub("_sc.*","",good_sites)
species_good_sites_TAB <- table(species_good_sites)


max(species_good_sites_TAB)

## Filter
GOOD_species_sites <- species_good_sites_TAB[species_good_sites_TAB>=SNPs_Threshold]
GOOD_species <- names(GOOD_species_sites)
GOOD_species2 <- paste0(GOOD_species,"_sc")

## This is final list of sites to use
## Sites are in both pops in at least 2 deer
## Sites are only from species that pass SNP filter threshold
FINAL_sites <- grep(paste0(GOOD_species2, collapse="|"),good_sites, value=T)

if(sum(GOOD_species_sites) != length(FINAL_sites)){message("ERROR1");break}


pop1_final_sites <- pop1[pop1$Sp.ID %in% FINAL_sites,]
pop2_final_sites <- pop2[pop2$Sp.ID %in% FINAL_sites,]


setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/06_Good_Sites")

write.csv(pop1_final_sites, paste0("Env",EnvA,"_x_Env",EnvB,"_final_sites_Threshold",SNPs_Threshold,".csv"), row.names = F)

write.csv(pop2_final_sites, paste0("Env",EnvB,"_x_Env",EnvA,"_final_sites_Threshold",SNPs_Threshold,".csv"), row.names = F)
