INPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/06_Assembly"
OUTPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/07_BAM/01_Index"

setwd(INPUT_DIR)

DATASET <- "deer"

Read_list <- gsub(paste0("_",DATASET,".asm"),"",list.files(pattern = paste0("_",DATASET,".asm")))


setwd(OUTPUT_DIR)

for(i in 1:length(Read_list)){ 
  
  reads1 <- Read_list[i]
  
  sh_name <- paste0("Index_",reads1,".sh")

  ## bowtie2 code block to make indices for filtered assembly
  code_block <- paste0("bowtie2-build ",INPUT_DIR,"/",reads1,"_",DATASET,".asm/scaffolds_filtered.fasta ",INPUT_DIR,"/",reads1,"_",DATASET,".asm/scaffolds_filtered")
  
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=4000M", sh_name, append = TRUE) ## adjust MEM, time, cpus etc
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=00:15:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE) ## adjust email for job finish/fail etc
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load SAMtools/1.13-GCC-10.3.0", sh_name, append = TRUE)
  write ("module load Bowtie2/2.4.4-GCC-10.3.0", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  
}
