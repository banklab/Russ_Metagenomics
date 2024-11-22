
#!/bin/bash
#SBATCH --mem=2000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=6:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
for i in *gz
do
file2=$(echo $i | perl -pe 's/fastq.gz/fastq/')
gunzip -cd $i > $file2
done

