
## choose input & output directories
INPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/04_FastUniq"
OUTPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/06_Assembly"

setwd(INPUT_DIR)

## make list of samples
sample_list <- gsub("\\.R1.dedup.fastq","",list.files(pattern = "R1.dedup.fastq"))

length(sample_list)

setwd(OUTPUT_DIR)
for(i in 1:length(sample_list)){
  
  samp2 <- sample_list[i]
  
  sh_name <- paste0(samp2,"_assembly.sh")

  ## code block for metaspades
  code_block <- paste0("metaspades.py --pe1-1 ",INPUT_DIR,"/",samp2,".R1.dedup.fastq --pe1-2 ",INPUT_DIR,"/",samp2,".R2.dedup.fastq --meta -o ",OUTPUT_DIR,"/",samp2,"_deer.asm -t 60 -m 120 -k 21,33,55,77")
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=124000M", sh_name, append = TRUE) ## adjust MEM, time, cpus etc
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=60", sh_name, append = TRUE)
  write ("#SBATCH --time=04:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE) ## adjust email for job finish/fail etc
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load SPAdes/3.15.3-GCC-10.3.0", sh_name, append = TRUE) ## load metaspades here according to server specifications
  write (code_block, sh_name, append = TRUE)
  
}
