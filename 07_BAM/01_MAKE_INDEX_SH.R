INPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/06_Assembly"
OUTPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/07_BAM/01_Index"

setwd(INPUT_DIR)

Read_list <- gsub("_deer.asm","",list.files(pattern = "_deer.asm"))

DATASET <- "deer"

setwd(OUTPUT_DIR)

for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sh_name <- paste0("Index_",reads1,".sh")
  
  code_block <- paste0("bowtie2-build ",INPUT_DIR,"/",reads1,"_",DATASET,".asm/scaffolds_filtered.fasta ",INPUT_DIR,"/",reads1,"_",DATASET,".asm/scaffolds_filtered")
  
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=4000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=00:15:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load vital-it/7", sh_name, append = TRUE)
  write ("module load UHTS/Aligner/bowtie2", sh_name, append = TRUE)
  write ("module load UHTS/Analysis/samtools/1.10", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  
}
