
READ_DIR="/storage/scratch/users/rj23k073/04_DEER/04_FastUniq"
ASM_DIR="/storage/scratch/users/rj23k073/04_DEER/06_Assembly"
OUTPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/07_BAM"

DATASET="deer"


setwd(ASM_DIR)

Read_list <- gsub(paste0("_",DATASET,".asm"),"",list.files(pattern = paste0("_",DATASET,".asm")))

setwd(OUTPUT_DIR)


for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sh_name <- paste0(reads1,"_bowtie2.sh")
  
  code_block <- paste0("bowtie2 -p 20 -x ",ASM_DIR,"/",reads1,"_",DATASET,".asm/scaffolds_filtered -1 ",READ_DIR,"/",reads1,".R1.dedup.fastq -2 ",READ_DIR,"/",reads1,".R2.dedup.fastq -S ",OUTPUT_DIR,"/",reads1,".sam")
  
  code_block2 <- paste0("samtools view -Sb ",OUTPUT_DIR,"/",reads1,".sam > ",OUTPUT_DIR,"/",reads1,".bam")
  
  code_block3 <- paste0("rm ",OUTPUT_DIR,"/",reads1,".sam")

  code_block4 <- paste0("echo Finished ",reads1)
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=4000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=20", sh_name, append = TRUE)
  write ("#SBATCH --time=01:30:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load SAMtools/1.13-GCC-10.3.0", sh_name, append = TRUE)
  write ("module load Bowtie2/2.4.4-GCC-10.3.0", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write (code_block2, sh_name, append = TRUE)
  write (code_block3, sh_name, append = TRUE)
  write (code_block4, sh_name, append = TRUE)

}
