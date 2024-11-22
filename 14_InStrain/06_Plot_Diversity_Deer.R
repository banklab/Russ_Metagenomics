
library(ggplot2)
library(RColorBrewer)
library(ggpubr)



setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS/DEER/14_InStrain")
diversity_df0 <- read.csv("DIVERSITY_Deer.csv", header=T, stringsAsFactors = F)

diversity_df <- diversity_df0[!is.na(diversity_df0$polymorphic),]

diversity_df$Deer.Env <- paste0(diversity_df$Deer,"_",diversity_df$Env)

diversity_df$SNPs <- diversity_df$polymorphic * diversity_df$genome.length

max_genome_pi <- max(tapply(diversity_df$genome.pi,diversity_df$Deer.Env,mean))
max_per_locus_pi <- max(tapply(diversity_df$pi.mean,diversity_df$Deer.Env,mean))
max_polymorphic <- max(tapply(diversity_df$polymorphic,diversity_df$Deer.Env,mean))


# choose_domain <- c("All", "Bacteria", "Archaea")
choose_abundance <- seq(0,0.75, by=0.25)


pdf("Diversity_test.pdf", width = 14, height = 8.5)
for(j in 1:length(choose_abundance)){
    
  Abundance_quantile <- choose_abundance[j]
  
  Abundance_Threshold <- quantile(diversity_df$abundance, Abundance_quantile)


  sub_diversity_df2 <- diversity_df[diversity_df$abundance>=Abundance_Threshold, ]
  
  
  
  metric_df <- data.frame(tapply(sub_diversity_df2$genome.pi, sub_diversity_df2$Deer.Env, mean))
  colnames(metric_df) <- "genome.pi"
  metric_df$ID <- rownames(metric_df)
  metric_df$Deer <- as.numeric(gsub("_.*","",metric_df$ID))
  metric_df$Env <- as.numeric(gsub(".*_","",metric_df$ID))
  metric_df$Env <- factor(metric_df$Env, levels=1:10)
  
  metric_df$pi.mean <- tapply(sub_diversity_df2$pi.mean, sub_diversity_df2$Deer.Env, mean)
  
  metric_df$polymorphic <- tapply(sub_diversity_df2$polymorphic, sub_diversity_df2$Deer.Env, mean)
  
  metric_df$snps <- tapply(sub_diversity_df2$SNPs, sub_diversity_df2$Deer.Env, mean)
  
  if(length(setdiff(1:10, metric_df$Env))>0){

    empty <- data.frame(array(NA, dim = c(length(setdiff(1:10, metric_df$Env)), length(colnames(metric_df))), dimnames = list(c(),c(colnames(metric_df)))))

    empty$Env <- setdiff(1:10, metric_df$Env)

    metric_df <- rbind(metric_df,empty)
    metric_df$Env <- factor(metric_df$Env, levels=1:10)
    
  }
  
  ## genome wide pi
  a1 <- ggplot(metric_df, aes(Env, genome.pi, group=Env)) + geom_boxplot() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    xlab("Environment") +
    ylab("Pi-within\n(Genome-wide)") +
     theme(axis.title.x=element_text(size=0))
  
  if(Abundance_quantile==0){
    a1 <- a1 + ggtitle(paste0(Domain, " populations")) + 
      theme(plot.title = element_text(face="bold"))
  } else {
    a1 <- a1 + ggtitle(paste0(Domain, " populations >= to ", Abundance_quantile*100, "% abundance quantile (within a deer-env)")) + 
      theme(plot.title = element_text(face="bold"))
  }
 
  
  ## pi at polymorphic loci
  b1 <- ggplot(metric_df, aes(Env, pi.mean, group=Env)) + geom_boxplot() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    xlab("Environment") +
    ylab("Pi-within Per Locus\n(polymorphic loci only)") +
    theme(axis.title.x=element_text(size=0))
  
  ## genome wide pi
  c1 <- ggplot(metric_df, aes(Env, polymorphic, group=Env)) + geom_boxplot() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    xlab("Environment\n(metrics are a mean of all populations in a given deer-env community)") +
    ylab("Proportion of Polymorphic sites")

  ## number of SNPs
  d1 <- ggplot(metric_df, aes(Env, snps, group=Env)) + geom_boxplot() +
    theme(panel.background = element_rect(fill = "white")) +
    theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
    xlab("Environment\n(metrics are a mean of all populations in a given deer-env community)") +
    ylab("Number of SNPs")
  

  full_plot1 <- ggarrange(a1,b1,c1,d1, nrow = 2, ncol = 2, align = "hv")

  print(full_plot1)

}
dev.off()




setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS/DEER/15_Salmon")
ecol <- read.csv("Ecology_and_Mapping_data.csv", header=T, stringsAsFactors = F)

ecol2 <- data.frame(tapply(diversity_df$genome.pi, diversity_df$Deer.Env, mean))
colnames(ecol2) <- "genome.pi"
ecol2$Sample <- row.names(ecol2)
ecol2$mean.pi <- tapply(diversity_df$pi.mean, diversity_df$Deer.Env, mean)
ecol2$polymorphic <- tapply(diversity_df$polymorphic, diversity_df$Deer.Env, mean)


ecol3 <- merge(ecol, ecol2)

rich_cols <- brewer.pal(11, "RdYlBu")[-6]

p1 <- ggplot(ecol3, aes(Richness0.01, genome.pi, col=factor(Env))) + geom_point() +
        theme(panel.background = element_rect(fill = "white")) +
        theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
        geom_smooth(method='lm', formula= y~x, se=F) +
        xlab("Species Richness (>= 0.01% relative abundance)") +
        ylab("Pi-within (Genome-wide)") +
        ggtitle(" ") +
        scale_color_manual(name="Environment", values=rich_cols) +
        # ylim(3.5e7,11.5e7) +
        xlim(120,440)
      
p2 <- ggplot(ecol3, aes(Richness0.01, genome.pi)) + geom_point() +
        theme(panel.background = element_rect(fill = "white")) +
        theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
        geom_smooth(method='lm', formula= y~x, se=F) +
        xlab("Species Richness (>= 0.01% relative abundance)") +
        ylab("Pi-within (Genome-wide)") +
        ggtitle(" ") +
        scale_color_manual(name="Environment", values=rich_cols) +
        # ylim(3.5e7,11.5e7) +
        xlim(120,440)
      
p3 <- ggplot(ecol3, aes(Richness0.01, mean.pi, col=factor(Env))) + geom_point() +
  theme(panel.background = element_rect(fill = "white")) +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  geom_smooth(method='lm', formula= y~x, se=F) +
  xlab("Species Richness (>= 0.01% relative abundance)") +
  ylab("Pi-within per Locus\n(polymorphic loci only)") +
  ggtitle(" ") +
  scale_color_manual(name="Environment", values=rich_cols) +
  # ylim(3.5e7,11.5e7) +
  xlim(120,440)

p4 <- ggplot(ecol3, aes(Richness0.01, mean.pi)) + geom_point() +
  theme(panel.background = element_rect(fill = "white")) +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  geom_smooth(method='lm', formula= y~x, se=F) +
  xlab("Species Richness (>= 0.01% relative abundance)") +
  ylab("Pi-within per Locus\n(polymorphic loci only)") +
  ggtitle(" ") +
  scale_color_manual(name="Environment", values=rich_cols) +
  # ylim(3.5e7,11.5e7) +
  xlim(120,440)

p5 <- ggplot(ecol3, aes(Richness0.01, polymorphic, col=factor(Env))) + geom_point() +
  theme(panel.background = element_rect(fill = "white")) +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  geom_smooth(method='lm', formula= y~x, se=F) +
  xlab("Species Richness (>= 0.01% relative abundance)") +
  ylab("Proportion Polymorphic Loci") +
  ggtitle(" ") +
  scale_color_manual(name="Environment", values=rich_cols) +
  # ylim(3.5e7,11.5e7) +
  xlim(120,440)

p6 <- ggplot(ecol3, aes(Richness0.01, polymorphic)) + geom_point() +
  theme(panel.background = element_rect(fill = "white")) +
  theme(panel.border = element_rect(colour = "black", fill=NA, size=0.5)) +
  geom_smooth(method='lm', formula= y~x, se=F) +
  xlab("Species Richness (>= 0.01% relative abundance)") +
  ylab("Proportion Polymorphic Loci") +
  ggtitle(" ") +
  scale_color_manual(name="Environment", values=rich_cols) +
  # ylim(3.5e7,11.5e7) +
  xlim(120,440)


setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS/DEER/14_InStrain")
pdf("Diversity_by_Community_Richness.pdf", width = 14, height = 8.5)
ggarrange(p1,p2, nrow = 2, ncol = 1)
ggarrange(p3,p4, nrow = 2, ncol = 1)
ggarrange(p5,p6, nrow = 2, ncol = 1)
dev.off()

