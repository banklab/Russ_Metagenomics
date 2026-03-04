
library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/FORMAT")
file_list <- list.files(pattern="_LR_InStrain_SNVs_format.csv")

for(i in 1:length(file_list)){

  snp_data <- fread(file_list[i], header=T, stringsAsFactors=F)

  sp_data <- snp_data[snp_data$bin=="Hy_Se_2_8_bin.23",]

  sp_data2 <- sp_data[sp_data$Scaffold=="s60.ctg000061c_asm_hybrid_semibin_2_8_bin.23",]

  if(i==1){ crypto <- sp_data2 } else { crypto <- rbind(crypto,sp_data2) }
  
  }

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/mcorr")
write.csv(crypto, "crypto_snps.csv", row.names=F)

library(data.table)
setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/mcorr")
crypto <- fread("crypto_snps.csv", header=T, stringsAsFactors=F)

order_data <- crypto[order(crypto$POS, decreasing=F),]

order_data <- order_data[order_data$DP>=5,]

order_data$SAMPLE <- paste0(order_data$Deer,"_",order_data$Env)


format.snps.function <- function(one.site){

  max.freq <- c("ref_freq","con_freq","var_freq")[which(one.site[c("ref_freq","con_freq","var_freq")] == max(one.site[c("ref_freq","con_freq","var_freq")]))]
  max.base <- c("ref_base","con_base","var_base")[which(one.site[c("ref_freq","con_freq","var_freq")] == max(one.site[c("ref_freq","con_freq","var_freq")]))]

  major.freq <- as.numeric(one.site[max.freq])
  
  major.base <- as.character(one.site[max.base])

  ## tie for major allele
  if(length(major.base)>1){
    major.base <- major.base[sample(1:length(major.base), 1)]
  }


  data.table(
    Sample = one.site["SAMPLE"],
    POS = as.numeric(one.site["POS"]),
    base = major.base
  )
}


Sys.time()
major_base_data <- apply(order_data, MARGIN=1, FUN=format.snps.function)
Sys.time()
major_base_data2 <- as.data.frame(do.call(rbind, major_base_data))


samples <- unique(major_base_data2$Sample)
positions <- sort(unique(major_base_data2$POS))

align_mat <- matrix("N", nrow = length(samples), ncol = length(min(major_base_data2$POS):max(major_base_data2$POS)), dimnames = list(samples, min(major_base_data2$POS):max(major_base_data2$POS)))

for(i in min(major_base_data2$POS):max(major_base_data2$POS)) {
  samp <- major_base_data2$Sample[i]
  pos <- as.character(major_base_data2$POS[i])
  base <- major_base_data2$base[i]
  
  align_mat[samp, pos] <- base
}


