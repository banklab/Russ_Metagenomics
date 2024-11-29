ASM_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_DEER/06_Assembly"
MetaBat_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_DEER/08_Binning/01_MetaBAT2"
OUTPUT_DIR="/data/projects/p898_Deer_RAS_metagenomics/04_DEER/08_Binning/02_MaxBin2"

setwd(ASM_DIR)

Read_list <- gsub("_deer.*","",list.files(pattern="fasta"))


for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sh_name <- paste0(reads1,"_maxbin2.sh")
  
  reads_dir <- paste0(reads1,"_maxbin")
  
  setwd(paste0(MetaBat_DIR,"/",reads1,"_deer_metabat/"))

  ## depth file from MetaBAT2
  depth_file <- read.table("scaffolds_filtered.fasta.depth.txt", header = T, stringsAsFactors = F)
  
  mod_file <- depth_file[,c(1,4)]

  setwd(OUTPUT_DIR)
  write.table(mod_file, paste0(reads1,"_abundance_table.txt"), row.names = F, col.names = F, quote=F)
  
  code_block <- paste0("perl /data/projects/p898_Deer_RAS_metagenomics/MaxBin2/MaxBin-2.2.7/run_MaxBin.pl -contig ",ASM_DIR,"/",reads1,"_deer.asm_scaffolds_filtered.fasta -abund ",reads1,"_abundance_table.txt -out maxbin -thread 10")
  
  
  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=8000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=10", sh_name, append = TRUE)
  write ("#SBATCH --time=04:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
 write ("#SBATCH --partition=pibu_el8", sh_name, append = TRUE)
  write (paste0("mkdir ",reads_dir), sh_name, append = TRUE)
  write (paste0("mv ",reads1,"_abundance_table.txt ",reads_dir), sh_name, append = TRUE)
  write (paste0("cd ",reads_dir), sh_name, append = TRUE)
  write (code_block, sh_name, append = TRUE)
  write ("echo Finished MaxBin $i", sh_name, append = TRUE)
  
}
