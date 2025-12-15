
READ_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/04_FastUniq"
OUTPUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/09_Alignment"

REF="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/REFERENCE/DEER_v2"

setwd(READ_DIR)

reads_env1 <- list.files(pattern="_8.R1")
reads_env2 <- list.files(pattern="_10.R1")

Read_list <- gsub("\\.R1.dedup.fastq.gz","",c(reads_env1,reads_env2))

setwd(OUTPUT_DIR)


for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sh_name <- paste0(reads1,"_bowtie_version2.sh")
  
  code_block <- paste0("bowtie2 -p 20 -x ",REF," -1 ",READ_DIR,"/",reads1,".R1.dedup.fastq.gz -2 ",READ_DIR,"/",reads1,".R2.dedup.fastq.gz -S ",OUTPUT_DIR,"/",reads1,".sam")
  
  code_block2 <- paste0("samtools view -Sb ",OUTPUT_DIR,"/",reads1,".sam > ",OUTPUT_DIR,"/",reads1,"_LR.bam")
  

  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=40000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=20", sh_name, append = TRUE)
  write ("#SBATCH --time=03:40:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("#SBATCH --partition=pibu_el8", sh_name, append = TRUE)
  write ("module load Bowtie2/2.4.4-GCC-10.3.0", sh_name, append = TRUE)
  write ("module load SAMtools/1.13-GCC-10.3.0", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write (code_block2, sh_name, append = TRUE)
}
