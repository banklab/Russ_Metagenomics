

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/repeats/SR_results/dereplicated_genomes")

ise_list <- list.files(pattern="sum")
ise_results <- data.frame(array(NA, dim=c(length(ise_list),3),dimnames=list(c(),c("Method.genome","IS.total","IS.percent.genome"))))


for(i in 1:length(ise_list)){

ise1 <- read.table(ise_list[i], stringsAsFactors=F)

  ise_results[i,1] <- ise1[nrow(ise1),1]

 ise_results[i,2] <- ise1[nrow(ise1),3]

 ise_results[i,3] <- ise1[nrow(ise1),4]


  }

ise_results$Method.genome <- paste0("SR28_",ise_results$Method.genome)




setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/repeats/SR_results2/dereplicated_genomes")

ise2_list <- list.files(pattern="sum")
ise2_results <- data.frame(array(NA, dim=c(length(ise2_list),3),dimnames=list(c(),c("Method.genome","IS.total","IS.percent.genome"))))


for(i in 1:length(ise2_list)){

ise21 <- read.table(ise2_list[i], stringsAsFactors=F)

  ise2_results[i,1] <- ise21[nrow(ise21),1]

 ise2_results[i,2] <- ise21[nrow(ise21),3]

 ise2_results[i,3] <- ise21[nrow(ise21),4]


  }

ise2_results$Method.genome <- paste0("SR28_",ise2_results$Method.genome)





setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/repeats/LR_results/dereplicated_genomes")

ise3_list <- list.files(pattern="sum")
ise3_results <- data.frame(array(NA, dim=c(length(ise3_list),3),dimnames=list(c(),c("Method.genome","IS.total","IS.percent.genome"))))


for(i in 1:length(ise3_list)){

ise31 <- read.table(ise3_list[i], stringsAsFactors=F)

  ise3_results[i,1] <- ise31[nrow(ise31),1]

 ise3_results[i,2] <- ise31[nrow(ise31),3]

 ise3_results[i,3] <- ise31[nrow(ise31),4]


  }

ise3_results$Method.genome <- paste0("LR28_",ise3_results$Method.genome)






setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/repeats/LR_results2/dereplicated_genomes")

ise4_list <- list.files(pattern="sum")
ise4_results <- data.frame(array(NA, dim=c(length(ise4_list),3),dimnames=list(c(),c("Method.genome","IS.total","IS.percent.genome"))))


for(i in 1:length(ise4_list)){

ise41 <- read.table(ise4_list[i], stringsAsFactors=F)

  ise4_results[i,1] <- ise41[nrow(ise41),1]

 ise4_results[i,2] <- ise41[nrow(ise41),3]

 ise4_results[i,3] <- ise41[nrow(ise41),4]


  }

ise4_results$Method.genome <- paste0("LR28_",ise4_results$Method.genome)






ise_full <- rbind(ise_results,ise2_results,ise3_results,ise4_results)

## ADD ZEROS
grep 'No IS element was found for' slurm-isescan_*SR*out
grep 'No IS element was found for' slurm-isescan_*LR*out

ise_zero_SR <- data.frame(array(0, dim=c(18,3),dimnames=list(c(),c("Method.genome","IS.total","IS.percent.genome"))))
ise_zero_SR$Method.genome <- paste0("SR28_",c("semibin_2_1_bin.18.fa", "semibin_2_2_bin.7.fa", "semibin_4_9_bin.35.fa", "semibin_6_10_bin.117_sub.fa", "semibin_6_1_bin.65.fa", "semibin_6_4_bin.26_sub.fa", "semibin_2_1_bin.48.fa", "semibin_4_2_bin.12.fa", "semibin_4_9_bin.3.fa", "semibin_6_10_bin.42_sub.fa", "semibin_6_1_bin.93.fa", "semibin_6_4_bin.44_sub.fa","metabat_2_2_bin.131.fa", "metabat_2_3_bin.62.fa", "metabat_4_10_bin.60.fa", "metabat_4_8_bin.62.fa", "metabat_4_8_bin.78_sub.fa", "metabat_6_9_bin.127.fa"))

ise_zero_LR <- data.frame(array(0, dim=c(9,3),dimnames=list(c(),c("Method.genome","IS.total","IS.percent.genome"))))
ise_zero_LR$Method.genome <- paste0("LR28_",c("metabat_4_3_bin.128.fa","semibin_6_2_bin.49","semibin_4_4_bin.165.fa","maxbin_2_1_bin.007.fa", "metabat_4_10_bin.273.fa", "metabat_4_3_bin.351.fa", "metabat_4_9_bin.150.fa", "metabat_4_9_bin.60.fa", "metabat_6_10_bin.249_sub.fa"))

ise_full2 <- rbind(ise_full,ise_zero_SR,ise_zero_LR)

write.csv()

