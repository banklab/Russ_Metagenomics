
library(data.table)

setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal")
genes2 <- data.frame(fread("Deer_Genes_Format.csv", header=T, stringsAsFactors = F))

genes2$Type <- "Gene"

# summary(genes2$Size)

unq_species <- unique(genes2$bin)

new_genes2 <- genes2

minimum_intergenic_length <- 10

for(i in 1:length(unq_species)){
  
  choose_sp <- unq_species[i]
  
  sub_genes2 <- genes2[genes2$bin==choose_sp,]
  
  unq_scaff <- unique(sub_genes2$Scaffold)
  
  for(j in 1:length(unq_scaff)){
    
    choose_scaff <- unq_scaff[j]
    
    sub_genes22 <- sub_genes2[sub_genes2$Scaffold==choose_scaff,]
    
    num_genes2 <- dim(sub_genes22)[1]
    
    scaffold_length <- unique(sub_genes22$Scaffold.length)
    
    # only 1 gene and it takes up the entire scaffold
    if(num_genes2==1 & sub_genes22$Start[1]==1 & sub_genes22$End[1]==scaffold_length){next}
    
    
    intergenic_windows <- data.frame(array(NA, dim = c(num_genes2,11), dimnames = list(c(),colnames(sub_genes22))))
    
    intergenic_windows$bin <- choose_sp
    intergenic_windows$Scaffold <- choose_scaff
    intergenic_windows$Scaffold.length <-  unique(sub_genes22$Scaffold.length)
    intergenic_windows$Scaffold.coverage <-  unique(sub_genes22$Scaffold.coverage)
    
    intergenic_windows$Type <- "Intergenic"
    
    ## make intergenic window infront of each gene
    for(k in 1:num_genes2){
      
      choose_gene <- sub_genes22[k,]
      
      ## intergenic window start
      if(k==1){
        
        if( choose_gene$Start != 1 ){ intergenic_start <- 1 } else { next } 
        
      } else {
        
        intergenic_start <- sub_genes22[k-1,"End"] +  1
        
      }
      
      
      ## intergenic window end
      intergenic_end <- sub_genes22[k,"Start"] -  1
      
      
      
      intergenic_windows[k,"Start"] <- intergenic_start
      
      intergenic_windows[k,"End"] <- intergenic_end
      
    } ## genes2
    
    
    ## add final window after last gene (goes from last gene to scaffold end)
    if(sub_genes22[num_genes2,"End"] != scaffold_length){
      
      last_window <- intergenic_windows[1,]
      
      last_window$Start <- sub_genes22[num_genes2,"End"] + 1
      last_window$End <- scaffold_length
      
      intergenic_windows <- rbind(intergenic_windows, last_window)
    }
    
    intergenic_windows[,"Size"] <- intergenic_windows[,"End"] - intergenic_windows[,"Start"] + 1
    
    
    ## remove windows that are smaller than the minimum gene length
    
    final_windows <- intergenic_windows[!is.na(intergenic_windows$Size) & intergenic_windows$Size >= minimum_intergenic_length,]
    
    if(j==1){ combine_inter_windows <- final_windows } else {
      
      if(dim(final_windows)[1] > 0){ combine_inter_windows <- rbind(combine_inter_windows, final_windows) }
      
    }
    
    
  } ## scaffolds
  
  filename <- paste0(choose_sp,"_intergenic_windows.csv")
  
  setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal/Intergenic")
  write.csv(combine_inter_windows, filename, row.names = F)

  
  new_genes2 <- rbind(new_genes2, combine_inter_windows)
  
  if(i%%100==0){print(i)}
  
} ## species

new_genes2$ID <- paste0(new_genes2$bin,"_scaff",new_genes2$Scaffold,"_start",new_genes2$Start,"_end",new_genes2$End,"_type_",new_genes2$Type)

setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal")
write.csv(new_genes2, "deer_gene_and_intergenic_intermediate.csv", row.names = F)


