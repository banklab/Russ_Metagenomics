
library(data.table)

snp_data <- fread("1_10_LR_InStrain_SNVs_format.csv", header=T, stringsAsFactors=F)

sp_data <- snp_data[snp_data$bin=="Hy_Se_2_8_bin.23",]

table(sp_data$Scaffold)

sp_data2 <- sp_data[sp_data$Scaffold=="s60.ctg000061c_asm_hybrid_semibin_2_8_bin.23",]

max(table(sp_data2$ID))

order_data <- sp_data2[order(sp_data2$POS, decreasing=F),]

order_data <- order_data[order_data$DP>=5,]

#lapply(order_data[1:2,], FUN=format.snps.function)

res <- data.frame(array(NA, dim=c(1, nrow(order_data))))

Sys.time()
for(i in 1:dim(order_data)[1]){

  one.site <- order_data[i,]
  
  max.freq <- c("ref_freq","con_freq","var_freq")[which(one.site[,c("ref_freq","con_freq","var_freq")] == max(one.site[,c("ref_freq","con_freq","var_freq")]))]
  max.base <- c("ref_base","con_base","var_base")[which(one.site[,c("ref_freq","con_freq","var_freq")] == max(one.site[,c("ref_freq","con_freq","var_freq")]))]

  major.freq <- as.numeric(one.site[, ..max.freq])
  major.base <- unname(one.site[, ..max.base])

  res[1,i] <- major.base
  
  }
Sys.time()




