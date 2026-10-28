

### LONG

library(purrr)
library(dplyr)
library(data.table)


pacbio_samples <- c('2_1','2_10','2_2','2_3','2_4','2_5','2_8','2_9','4_1','4_10','4_2','4_3','4_4','4_5','4_6','4_8','4_9','6_1','6_10','6_2','6_3','6_4','6_5','6_6','6_8','6_9','7_5','7_6')

for(i in 1:28){
  
  choose_sample <- pacbio_samples[i] 
  
  dat <- fread(paste0(choose_sample,"_LR28_InStrain_SNVs_methods.csv"), header=T, stringsAsFactors = F)
  
  snp_spacing <- dat |>
    arrange(bin, Scaffold, POS) |>
    group_by(bin, Scaffold) |>
    filter(n() > 2) |>
    summarise(
      n_snps      = n(),
      mean_dist   = mean(diff(POS)),
      var_dist    = var(diff(POS)),
      median_dist = median(diff(POS)),
      cv_dist     = sd(diff(POS)) / mean(diff(POS)),
      iod         = var(diff(POS)) / mean(diff(POS)),
      n_pairs     = n() - 1,
      .groups     = "drop"
    )
  
  if(i==1){ snp_spacing2 <- snp_spacing } else { snp_spacing2 <- rbind(snp_spacing2,snp_spacing) }
  
}

snp_spacing2$Method <- "LR28"

write.csv(snp_spacing2, "LR28_snps_clustering.csv", row.names = F)



### SHORT

library(purrr)
library(dplyr)
library(data.table)


pacbio_samples <- c('2_1','2_10','2_2','2_3','2_4','2_5','2_8','2_9','4_1','4_10','4_2','4_3','4_4','4_5','4_6','4_8','4_9','6_1','6_10','6_2','6_3','6_4','6_5','6_6','6_8','6_9','7_5','7_6')

for(i in 1:28){
  
  choose_sample <- pacbio_samples[i] 
  
  dat <- fread(paste0(choose_sample,"_SR28_InStrain_SNVs_methods.csv"), header=T, stringsAsFactors = F)
  
  snp_spacing <- dat |>
    arrange(bin, Scaffold, POS) |>
    group_by(bin, Scaffold) |>
    filter(n() > 2) |>
    summarise(
      n_snps      = n(),
      mean_dist   = mean(diff(POS)),
      var_dist    = var(diff(POS)),
      median_dist = median(diff(POS)),
      cv_dist     = sd(diff(POS)) / mean(diff(POS)),
      iod         = var(diff(POS)) / mean(diff(POS)),
      n_pairs     = n() - 1,
      .groups     = "drop"
    )

  if(i==1){ snp_spacing2 <- snp_spacing } else { snp_spacing2 <- rbind(snp_spacing2,snp_spacing) }

}

snp_spacing2$Method <- "SR28"

write.csv(snp_spacing2, "SR28_snps_clustering.csv", row.names = F)


