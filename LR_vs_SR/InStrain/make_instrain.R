
BAM_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/wrong_01_Alignment"
OUTPUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/02_InStrain_SR_alignments"

setwd(BAM_DIR)

Read_list <- c(2_1,2_10,2_2,2_3,2_4,2_5,2_8,2_9,4_1,4_10,4_2,4_3,4_4,4_5,4_6,4_8,4_9,6_1,6_10,6_2,6_3,6_4,6_5,6_6,6_8,6_9,7_5,7_6)


setwd(OUTPUT_DIR)


for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sh_name <- paste0("instrain_LR28_",reads1,"_drep95.sh")
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=40G", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=4", sh_name, append = TRUE)
  write ("#SBATCH --time=2:40:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
   write ("#SBATCH --partition=pibu_el8", sh_name, append = TRUE)
  write ("module load Python/3.9.5-GCCcore-10.3.0", sh_name, append = TRUE)
 write ("module load SAMtools", sh_name, append = TRUE)
 write ("BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/wrong_01_Alignment", sh_name, append = TRUE)
 write ("OUTPUT_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/02_InStrain_SR_alignments", sh_name, append = TRUE)

   write ("REF_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/Outliers_LR_ONLY/REFERENCES", sh_name, append = TRUE)
 write ("REF=DEER_LR_only.fa", sh_name, append = TRUE)
 write ("STB=DEER_LR_only.stb", sh_name, append = TRUE)
 write ("Prodigal=DEER_LR_only.genes.fna", sh_name, append = TRUE)

  write (paste0("for bam in $BAM_DIR/",reads1,".bam"), sh_name, append = TRUE)
write ("do", sh_name, append = TRUE)
write ("ID1=$(basename $bam)", sh_name, append = TRUE)
write ("ID=${ID1%.bam}", sh_name, append = TRUE)
  
  write ("SNP_OUT=$OUTPUT_DIR/$ID_LR28_InStrain", sh_name, append = TRUE)

write ("echo Mapping $ID to $REF", sh_name, append = TRUE)

write ("inStrain profile $bam $REF_DIR/$REF -o $SNP_OUT -s $REF_DIR/$STB -g $REF_DIR/$Prodigal -p 4 --database_mode", sh_name, append = TRUE)
write ("done", sh_name, append = TRUE)
}
