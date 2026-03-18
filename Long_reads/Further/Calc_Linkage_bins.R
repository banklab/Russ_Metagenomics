
library(data.table)

setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Linkage")

ref_index <- read.table("DEER_v2.fa.fai", stringsAsFactors=F, sep = "\t")
colnames(ref_index)[1:2] <- c("Scaffold","Length")

linkage <- data.frame(fread("Linkage_Info_DEER_v2_Redux.csv", header=T, stringsAsFactors = F))

linkage$Scaffold <- linkage$scaffold

top_15 <- c('Hy_Me_2_8_bin.181','Hy_Me_2_8_bin.89','Hy_Me_4_8_bin.143','Hy_Se_2_10_bin.105','Hy_Se_2_8_bin.23','Hy_Se_2_8_bin.24','Hy_Se_4_8_bin.39','Hy_Se_6_8_bin.0','Hy_Se_6_8_bin.55','Hy_Se_6_9_bin.30','LR_Me_4_8_bin.270','LR_Me_6_9_bin.102_sub','LR_Me_6_9_bin.166','LR_Se_2_10_bin.36','LR_Se_6_10_bin.83')

linkage_top_sp <- linkage[linkage$bin %in% top_15,]



EnvA <- 8
EnvB <- 10

window_options <- c(10,20,30)

for(ll in 1:length(window_options)){
  
linkage_window_size <- window_options[ll]
window_step <- linkage_window_size

old_window <- window_options[ll-1]


## remove smaller distances 
linkage_top_sp <- linkage_top_sp[linkage_top_sp$distance > old_window,]

  
## subset data by approx window size
linkage_top_sp <- as.data.table(linkage_top_sp[linkage_top_sp$distance <linkage_window_size*1.1,])


  
linkage_top_sp[, position_A := as.numeric(position_A)]
linkage_top_sp[, position_B := as.numeric(position_B)]



for(i in 1:length(unique(linkage_top_sp$bin))){

  species_linkage <- linkage_top_sp[bin == unique(linkage_top_sp$bin)[i]]
  
  sp_scaffolds <- unique(species_linkage$Scaffold)
  
  for(j in 1:length(sp_scaffolds)){
    
    scaffold_linkage <- species_linkage[species_linkage$Scaffold == sp_scaffolds[j]]
    
    scaff_length <- ref_index[ref_index$Scaffold==sp_scaffolds[j],"Length"]
    if(length(scaff_length)==0){stop("scaff length")}
    
    # scaffold_linkage_env1 <- scaffold_linkage[Env==EnvA]
    # scaffold_linkage_env2 <- scaffold_linkage[Env==EnvB]

    ## make windows
    windows <- data.table(
      Start = seq(1, scaff_length - linkage_window_size, by = window_step),
      End   = seq(1, scaff_length - linkage_window_size, by = window_step) + linkage_window_size - 1
    )
    windows[, Window := Start]
  
    ## get rid of windows outside of the range of data
    min_pos <- min(c(scaffold_linkage$position_A, scaffold_linkage$position_B))
    max_pos <- max(c(scaffold_linkage$position_A, scaffold_linkage$position_B))
    windows <- windows[Start >= min_pos & End <= max_pos]
    
    ## here so it gets the right linkage df
    mean.linkage.function <- function(start, end, env){

  sub <- scaffold_linkage[
    Env == env & position_A >= start & position_B < end
  ]

  if(nrow(sub) == 0){ ## add empty dataframe if there are no comparisons at all on the scaffold
    return(data.table(
      r2.mean = NA_real_,
      d_prime.mean = NA_real_,
      r2_normalized.mean = NA_real_,
      d_prime_normalized.mean = NA_real_,
      num.compare = 0L,
      distance.mean = NA_real_,
      Env = env,
      Start = start,
      End = end,
      Window = windows[Start==start & End==end, Window]
    ))
  }

  data.table(
    r2.mean = mean(sub$r2, na.rm=TRUE),
    d_prime.mean = mean(sub$d_prime, na.rm=TRUE),
    r2_normalized.mean = mean(sub$r2_normalized, na.rm=TRUE),
    d_prime_normalized.mean = mean(sub$d_prime_normalized, na.rm=TRUE),
    num.compare = nrow(sub),
    distance.mean = mean(sub$distance, na.rm=TRUE),
    Env = env,
    Start = start,
    End = end,
    Window = windows[Start==start & End==end, Window]
  )
}
    
    ## calc stats
    linkage_results <- rbindlist(
      lapply(1:nrow(windows), function(i){
        rbind(
          mean.linkage.function(windows$Start[i], windows$End[i], EnvA),
          mean.linkage.function(windows$Start[i], windows$End[i], EnvB)
        )
      }),
      fill=TRUE
    )
    
    linkage_results$Scaffold <- sp_scaffolds[j]
    
    if(j==1){ linkage_results2 <- linkage_results } else { linkage_results2 <- rbind(linkage_results2,linkage_results) }
  }
  
  linkage_results2$bin <- unique(linkage_top_sp$bin)[i]

  if(i==1){ all_linkage_results <- linkage_results2 } else { all_linkage_results <- rbind(all_linkage_results,linkage_results2) }
  
}

  all_linkage_results$bin <- window_options[ll]

  if(ll==1){ all_linkage_results2 <- all_linkage_results } else { all_linkage_results2 <- rbind(all_linkage_results2,all_linkage_results) }


  
  write.csv(all_linkage_results2, paste0(unique(linkage_top_sp$bin)[i],"_LINKAGE_window",linkage_window_size,".csv"), row.names=F)
  
}
