
library(rlang)
library(lme4)
library(lmerTest)


setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/Models")
snp_long_scale <-  read.csv("snp_long.csv", header=T, stringsAsFactors = F)


snp_long_scale$CoverM.abundance_z <- scale(snp_long_scale$CoverM.abundance)
snp_long_scale$genome.size_z <- scale(log10(snp_long_scale$genome.size))
snp_long_scale$completeness_z <- scale(snp_long_scale$completeness)
snp_long_scale$contamination_z <- scale(snp_long_scale$contamination)
snp_long_scale$Coding_Density_z <- scale(snp_long_scale$Coding_Density)
snp_long_scale$Average_Gene_Length_z <- scale(snp_long_scale$Average_Gene_Length)
snp_long_scale$GC_Content_z <- scale(snp_long_scale$GC_Content)
snp_long_scale$N50_z <- scale(log10(snp_long_scale$N50))
snp_long_scale$auN_z <- scale(log10(snp_long_scale$auN))



## add mapping

setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/Mapping")
mappingDF <- read.csv("Mapping.rate.comparison.csv", header=T, stringsAsFactors = F)

summary(mappingDF$Mapping.rate)

mappingDF$Mapping.rate_z <- scale(mappingDF$Mapping.rate)

mappingDF_LR <- mappingDF[mappingDF$Method=="LR28",]
mappingDF_SR <- mappingDF[mappingDF$Method=="SR28",]

snp_long_scale_LR <- snp_long_scale[snp_long_scale$Method=="LR28",]
snp_long_scale_SR <- snp_long_scale[snp_long_scale$Method=="SR28",]

snp_long_scale_LR2 <- merge(snp_long_scale_LR, mappingDF_LR[,c("Sample","Mapping.rate_z")])
snp_long_scale_SR2 <- merge(snp_long_scale_SR, mappingDF_SR[,c("Sample","Mapping.rate_z")])

snp_long_scale <- rbind(snp_long_scale_LR2,snp_long_scale_SR2)

##

snp_long_scale$Method_f <- factor(snp_long_scale$Method)
snp_long_scale$Deer_f <- factor(snp_long_scale$Deer)
snp_long_scale$cluster_f <- factor(snp_long_scale$cluster)


snp_long_scale$Gut.region <- NA

snp_long_scale[snp_long_scale$Env %in% 1:4, "Gut.region"] <- "Foregut"
snp_long_scale[snp_long_scale$Env %in% 5:6, "Gut.region"] <- "Midgut"
snp_long_scale[snp_long_scale$Env %in% 8:10, "Gut.region"] <- "Hindgut"
snp_long_scale$Gut.region <- factor(snp_long_scale$Gut.region)


##


snp_mod_null <- lmer(snp.count ~ (1|cluster_f) + (1|Deer_f), data = snp_long_scale, REML=FALSE)
snp_mod_methods <- lmer(snp.count ~  Method_f + (1|cluster_f) + (1|Deer_f), data = snp_long_scale, REML=FALSE)
AIC(snp_mod_null,snp_mod_methods)


AIC_df <- data.frame(array(NA, dim = c(2,5), dimnames = list(c(),c("model","df","AIC","BIC","Variables"))))
AIC_df[,1] <- c("null","methods only")
AIC_df[,2:3] <- AIC(snp_mod_null,snp_mod_methods)
AIC_df[,4] <- BIC(snp_mod_null,snp_mod_methods)$BIC

explanatory_vars <- c('Method_f','Gut.region', 'CoverM.abundance_z','genome.size_z','completeness_z','contamination_z','Coding_Density_z','Average_Gene_Length_z','GC_Content_z','N50_z','Mapping.rate_z')


minimum_vars <- 1
maximum_vars <- length(explanatory_vars)

mod_test_df <- data.frame(array(NA, dim = c(1,5), dimnames = list(c(),c("model","df","AIC","BIC","Variables"))))

Sys.time()
for(j in minimum_vars:maximum_vars){
  
  model_combinations <- combn(explanatory_vars, j)
  
  for(i in 1:ncol(model_combinations)){
    
    snp_mod_test <- update(snp_mod_null, as.formula(paste(". ~ . +", paste(model_combinations[,i], collapse = " + "))))
    
    mod1 <- lmer(snp_mod_test, data = snp_long_scale, REML=FALSE)
    
    mod_test_df[,3] <- AIC(mod1)
    mod_test_df[,4] <- BIC(mod1)
    mod_test_df[,5] <- length(unique(model_combinations[,i]))
    
    mod_test_df[,1] <- paste0(formula(mod1)[3])
    
    AIC_df <- rbind(AIC_df, mod_test_df)
    
  }
  
  cat("done this many vars:",j,"\n")
  
}
Sys.time() ## 12 min (1-11 vars)

AIC_df2 <- AIC_df

AIC_df2$delta.AIC <- AIC_df2$AIC - min(AIC_df2$AIC)
AIC_df2$delta.BIC <- AIC_df2$BIC - min(AIC_df2$BIC)

AIC_df2[AIC_df2$delta.AIC<2,]
AIC_df2[AIC_df2$delta.BIC<2,]

setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/Models")
write.csv(AIC_df2,"", row.names = F)


######





