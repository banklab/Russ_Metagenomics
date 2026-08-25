
#cd /data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/dRep

df <- read.csv("Methods_LR28vSR28_Clusters.csv", header=T, stringsAsFactors=F)

df1 <- df[df$LR28==1 & df$SR28==1,]

nrow(df1)

df1$LR_genes <- paste0(gsub("LR28_","",df1$LR28.genome),".genes.faa")
df1$SR_genes <- paste0(gsub("SR28_","",df1$SR28.genome),".genes.faa")

df1$LR_DB <- gsub("LR28_|\\.fa","",df1$LR28.genome)
df1$SR_DB <- gsub("SR28_|\\.fa","",df1$SR28.genome)



setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/METHODS/Blast")

sh_name <- paste0("diamond_search.sh")

write ("#!/bin/bash", sh_name)
write ("#SBATCH --mem=1G", sh_name, append = TRUE) 
write ("#SBATCH --nodes=1", sh_name, append = TRUE)
write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
write ("#SBATCH --time=3:00:00", sh_name, append = TRUE)
write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
write ("#SBATCH --partition=pibu_el8", sh_name, append = TRUE)
write ("module load DIAMOND/2.1.8-GCC-10.3.0", sh_name, append = TRUE)


for(i in 1:nrow(df1)){
  
  search1 <- paste0("diamond blastp --query LR/",df1[i,"LR_genes"]," --db SR/",df1[i,"SR_DB"]," --out LR_",df1[i,"LR_DB"],"_against_SR_",df1[i,"SR_DB"],"_DB.out --outfmt 6 qseqid sseqid pident length qlen slen qstart qend sstart send evalue bitscore --evalue 1e-5 --max-target-seqs 10")
  
  search2 <- paste0("diamond blastp --query SR/",df1[i,"SR_genes"]," --db LR/",df1[i,"LR_DB"]," --out SR_",df1[i,"SR_DB"],"_against_LR_",df1[i,"LR_DB"],"_DB.out --outfmt 6 qseqid sseqid pident length qlen slen qstart qend sstart send evalue bitscore --evalue 1e-5 --max-target-seqs 10")
  
  write (search1, sh_name, append = TRUE)
  write (search2, sh_name, append = TRUE)
  
}


