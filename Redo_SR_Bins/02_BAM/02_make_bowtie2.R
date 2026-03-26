
READ_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/04_FastUniq"
ASM_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/01_Assembly"
OUTPUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/02_BAM"

setwd(ASM_DIR)

Read_list <- list.files(pattern="_deer.asm")

setwd(OUTPUT_DIR)


for(i in 1:length(Read_list)){
  
  reads1 <- gsub("_deer.asm","",Read_list[i])
  
  sh_name <- paste0(reads1,"_bowtie2.sh")

  code_block <- paste0("bowtie2 -p 4 -x ",ASM_DIR,"/",Read_list[i],"/",reads1,"_scaffolds_filtered_NoNorm -1 ",READ_DIR,"/",reads1,".R1.dedup.fastq.gz -2 ",READ_DIR,"/",reads1,".R2.dedup.fastq.gz -S ",OUTPUT_DIR,"/",reads1,".sam")

  code_block2 <- paste0("samtools view -Sb ",OUTPUT_DIR,"/",reads1,".sam > ",OUTPUT_DIR,"/",reads1,".bam")

  code_block3 <- paste0("rm ",OUTPUT_DIR,"/",reads1,".sam")

  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=4000M", sh_name, append = TRUE) ## adjust MEM, time, cpus etc
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=4", sh_name, append = TRUE)
  write ("#SBATCH --time=12:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE) ## adjust email for job finish/fail etc
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("#SBATCH --partition=pibu_el8", sh_name, append = TRUE)
  write ("module load SAMtools/1.13-GCC-10.3.0", sh_name, append = TRUE) ## load samtools/bowtie2 according to server specifications
  write ("module load Bowtie2/2.4.4-GCC-10.3.0", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write (code_block2, sh_name, append = TRUE)
  write (code_block3, sh_name, append = TRUE)

}