intergenic_windows <- new_genes2[new_genes2$Type=="Intergenic",]
summary(intergenic_windows$Size)

## ecoli mean: 118 nt
## choose max to shift data distribution towards ecoli numbers
max_intergenic_length <- 200

extra_windows <- 0



split_these_windows <- intergenic_windows[intergenic_windows$Size > max_intergenic_length,]
old_windows <- intergenic_windows[intergenic_windows$Size <= max_intergenic_length,]


Sys.time()
for(i in 1:dim(split_these_windows)[1]){
  
  if(split_these_windows[i,"Size"] <= max_intergenic_length){
    
    if(i==1){ new_split_these_windows <- split_these_windows[i,] } else { new_split_these_windows <- rbind(new_split_these_windows,  split_these_windows[i,]) }
    next
  }
  
  inter_dat <- split_these_windows[i,]
  
  chop_into_this_many <- ceiling(inter_dat$Size / max_intergenic_length)
  
  
  ## final window is less than min intergenic size
  if( inter_dat$Size%%max_intergenic_length < minimum_intergenic_length ){ chop_into_this_many <- chop_into_this_many - 1 }
  if(chop_into_this_many==1){
    if(i==1){ new_split_these_windows <- split_these_windows[i,] } else { new_split_these_windows <- rbind(new_split_these_windows,  split_these_windows[i,]) }
    next}

  new_inter_dat <- data.frame(array(NA, dim = c(chop_into_this_many, 12), dimnames = list(c(),c(colnames(split_these_windows)))))
  
  new_inter_dat[,1:dim(new_inter_dat)[2]] <- inter_dat
  new_inter_dat$Start <- NA ## just want to make sure don't accidentally carry through old values etc
  new_inter_dat$End <- NA
  new_inter_dat$Size <- NA
  new_inter_dat$ID <- NA
  
  new_starts <- seq(inter_dat$Start, by=max_intergenic_length, length.out=chop_into_this_many)
  
  new_ends <- seq((new_starts[2]-1), by=max_intergenic_length, length.out=chop_into_this_many)
  
  final_end <- min(c(new_ends[chop_into_this_many],inter_dat$End))
  
  new_ends[chop_into_this_many] <- final_end
  
  new_inter_dat$Start <- new_starts
  
  new_inter_dat$End <- new_ends
  
  
  ## if deleted final intergenic window (because smaller than min value) add it to last real window
  if( inter_dat$Size%%max_intergenic_length < minimum_intergenic_length ){
    
    new_inter_dat[dim(new_inter_dat)[1],"End"] <- inter_dat$End
    
  }
  
  new_inter_dat$Size <- new_inter_dat$End - new_inter_dat$Start + 1
  
  new_inter_dat$ID <- paste0(new_inter_dat$bin,"_scaff",new_inter_dat$Scaffold,"_start",new_inter_dat$Start,"_end",new_inter_dat$End,"_type_",new_inter_dat$Type)
  
  
  if(i==1){ new_split_these_windows <- new_inter_dat } else { new_split_these_windows <- rbind(new_split_these_windows,  new_inter_dat) }
  
  
  extra_windows <- extra_windows + (dim(new_inter_dat)[1]-1)
  
}
Sys.time()



new_intergenic_windows <- rbind(old_windows, new_split_these_windows)


summary(new_intergenic_windows$Size)


cat("dim before:",dim(intergenic_windows)[1],"\n")
cat("dim after:",dim(new_intergenic_windows)[1],"\n")

cat("extra window counter:",extra_windows,"\n")

new_genes3 <- rbind(new_genes2[new_genes2$Type=="Gene",], new_intergenic_windows)

setwd("/storage/scratch/users/rj23k073/04_DEER/13_Prodigal")
write.csv(new_genes3, "deer_gene_and_intergenic_intermediate2.csv", row.names = F)


