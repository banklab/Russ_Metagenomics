
sm.function <- function(site.df){
  
  envA.sums <- colSums(site.df[get(choose_env) == EnvA, .(A,C,G,T)])
  
  envB.sums <- colSums(site.df[get(choose_env) == EnvB, .(A,C,G,T)])
  
  deltas <- envB.sums - envA.sums
  
  ## focal allele = allele with the largest change (counts) across all populations
  focal.allele <- names(deltas)[which.max(abs(deltas))]
  
  site.df[, FOCAL := get(focal.allele) / (A+C+G+T)]
  
  ## weight by depth
  pA <- sum(site.df[get(choose_env)==EnvA, FOCAL * DP]) / sum(site.df[get(choose_env)==EnvA, DP])
  pB <- sum(site.df[get(choose_env)==EnvB, FOCAL * DP]) / sum(site.df[get(choose_env)==EnvB, DP])
  
  ## no longer switching which patch is focal (because now I have a SM for biofilm and an SM for water)
  ## patch 1 = cecum
  p1 <- pA
  p2 <- pB
  
  
  ## p1 has higher allele freq
  # if(pA >= pB){
  #   p1 <- pA
  #   p2 <- pB
  #   patch1 <- EnvA
  #   patch2 <- EnvB
  # } else {
  #   p1 <- pB
  #   p2 <- pA
  #   patch1 <- EnvB
  #   patch2 <- EnvA
  # } 
  
  
  q1 <- 1 - p1
  q2 <- 1 - p2
  
  ## s / m
  # SM1 <- (p1 - p2) / (p1 * q1)
  # SM2 <- (p1 - p2) / (p2 * q2)
  
  ## m /s
  SM1 <- (p1 * q1) / (p1 - p2)
  SM2 <- (p2 * q2) / (p1 - p2)
  
  
  
  ## weight var by depth
  ## add fix for switching which is p1/p2
  var1 <- sum(site.df[get(choose_env)==EnvA, FOCAL*(1-FOCAL)*DP]) / (sum(site.df[get(choose_env)==EnvA, DP])^2)
  var2 <- sum(site.df[get(choose_env)==EnvB, FOCAL*(1-FOCAL)*DP]) / (sum(site.df[get(choose_env)==EnvB, DP])^2)
  
  
  var.term <- (var1 + var2)
  
  
  # SM.scaled <- SM / sqrt(var.term)
  
  
  data.frame(
    ID = site.df$ID[1],
    num.alleles = sum(colSums(site.df[, .(A,C,G,T)])>0),
    SM1 = SM1, ## currently - this is biofilm
    SM2 = SM2, ## currently - this is water
    # SM.scaled = SM.scaled,
    var = var.term,
    EnvA.samples = sum(site.df[[choose_env]] == EnvA),
    EnvA.depth =  sum(site.df[get(choose_env)==EnvA,DP]),
    EnvB.samples = sum(site.df[[choose_env]] == EnvB),
    EnvB.depth =  sum(site.df[get(choose_env)==EnvB,DP]),
    focal.allele.count = sum(site.df[[focal.allele]]),
    EnvA.focal = p1,
    EnvB.focal = p2
  )
  
}



library(data.table)

EnvA <- 8
EnvB <- 10

choose_env <- "Env"


cmh_species <- c('Hy_Me_2_8_bin.181','Hy_Me_2_8_bin.89','Hy_Me_4_8_bin.143','Hy_Se_2_10_bin.105','Hy_Se_2_8_bin.23','Hy_Se_2_8_bin.24','Hy_Se_4_8_bin.39','Hy_Se_6_8_bin.0','Hy_Se_6_8_bin.55','Hy_Se_6_9_bin.30','LR_Me_4_8_bin.270','LR_Me_6_9_bin.102_sub','LR_Me_6_9_bin.166','LR_Se_2_10_bin.36','LR_Se_6_10_bin.83')


for(s in 1:length(cmh_species)){
  
  SPECIES1 <- cmh_species[s]
  
  cat("Species:",SPECIES1,"\n")
  
  
  setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain/Filtered_Sites_4")
  snp_df <- fread(list.files(pattern=paste0(SPECIES1,"_Env")), header=T, stringsAsFactors = F)
  
  site.split <- split(as.data.table(snp_df), by = "ID")



cat("Starting SM estimation\n")
cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")
SM_list <- lapply(site.split, sm.function)
cat("Finish SM estimation\n")
cat(format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n")

SM_results <- rbindlist(SM_list)


SM_results$num.samples <- rowSums(SM_results[,c("EnvA.samples","EnvB.samples")])
SM_results$total.depth <- rowSums(SM_results[,c("EnvA.depth","EnvB.depth")])
SM_results$alt.allele.count <- SM_results$total.depth - SM_results$focal.allele.count
SM_results$Alt.freq <- SM_results$alt.allele.count / SM_results$total.depth
SM_results$Delta <- SM_results$EnvB.focal - SM_results$EnvA.focal

SM_results$Scaffold <- gsub("_.*","",SM_results$ID)
SM_results$POS <- as.numeric(gsub(".*_","",SM_results$ID))


## format for plot
SM_results$Scaffold_factor <- factor(SM_results$Scaffold)

# cumulative position for each scaffold
chr_offsets <- cumsum(c(0, tapply(SM_results$POS, SM_results$Scaffold_factor, max, na.rm = TRUE))[-length(levels(SM_results$Scaffold_factor))])

SM_results$cum_pos <- SM_results$POS

for (i in seq_along(levels(SM_results$Scaffold_factor))) {
  SM_results$cum_pos[SM_results$Scaffold_factor == levels(SM_results$Scaffold_factor)[i]] <- SM_results$cum_pos[SM_results$Scaffold_factor == levels(SM_results$Scaffold_factor)[i]] + chr_offsets[i]
}




filename <- paste0(SPECIES1,"_SM_",paste0(c(EnvA,EnvB), collapse="x"),".csv")
setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Diversity/SM")
write.csv(SM_results, filename, row.names = F)

}


###

