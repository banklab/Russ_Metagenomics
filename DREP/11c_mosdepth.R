library(data.table)

temp_files <- list.files(pattern="temp")

for(i in 1:length(temp_files)){
df <- data.frame(fread(temp_files[i], header=T, stringsAsFactors=F)
if(i==1){cov_df2<-df} else { cov_df2 <- rbind(cov_df2,df) }
  }



sp_list <- unique(cov_df2$bin)

for(ii in 1:length(sp_list)){
sp_cov <- cov_df2[cov_df2$bin==sp_list[ii],]
write.csv(sp_cov, paste0(sp_list[ii],"_cover.csv"), row.names=F)
}
