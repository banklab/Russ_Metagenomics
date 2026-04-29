

library(data.table)

outs <- cmh_by_qval2[cmh_by_qval2$OUTLIER,c("bin","Scaffold","POS","deer")]

outs$Original <- NA
outs$New <- NA
outs$Non.Fixed <- NA

for(i in 1:dim(outs)[1]){
  
  site <- outs[i,]
  
  bin_df <- fread(list.files(pattern=site$bin), header=T, stringsAsFactors = F)
  
  out_res <- bin_df[gsub("_asm_.*","",bin_df$Scaffold)==site$Scaffold & bin_df$POS==site$POS,]
  
  out_res2 <- out_res[out_res$DP>4,]
  
  deer2 <- out_res2$Deer[duplicated(out_res2$Deer)]
  
  if( all.equal(deer2, site$deer)==FALSE ){stop("deer?")}
  
  
  out_res3 <- out_res2[out_res2$Deer %in% deer2,]
  
  outs[i,"Original"] <- sum(out_res3$Original)
  outs[i,"New"] <- sum(out_res3$Original==FALSE)
  
  outs[i,"Non.Fixed"] <- sum(out_res3$Original==FALSE & out_res3$Maj.Freq<0.90)

}
