

library(data.table)


EnvA <- 8
EnvB <- 10

## depth filter for a SINGLE population
Depth_Filter <- 5
## VAR freq filter for a SINGLE population
VAR_Filter <- 0.05


setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/04_Combined_Sites")
file_list <- list.files(pattern=paste0("_Env",EnvA,"xEnv",EnvB,"_Combined_Sites.csv"))


for(i in 1:length(file_list)){

  SPECIES <- gsub("_Env.*","",file_list[i])
  
  cat(SPECIES,"\n")
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/04_Combined_Sites")
  combined_df <- data.frame(fread(file_list[i], header=T, stringsAsFactors = F))
  
  cat("input sites:",length(unique(combined_df$Sp.ID.deer)),"\n")
  
  
  ## doublecheck DP from FORMATTED sites
  depth_check <- combined_df[1:c(which(combined_df$Original==FALSE)[1]-1),"DP"]
  cat("min input depth:",min(depth_check),"\n")
  
  
  ## filter for depth
  filter_df <- combined_df[combined_df$DP >= Depth_Filter,]
  
  ## keep only sites that pass filter in BOTH environments
  filter_df2 <- filter_df[filter_df$Sp.ID.deer %in% filter_df$Sp.ID.deer[duplicated(filter_df$Sp.ID.deer)],]
  
  ## filter sites fixed in both pops (called VAR by instrain because not REF base)
  sum_of_both_pops <- tapply(filter_df2$Maj.Freq, filter_df2$Sp.ID.deer, sum)
  sites_fixed <- sum_of_both_pops[sum_of_both_pops>(2-VAR_Filter)]
  
  filter_df3 <- filter_df2[!filter_df2$Sp.ID.deer %in% names(sites_fixed),]
  
  if( length(sites_fixed) != (dim(filter_df2)[1]/2 - dim(filter_df3)[1]/2) ){message("error2");break}
  
  # max major freq in both pops
  max(tapply(filter_df3$Maj.Freq, filter_df3$Sp.ID.deer, sum))
  
  
  ## filter for min VAR %
  ## for each site - as long as 1 pop out of the 2 has 95% major allele freq or less
  min_allele_freq <- tapply(filter_df3$Maj.Freq, filter_df3$Sp.ID.deer, min)
  
  filter_df4 <- filter_df3[filter_df3$Sp.ID.deer %in% names(min_allele_freq[min_allele_freq<=(1-VAR_Filter)]),]
  
  
  cat("filtered sites:",length(unique(filter_df4$Sp.ID.deer)),"\n")
  cat("proportion:",length(unique(filter_df4$Sp.ID.deer)) / length(unique(combined_df$Sp.ID.deer)),"\n")
  
  
  ## SPOT CHECK THESE
  these_are_filtered_out <- filter_df3[!filter_df3$Sp.ID.deer %in% names(min_allele_freq[min_allele_freq<=(1-VAR_Filter)]),]
  
  ## I think(?) these sites are only called by instrain in the first place because different base than reference base
  ## ie, MAF is less than 5%, so wouldn't be called normally
  # max(these_are_filtered_out$ref_freq)
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/14_InStrain/05_Filtered_Sites")
  write.csv(filter_df4, paste0(SPECIES,"_Env",EnvA,"xEnv",EnvB, "_Filter_snps",length(unique(filter_df4$Sp.ID.deer)),".csv"), row.names = F)
  
}

