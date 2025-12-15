
BAM_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/09_Alignment"
OUTPUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/11_InStrain"

Reference="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/REFERENCE/DEER_v2.fa"
Scaffold_to_Bin="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/REFERENCE/DEER_v2.stb"
Prodigal="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/REFERENCE/DEER_v2.genes.fna"



setwd(BAM_DIR)

Read_list <- list.files(pattern="_LR.sorted.bam$")

Read_list <- Read_list[!grepl("deer",Read_list)]


setwd(OUTPUT_DIR)


for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sub_reads <- gsub("_LR.sorted.bam","",reads1)
  
  sh_name <- paste0(sub_reads,"_InStrain.sh")
  
  code_block <- paste0("inStrain profile ",BAM_DIR,"/",reads1," ",Reference," -o ",sub_reads,"_LR_InStrain -s ",Scaffold_to_Bin," -g ",Prodigal," -p 4 --database_mode")
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=160000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=4", sh_name, append = TRUE)
  write ("#SBATCH --time=24:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("#SBATCH --partition=pibu_el8", sh_name, append = TRUE)
  write ("module load Python/3.9.5-GCCcore-10.3.0", sh_name, append = TRUE)
  write ("module load SAMtools", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write ("echo 'Finished InStrain'", sh_name, append = TRUE)
  
}
