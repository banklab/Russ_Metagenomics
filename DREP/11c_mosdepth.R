library(data.table)

ENV <- 1

cov_df2 <- fread(paste0("ENV",ENV,"_temp_mosdepth.csv"), header=T, stringsAsFactors=F)

sp_list <- unique(cov_df2$bin)

for(ii in 1:length(sp_list)){
sp_cov <- cov_df2[cov_df2$bin==sp_list[ii],]
write.csv(sp_cov, paste0(sp_list[ii],"_ENV",ENV,"coverage.csv"), row.names=F)
}
