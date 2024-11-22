
library(ggplot2)
library(RColorBrewer)
library(ggpubr)


setwd("/Users/russjasper/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS/RAS")
RAS_data <- read.csv("RAS_metadata.csv", header=T, stringsAsFactors = F)
RAS_data$Sample <- RAS_data$ID
colnames(RAS_data)[7] <- "farmed_species"

setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS/RAS/14_InStrain")
diversity_df0 <- read.csv("DIVERSITY_RAS.csv", header=T, stringsAsFactors = F)

diversity_df <- diversity_df0[!is.na(diversity_df0$polymorphic),]

diversity_df$SNPs <- diversity_df$polymorphic * diversity_df$genome.length


diversity_df <- merge(diversity_df, RAS_data[,c("Sample","farm","sample","disease_outbreak","farmed_species")], by="Sample")


choose_abundance <- seq(0,0.75, by=0.25)

Domain <- "All"

pdf("Diversity_RAS.pdf", width = 14, height = 8.5)
for(j in 1:length(choose_abundance)){
  
  Abundance_quantile <- choose_abundance[j]
  
  Abundance_Threshold <- quantile(diversity_df$abundance, Abundance_quantile)
  
  
  sub_diversity_df2 <- diversity_df[diversity_df$abundance>=Abundance_Threshold, ]
  
  
  
  metric_df <- data.frame(tapply(sub_diversity_df2$genome.pi, sub_diversity_df2$farm, mean))
  colnames(metric_df) <- "genome.pi"
  metric_df$Farm <- rownames(metric_df)

  metric_df$pi.mean <- tapply(sub_diversity_df2$pi.mean, sub_diversity_df2$farm, mean)
  
  metric_df$polymorphic <- tapply(sub_diversity_df2$polymorphic, sub_diversity_df2$farm, mean)
  
  metric_df$snps <- tapply(sub_diversity_df2$SNPs, sub_diversity_df2$farm, mean)

  
  ## genome wide pi
  a1 <- ggplot(sub_diversity_df2, aes(farm, genome.pi, col=farm)) + geom_violin() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    ylab("Pi-within\n(Genome-wide)") +
    theme(axis.title.x=element_text(size=0)) +
    scale_colour_manual(name="Farm",values = brewer.pal(7, "Dark2")) +
    theme(legend.position = "none")
  
  if(Abundance_quantile==0){
    a1 <- a1 + ggtitle(paste0(Domain, " populations")) + 
      theme(plot.title = element_text(face="bold"))
  } else {
    a1 <- a1 + ggtitle(paste0(Domain, " populations >= to ", Abundance_quantile*100, "% abundance quantile (within a deer-env)")) + 
      theme(plot.title = element_text(face="bold"))
  }
  
  
  ## pi at polymorphic loci
  b1 <- ggplot(sub_diversity_df2, aes(farm, pi.mean, col=farm)) + geom_violin() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    xlab("Environment") +
    ylab("Pi-within Per Locus\n(polymorphic loci only)") +
    theme(axis.title.x=element_text(size=0)) +
    scale_colour_manual(name="Farm",values = brewer.pal(7, "Dark2")) +
    theme(legend.position = "none")
  
  ## genome wide pi
  c1 <- ggplot(sub_diversity_df2, aes(farm, polymorphic, col=farm)) + geom_violin() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    xlab("Environment\n(metrics are a mean of all populations in a given deer-env community)") +
    ylab("Proportion of Polymorphic sites") +
    scale_colour_manual(name="Farm",values = brewer.pal(7, "Dark2")) +
    theme(legend.position = "none")
  
  ## number of SNPs
  d1 <- ggplot(sub_diversity_df2, aes(farm, SNPs, col=farm)) + geom_violin() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    xlab("Environment\n(metrics are a mean of all populations in a given deer-env community)") +
    ylab("Number of SNPs") +
    scale_colour_manual(name="Farm",values = brewer.pal(7, "Dark2")) +
    theme(legend.position = "none")
  
  
  full_plot1 <- ggarrange(a1,b1,c1,d1, nrow = 2, ncol = 2, align = "hv")
  
  print(full_plot1)
  
}
dev.off()



ras_variables <- c("farm","sample","disease_outbreak","farmed_species")

pdf("Diversity_RAS2.pdf", width = 14, height = 8.5)
for(j in 1:length(ras_variables)){
  
  sub_diversity_df2 <- diversity_df
  
  sub_diversity_df2$VAR <- sub_diversity_df2[,ras_variables[j]]
  
  
  metric_df <- data.frame(tapply(sub_diversity_df2$genome.pi, sub_diversity_df2$VAR, mean))
  colnames(metric_df) <- "genome.pi"
  metric_df$VAR <- rownames(metric_df)
  
  metric_df$pi.mean <- tapply(sub_diversity_df2$pi.mean, sub_diversity_df2$VAR, mean)
  
  metric_df$polymorphic <- tapply(sub_diversity_df2$polymorphic, sub_diversity_df2$VAR, mean)
  
  metric_df$SNPs <- tapply(sub_diversity_df2$SNPs, sub_diversity_df2$VAR, mean)
  
  
  ## genome wide pi
  a1 <- ggplot(sub_diversity_df2, aes(VAR, genome.pi)) + geom_violin() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    ylab("Pi-within\n(Genome-wide)") +
    theme(axis.title.x=element_text(size=0)) +
    theme(legend.position = "none")
  
  ## pi at polymorphic loci
  b1 <- ggplot(sub_diversity_df2, aes(VAR, pi.mean)) + geom_violin() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    ylab("Pi-within Per Locus\n(polymorphic loci only)") +
    theme(axis.title.x=element_text(size=0)) +
    theme(legend.position = "none")
  
  ## genome wide pi
  c1 <- ggplot(sub_diversity_df2, aes(VAR, polymorphic)) + geom_violin() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    xlab(ras_variables[j]) +
    ylab("Proportion of Polymorphic sites") +
    theme(legend.position = "none")
  
  ## number of SNPs
  d1 <- ggplot(sub_diversity_df2, aes(VAR, SNPs)) + geom_violin() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    xlab(ras_variables[j]) +
    ylab("Number of SNPs") +
    theme(legend.position = "none")
  
  
  full_plot1 <- ggarrange(a1,b1,c1,d1, nrow = 2, ncol = 2, align = "hv")
  
  print(full_plot1)
  
}
dev.off()

