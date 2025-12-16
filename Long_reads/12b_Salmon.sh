
INDIR="/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/03_FastUniq"
OUTDIR="/storage/scratch/users/rj23k073/04_Deer/IBU/salmon"
REF_DIR="/storage/scratch/users/rj23k073/04_Deer/IBU/salmon/DEER_v2_salmon_index"

DATASET="LR"


setwd(INDIR)

Read_list <- list.files(pattern="R1.dedup.fastq.gz$")


setwd(OUTDIR)


for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  reads2 <- gsub(".R1",".R2",reads1)
  
  sub_reads <- gsub("\\.R1.*","",reads1)
  
  sh_name <- paste0(sub_reads,"_LR_Salmon.sh")
  
  code_block <- paste0("salmon quant -i ",REF_DIR," --libType IU -1 ",INDIR,"/",reads1," -2 ",INDIR,"/",reads2," -o ",OUTDIR,"/",DATASET,"_",sub_reads,".quant --meta -p 1")
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=80000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=03:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write ("echo 'Finished Salmon'", sh_name, append = TRUE)
  
}
