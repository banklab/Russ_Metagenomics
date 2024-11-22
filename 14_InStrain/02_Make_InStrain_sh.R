
BAM_DIR="/storage/scratch/users/rj23k073/04_DEER/12_Alignment"
OUTPUT_DIR="/storage/scratch/users/rj23k073/04_DEER/14_InStrain/01_One_Population"

Reference="/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/REFERENCES/dRep_ONLY_bin_ref_fastANI.fasta"
Scaffold_to_Bin="/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/REFERENCES/dRep_ONLY_bin_ref_fastANI.stb"
Prodigal="/storage/workspaces/vetsuisse_fiwi_mico4sys/fiwi_mico4sys001/metagenomics/processed/04_D/13_Prodigal/dRep_ONLY_bin_ref_fastANI.genes.fna"




setwd(BAM_DIR)

Read_list <- list.files(pattern="sorted.bam")[!grepl("bai",list.files(pattern="sorted.bam"))]


setwd(OUTPUT_DIR)


for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sub_reads <- gsub("\\.bin.*","",reads1)
  
  sh_name <- paste0(sub_reads,"_InStrain.sh")
  
  code_block <- paste0("inStrain profile ",BAM_DIR,"/",reads1," ",Reference," -o ",sub_reads,"_InStrain -s ",Scaffold_to_Bin," -g ",Prodigal," -p 16 --database_mode")
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=80000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=16", sh_name, append = TRUE)
  write ("#SBATCH --time=05:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load vital-it/7", sh_name, append = TRUE)
  write ("module load Python/3.9.5-GCCcore-10.3.0", sh_name, append = TRUE)
  write ("module load UHTS/Analysis/samtools/1.10", sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write ("echo 'Finished InStrain'", sh_name, append = TRUE)
  
}