top_model <- AIC_df2[AIC_df2$delta.AIC<2,][2,]

best_model_terms <- unlist(strsplit(gsub("^.*Method_f \\+ ","",top_model$model), " \\+ "))

interactions_here <- paste0("Method_f:",best_model_terms)

best_model <-  lmer(snp.count ~ (1 | cluster_f) + (1 | Deer_f) + Method_f + Gut.region + CoverM.abundance_z + genome.size_z + completeness_z + contamination_z + Coding_Density_z + Average_Gene_Length_z + GC_Content_z + N50_z + Mapping.rate_z, data = snp_long_scale, REML=FALSE)


##

minimum_inters <- 1
maximum_inters <- length(interactions_here)

AIC_inters <- data.frame(array(NA, dim = c(1,5), dimnames = list(c(),c("model","df","AIC","BIC","Variables"))))
AIC_inters[,1] <- c("no interactions")
AIC_inters[,3] <- AIC(best_model)
AIC_inters[,4] <- BIC(best_model)

mod_test_df2 <- data.frame(array(NA, dim = c(1,5), dimnames = list(c(),c("model","df","AIC","BIC","Variables"))))

Sys.time()
for(j in minimum_inters:maximum_inters){
  
  inter_combinations <- combn(interactions_here, j)
  
  for(i in 1:ncol(inter_combinations)){
    
    snp_mod_test2 <- update(best_model, as.formula(paste(". ~ . +", paste(inter_combinations[,i], collapse = " + "))))
    
    mod2 <- lmer(snp_mod_test2, data = snp_long_scale, REML=FALSE)
    
    mod_test_df2[,3] <- AIC(mod2)
    mod_test_df2[,4] <- BIC(mod2)
    mod_test_df2[,5] <- length(unique(inter_combinations[,i])) + top_model$Variables
    
    mod_test_df2[,1] <- paste0(formula(mod2)[3])
    
    AIC_inters <- rbind(AIC_inters, mod_test_df2)
    
  }
  
  cat("done this many inters:",j,"\n")
  
}
Sys.time() ## 5-9 min


AIC_inters2 <- AIC_inters

AIC_inters2$delta.AIC <- AIC_inters2$AIC - min(AIC_inters2$AIC)
AIC_inters2$delta.BIC <- AIC_inters2$BIC - min(AIC_inters2$BIC)

setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/Models")
write.csv(AIC_inters2,"", row.names = F)

##

setwd("~/Dropbox/My Mac (Russs-MacBook-Air.local)/Desktop/BERN/RESULTS2/DEER/LR_verus_SR_final_battle/Models")
AIC_base <- read.csv("snp_models_no_interactions_jul18.csv", header=T, stringsAsFactors = F)
AIC_mod1 <- read.csv("snp_mod1_interactions_jul18.csv", header=T, stringsAsFactors = F)
AIC_mod2 <- read.csv("snp_mod2_interactions_jul18.csv", header=T, stringsAsFactors = F)

AIC_snps <- rbind(AIC_base, AIC_mod1, AIC_mod2)

AIC_snps$delta.AIC <- AIC_snps$AIC - min(AIC_snps$AIC)
AIC_snps$delta.BIC <- AIC_snps$BIC - min(AIC_snps$BIC)

AIC_snps[AIC_snps$delta.AIC<2,]
AIC_snps[AIC_snps$delta.BIC<2,]

AIC_snps[AIC_snps$delta.AIC<2 & AIC_snps$delta.BIC<2,]


snp.best.mod <- lmer(snp.count ~ (1 | cluster_f) + (1 | Deer_f) + Method_f + Gut.region + CoverM.abundance_z + genome.size_z + completeness_z + Coding_Density_z + Average_Gene_Length_z + GC_Content_z + N50_z + Mapping.rate_z + Method_f:Gut.region + Method_f:CoverM.abundance_z + Method_f:genome.size_z + Method_f:Average_Gene_Length_z + Method_f:GC_Content_z + Method_f:N50_z, data = snp_long_scale, REML=TRUE)
summary(snp.best.mod)

coding.best.mod <- lmer(coding.count ~ (1 | cluster_f) + (1 | Deer_f) + Method_f + Gut.region + CoverM.abundance_z + genome.size_z + completeness_z + Coding_Density_z + Average_Gene_Length_z + GC_Content_z + N50_z + Mapping.rate_z + Method_f:Gut.region + Method_f:CoverM.abundance_z + Method_f:genome.size_z + Method_f:Average_Gene_Length_z + Method_f:GC_Content_z + Method_f:N50_z, data = snp_long_scale, REML=TRUE)
summary(coding.best.mod)

integenic.best.mod <- lmer(intergenic.count ~ (1 | cluster_f) + (1 | Deer_f) + Method_f + Gut.region + CoverM.abundance_z + genome.size_z + completeness_z + Coding_Density_z + Average_Gene_Length_z + GC_Content_z + N50_z + Mapping.rate_z + Method_f:Gut.region + Method_f:CoverM.abundance_z + Method_f:genome.size_z + Method_f:Average_Gene_Length_z + Method_f:GC_Content_z + Method_f:N50_z, data = snp_long_scale, REML=TRUE)
summary(integenic.best.mod)

