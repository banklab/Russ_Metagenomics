
ASM_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_DEER/06_Assembly"
BAM_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_DEER/07_BAM"
OUTPUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_DEER/08_Binning/03_CONCOCT"

DATASET="deer"


setwd(ASM_DIR)

Read_list <- gsub("_scaffolds.*","",list.files(pattern="_scaffolds_filtered_NoNorm.fasta"))

setwd(OUTPUT_DIR)
for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sub_reads1 <- reads1
  
  reads_dir <- paste0(reads1,"_concoct")
  
  sh_name <- paste0(reads1,"_concoct.sh")
  
  code_block <- paste0("cut_up_fasta.py ",ASM_DIR,"/",reads1,"_scaffolds_filtered_NoNorm.fasta -c 10000 -o 0 --merge_last -b ",sub_reads1,"_",DATASET,"_10K.bed > ",sub_reads1,"_",DATASET,"_10K.fa")

  code_block2 <- paste0("concoct_coverage_table.py ",sub_reads1,"_",DATASET,"_10K.bed ",BAM_DIR,"/",sub_reads1,"_nonorm.sorted.bam > ",sub_reads1,"_coverage_table.tsv")
  
  code_block3 <- paste0("concoct --composition_file ",sub_reads1,"_",DATASET,"_10K.fa --coverage_file ",sub_reads1,"_coverage_table.tsv -b concoct_output/")
  
  code_block4 <- paste0("extract_fasta_bins.py ",ASM_DIR,"/",reads1,"_scaffolds_filtered_NoNorm.fasta concoct_output/clustering_merged.csv --output_path concoct_output/fasta_bins")
  
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=4000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=24:00:00", sh_name, append = TRUE)
  write ("#SBATCH --partition=pibu_el8", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write (paste0("mkdir ",reads_dir), sh_name, append = TRUE)
  write (paste0("cd ",reads_dir), sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write (code_block2, sh_name, append = TRUE)
  write (code_block3, sh_name, append = TRUE)
  write ("merge_cutup_clustering.py concoct_output/clustering_gt1000.csv > concoct_output/clustering_merged.csv", sh_name, append = TRUE)
  write ("mkdir concoct_output/fasta_bins", sh_name, append = TRUE)
  write (code_block4, sh_name, append = TRUE)
  write ("echo Finished CONCOCT $i", sh_name, append = TRUE)
  
}
