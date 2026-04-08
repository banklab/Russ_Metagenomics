conda activate mosdepth


#!/bin/bash
#SBATCH --mem=20000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=24:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8


ALIGN_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/02_Alignment


for bam in "$ALIGN_DIR"/*bam
do

filename=$(basename "$bam")
file2="${filename%%.*}"
echo $file2

mosdepth $file2 $bam

done



####

# FORMAT

library(data.table)
setwd("/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/DREP/08_mosdepth/BED")
cov_files <- list.files(pattern="_LR.per-base.bed")

for(i in 1:length(cov_files)){

cov_df <- fread(cov_files[i],stringsAsFactors=F)

colnames(cov_df) <- c("Scaffold","start","end","coverage")

cov_df$Sample <- gsub("_LR.*","",cov_files[i])
cov_df$Deer <- as.numeric(gsub("_.*","",cov_files[i]))
cov_df$Env <- as.numeric(gsub(".*_","",cov_df$Sample[1]))

cov_df$bin <- gsub(".*asm_","",cov_df$Scaffold)

cov_df$Method <- "SR"
  
 if(i==1){ cov_df2 <- cov_df } else { cov_df2 <- rbind(cov_df2,cov_df) }

}

sp_list <- unique(cov_df2$bin)

for(ii in 1:length(sp_list)){
sp_cov <- cov_df2[cov_df2$bin==sp_list[ii],]
write.csv(sp_cov, paste0(sp_list[ii],"_cover.csv"), row.names=F)
}
