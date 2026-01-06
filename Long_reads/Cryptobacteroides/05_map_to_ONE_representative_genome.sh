
## representative Cryptobacteroides
## hybrid_semibin_2_8_bin.23 (analog to 2_10_bin.9)

module load Bowtie2/2.4.4-GCC-10.3.0
bowtie2-build hybrid_semibin_2_8_bin.23.fa hybrid_semibin_2_8_bin.23



READ_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Cryptobacteroides"
OUTPUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Cryptobacteroides/02_Alignment"

REF="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/Cryptobacteroides/01_Reference/hybrid_semibin_2_8_bin.23"

setwd(READ_DIR)

Read_list <- gsub("_transposase_R1.fq","",list.files(pattern="transposase_R1.fq"))

setwd(OUTPUT_DIR)


for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sh_name <- paste0(reads1,"_bowtie_crypto.sh")
  
  code_block <- paste0("bowtie2 -p 1 -x ",REF," -1 ",READ_DIR,"/",reads1,"_transposase_R1.fq -2 ",READ_DIR,"/",reads1,"_transposase_R2.fq -S ",OUTPUT_DIR,"/",reads1,".sam")
  
  code_block2 <- paste0("samtools view -Sb ",OUTPUT_DIR,"/",reads1,".sam > ",OUTPUT_DIR,"/",reads1,"_crypto.bam")
  

  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=4000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=1:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("#SBATCH --partition=pibu_el8", sh_name, append = TRUE)
  write ("module load Bowtie2/2.4.4-GCC-10.3.0", sh_name, append = TRUE)
  write ("module load SAMtools/1.13-GCC-10.3.0", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write (code_block2, sh_name, append = TRUE)
}


## sort and index
for f in *_crypto.bam; do
    sample=${f%.bam}
    samtools sort "$f" -o "${sample}.sorted.bam"
    samtools index "${sample}.sorted.bam"
done







