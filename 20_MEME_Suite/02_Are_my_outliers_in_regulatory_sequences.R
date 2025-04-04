
setwd("/storage/scratch/users/rj23k073/04_DEER/19_Diversity")
outlier_df <- read.csv("outlier_df.csv", header=T, stringsAsFactors = F)
outlier_snps <- read.csv("outlier_SNPS.csv", header=T, stringsAsFactors = F)

intergenic_snps <- outlier_snps[grepl("int",outlier_snps$annotate),]



setwd("/rs_scratch/users/rj23k073/04_DEER/20_Meme/01_Outliers")

dir_list <- list.files()

database_list <- c("collect","fan","prodoric","regtransbase")


results <- data.frame(array(NA, dim = c(0,12), dimnames = list(c(),c("bin","database","Scaffold","POS","motif1","motif1b","pvalue1","motif2","motif2b","pvalue2", "distance2","matched.sequence"))))


for(i in 1:length(dir_list)){
  
  SPECCC <- gsub("_deer|\\.intergenic","",dir_list[i])
  
  cat(SPECCC,"\n")
  
  species_outliers <- intergenic_snps[intergenic_snps$bin==SPECCC,]

  if(dim(species_outliers)[1]<1){stop("aiskjdhal")}
  
  
  for(j in 1:length(database_list)){
    
    setwd(paste0("/rs_scratch/users/rj23k073/04_DEER/20_Meme/01_Outliers/",dir_list[i],"/",database_list[j]))
    
    data <- read.csv("fimo.tsv", header=T, stringsAsFactors=F, sep="\t")
    
    data$Scaffold <- as.numeric(gsub("NODE_|_length.*","",data$sequence_name))
    
    for(k in 1:dim(species_outliers)[1]){
      
      temp_results <- data.frame(array(NA, dim = c(1,12), dimnames = list(c(),c("bin","database","Scaffold","POS","motif1","motif1b","pvalue1","motif2","motif2b","pvalue2","distance2","matched.sequence"))))
      temp_results[,1] <- SPECCC
      temp_results[,2] <- database_list[j]
      
      
      outlier_here <- species_outliers[k,]
      
      temp_results[,3] <- outlier_here$Scaffold
      temp_results[,4] <- outlier_here$POS
      
      scaffold_data <- data[!is.na(data$Scaffold) & data$Scaffold==outlier_here$Scaffold,]
      
      target <- scaffold_data[scaffold_data$start <= outlier_here$POS & scaffold_data$stop >= outlier_here$POS,]
      
      target2 <- scaffold_data[scaffold_data$start <= outlier_here$POS+50 & scaffold_data$stop >= outlier_here$POS-50,]
      
      if(dim(target)[1]>0){
        
        target_best <- target[target$p.value == min(target$p.value),][1,]
        
        temp_results[,5:7] <- target_best[,c("motif_id","motif_alt_id","p.value")]
        temp_results[,12] <- target_best$matched_sequence
      }
      
      if(dim(target2)[1]>0){
        
        target2$start.distance <- abs((target2$start - outlier_here$POS))
        target2$stop.distance <- abs((target2$stop - outlier_here$POS))
        
        closest_distance <- min(c(target2$start.distance,target2$stop.distance), na.rm=T)
        
        target2_best <- target2[target2$start.distance == closest_distance | target2$stop.distance == closest_distance, ]
        
        target2_best <- target2_best[target2_best$p.value == min(target2_best$p.value),][1,]
        
            
        temp_results[,8:10] <- target2_best[,c("motif_id","motif_alt_id","p.value")]
        temp_results[,11] <- closest_distance
        temp_results[,12] <- target2_best$matched_sequence
        
      }
      
      results <- rbind(results, temp_results)
      
      
    }
    
    
  } # database list
  
} # species


unique_motifs <- unique(results[!is.na(results$motif2) & results$database=="collect","motif2"])

setwd("/rs_scratch/users/rj23k073/04_DEER/20_Meme/01_Outliers")
write.table(unique_motifs, "motifs.txt", row.names = F, col.names = F, quote = F)

