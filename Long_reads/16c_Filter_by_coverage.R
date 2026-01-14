
library(data.table)

EnvA <- 8
EnvB <- 10

SNP_filter <- 20e3 ## only using species with at least x number of USEABLE snps (snps that can go into cmh test)


setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites")
snp_list <- list.files(pattern=(paste0("_Env",EnvA,"xEnv",EnvB,"_Filter_snps")))
snp_count <- as.numeric(gsub(".*snps|\\.csv","",snp_list))
snp_list2 <- snp_list[snp_count>=SNP_filter]



for(i in 1:length(snp_list2)){

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites")
  snp_df <- fread(snp_list2[i],header=T, stringsAsFactors=F)

  snp_df$Sample <- paste0(snp_df$Deer,"_",snp_df$Env)
  snp_df$Sample.Scaffold <- paste0(snp_df$Sample,"_",snp_df$Scaffold)

  unique_sample_scaffolds <- unique(snp_df$Sample.Scaffold)
  
  species2 <- gsub("_Env.*","",snp_list2[i])

  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/mosdepth/BED")
  cov_df <- fread(paste0(species2,"_cover.csv"), header=T, stringsAsFactors=F)
  
  cov_df$size <- cov_df$end - cov_df$start
  cov_df$Sample.Scaffold <- paste0(cov_df$Sample,"_",cov_df$Scaffold)
  
  cov_df2 <- cov_df[cov_df$coverage>0,]

  counter <- 1
  
  for(j in 1:length(unique_sample_scaffolds)){

    cov_df3 <- cov_df2[cov_df2$Sample.Scaffold==unique_sample_scaffolds[j],]

    if(dim(cov_df3)[1]<1){next}

    if(max(cov_df3$coverage)<50){next}
    
      c_vec <- rep.int(
        cov_df3$coverage,
        times = cov_df3$size
      )
    
    thresold <- quantile(c_vec, 0.99)

    filter_out <- cov_df3[cov_df3$coverage >= thresold,]

   # snp_df_sub <- snp_df[snp_df$Sample.Scaffold == unique_sample_scaffolds[j],]

    filter_out$start1 <- filter_out$start + 1  ## add 1 for difference between mosdepth and snps indices

   # snps_filtered <- snp_df_sub[!filter_out, on = .(Scaffold, POS >= start1, POS <= end)]


    if(counter==1){ filter_out2 <- filter_out } else { filter_out2 <- rbind(filter_out2,filter_out) }
    counter<-2
    }

  
  if(counter==2){ ## yes filter out
    
    keep_idx <- rep(TRUE, nrow(snp_df))

    for(k in seq_len(nrow(filter_out2))) {
      
      same_sample_scaffold <- snp_df$Sample == filter_out2$Sample[k] & snp_df$Scaffold == filter_out2$Scaffold[k]
      
      in_interval <- snp_df$POS >= filter_out2$start[k] & snp_df$POS <= filter_out2$end[k]
      
      keep_idx[same_sample_scaffold & in_interval] <- FALSE
    }
    
    snps_filtered <- snp_df[keep_idx, ]  

    ## snp_df[keep_idx==FALSE, ] ## these are the filtered snps  
    
  } else { snps_filtered <- snp_df } ## nothing to filter  
  
  filename <- paste0(species2,"_Env",EnvA,"xEnv",EnvB,"_Coverage_Filter_snps",length(unique(snps_filtered$Sp.ID.deer)),".csv")
  
  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites_4")
  write.csv(snps_filtered, filename, row.names=F)

  cat(species2,"\n")
  cat("IN:",length(unique(snp_df$Sp.ID.deer)),"\n")
  cat("OUT:",length(unique(snps_filtered$Sp.ID.deer)),"\n")
  cat("%:",round(dim(snps_filtered)[1]/dim(snp_df)[1],4),"\n")
  cat("\n")

  }

