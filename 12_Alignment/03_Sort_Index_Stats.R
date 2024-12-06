
INDIR="/storage/scratch/users/rj23k073/04_DEER/12_Alignment"
OUTDIR="/storage/scratch/users/rj23k073/04_DEER/12_Alignment/01_Stats"

setwd(INDIR)

Read_list <- list.files(pattern="bam")

for(i in 1:length(Read_list)){
  
  reads1 <- Read_list[i]
  
  sh_name <- paste0(sub("\\.bam","",reads1),"_sort_index_stats.sh")

  write ("#!/bin/bash", sh_name)
  write ("#SBATCH --mem=3000M", sh_name, append = TRUE)
  write ("#SBATCH --nodes=1", sh_name, append = TRUE)
  write ("#SBATCH --ntasks=1", sh_name, append = TRUE)
  write ("#SBATCH --cpus-per-task=1", sh_name, append = TRUE)
  write ("#SBATCH --time=3:00:00", sh_name, append = TRUE)
  write ("#SBATCH --mail-user=<russell.jasper@unibe.ch>", sh_name, append = TRUE)
  write ("#SBATCH --mail-type=FAIL,END", sh_name, append = TRUE)
  write ("#SBATCH --output=slurm-%x.%j.out", sh_name, append = TRUE)
  write ("module load SAMtools/1.13-GCC-10.3.0", sh_name, append = TRUE)
  write (paste0("INDIR=",INDIR), sh_name, append = TRUE)
  write (paste0("OUTDIR=",OUTDIR), sh_name, append = TRUE)
  write ("cd $INDIR", sh_name, append = TRUE)
  write (paste0("i=",reads1), sh_name, append = TRUE)
  write ("file2=$(echo $i | perl -pe 's/bam/sorted.bam/')", sh_name, append = TRUE)
  write ("flagfile=$(echo $i | perl -pe 's/bam/flagstat.txt/')", sh_name, append = TRUE)
  write ("insertfile=$(echo $i | perl -pe 's/bam/insert_size.txt/')", sh_name, append = TRUE)
  write ("samtools sort $i > $file2", sh_name, append = TRUE)
  write ("samtools index $file2", sh_name, append = TRUE)
  write ("samtools flagstat $file2 > $flagfile", sh_name, append = TRUE)
  write ("samtools view -f66 $file2 | cut -f 9 | awk '{print sqrt($0^2)}' > $insertfile", sh_name, append = TRUE)
  write ("mv $flagfile $OUTDIR", sh_name, append = TRUE)
  write ("mv $insertfile $OUTDIR", sh_name, append = TRUE)
  write ("echo Finished $file2", sh_name, append = TRUE)
  #write ("rm $i", sh_name, append = TRUE)
  
}
