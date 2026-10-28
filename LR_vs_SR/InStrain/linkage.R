
## LONG

library(tidyverse)

pacbio_samples <- c('2_1','2_10','2_2','2_3','2_4','2_5','2_8','2_9','4_1','4_10','4_2','4_3','4_4','4_5','4_6','4_8','4_9','6_1','6_10','6_2','6_3','6_4','6_5','6_6','6_8','6_9','7_5','7_6')


ld_bins     <- seq(0, 250, by = 5)
ld_bin_labs <- paste0(head(ld_bins, -1), "-", tail(ld_bins, -1))


for(i in 1:28){
  
  dat <- fread(paste0(pacbio_samples[i],"_LR28_InStrain_linkage.tsv"), header=T, stringsAsFactors = F) |> as_tibble()
  dat$Sample <- pacbio_samples[i]
  dat$bin <- gsub(".*asm_","",dat$scaffold)
  dat$Method <- "LR28"
  
  decay <- dat |>
    filter(!is.na(r2)) |>
    mutate(
      dist_bin = cut(distance, breaks = ld_bins, labels = ld_bin_labs, right = TRUE),
      dist_mid = as.integer(sub("-.*", "", dist_bin)) + 2.5
    ) |>
    filter(!is.na(dist_bin)) |>
    group_by(Sample, bin, Method, dist_bin, dist_mid) |>
    summarise(
      mean_r2 = mean(r2),
      median_r2 = median(r2),
      n_pairs = n(),
      sd_r2 = sd(r2),
      sem_r2 = sd(r2) / sqrt(n()),
      .groups = "drop"
    )
  
  if(i==1){ decay2 <- decay } else { decay2 <- rbind(decay2,decay) }
}

decay2$bin <- paste0(decay2$Method,"_",decay2$bin)

write.csv(decay2,"LR28_Linkage.csv", row.names = F)






## SHORT

library(tidyverse)

pacbio_samples <- c('2_1','2_10','2_2','2_3','2_4','2_5','2_8','2_9','4_1','4_10','4_2','4_3','4_4','4_5','4_6','4_8','4_9','6_1','6_10','6_2','6_3','6_4','6_5','6_6','6_8','6_9','7_5','7_6')


ld_bins     <- seq(0, 250, by = 5)
ld_bin_labs <- paste0(head(bins, -1), "-", tail(bins, -1))


for(i in 1:28){
  
  dat <- fread(paste0(pacbio_samples[i],"_SR_InStrain_linkage.tsv"), header=T, stringsAsFactors = F) |> as_tibble()
  dat$Sample <- pacbio_samples[i]
  dat$bin <- gsub(".*asm_","",dat$scaffold)
  dat$Method <- "SR28"
  
  decay <- dat |>
    filter(!is.na(r2)) |>
    mutate(
      dist_bin = cut(distance, breaks = ld_bins, labels = ld_bin_labs, right = TRUE),
      dist_mid = as.integer(sub("-.*", "", dist_bin)) + 2.5
    ) |>
    filter(!is.na(dist_bin)) |>
    group_by(Sample, bin, Method, dist_bin, dist_mid) |>
    summarise(
      mean_r2 = mean(r2),
      median_r2 = median(r2),
      n_pairs = n(),
      sd_r2 = sd(r2),
      sem_r2 = sd(r2) / sqrt(n()),
      .groups = "drop"
    )
  
  if(i==1){ decay2 <- decay } else { decay2 <- rbind(decay2,decay) }
}

decay2$bin <- paste0(decay2$Method,"_",decay2$bin)

write.csv(decay2,"SR28_Linkage.csv", row.names = F)

