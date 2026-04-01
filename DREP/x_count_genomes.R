
drep_results <- array(NA, dim = c(8,5), dimnames = list(c(),c("drep","total.genomes","long.read","hybrid","short.read")))


drep_list <- list.files(pattern="drep_LR_bins_and_SR_bins")

for(i in 1:length(drep_list)){
  
  setwd(paste0("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/08_dRep/",drep_list[i],"/dereplicated_genomes"))
  
  if(drep_list[i]=="05_drep_LR_bins_and_SR_bins"){ drep_val <- 95 } else {
    drep_val <- as.numeric(gsub("05_|_drep.*","",drep_list[i]))
  }
  
  if(drep_val==925){drep_val<-92.5}
  
  drep_results[i,1] <- drep_val
  
  genomes <- list.files(pattern="fa")
  
  remove_sr <- genomes[!grepl("deer",genomes)]
  long_reads <- remove_sr[!grepl("hybrid",remove_sr)]
  hybrids <- remove_sr[grepl("hybrid",remove_sr)]
  
  drep_results[i,2] <- length(genomes)
  drep_results[i,3] <- length(long_reads)
  drep_results[i,4] <- length(hybrids)
  drep_results[i,5] <- length(genomes[grepl("deer",genomes)])

  if( length(genomes) != sum(drep_results[i,c(3:5)]) ){stop("genome sums")}
  
  
}

drep_results1 <- drep_results[order(drep_results[,1]),]

write.csv(drep_results1, "drep_results.csv", row.names = F)


setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/Long_Reads/DREP_Project")
drep <- read.csv(list.files(),header=T, stringsAsFactors = F)


drep$good <- rowSums(drep[,c("long.read","hybrid")])
drep$val <- drep$good
drep$metric <- "good genomes"


drep1 <- drep
drep1$val <- drep1$total.genomes
drep1$metric <- "total genomes"


drep2 <- rbind(drep,drep1)

ggplot(drep2, aes(x=drep, y=val)) + geom_point() + geom_line(lty=3) +
  theme_classic() +
  facet_wrap(~factor(metric), scales="free", ncol=1) +
  geom_vline(xintercept = 95, col="red",lty=3)



ggplot(drep2[drep2$drep %in% c(80,90,95,98,99),], aes(x=drep, y=val)) + geom_point() + geom_line(lty=3) +
  theme_classic() +
  facet_wrap(~factor(metric), scales="free", ncol=1) +
  geom_vline(xintercept = 95, col="red",lty=3)

