
#!/bin/bash
#SBATCH --mem=80000M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=48:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
#SBATCH --partition=pibu_el8 
module load Python/3.9.5-GCCcore-10.3.0
module load SAMtools

BAM_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/06_Alignment
OUTPUT_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/08_InStrain


REF_DIR=/data/projects/p898_Deer_RAS_metagenomics/04_Deer/REDO_SR_Binning/REFERENCES
REF=DEER_SR.fa
STB=DEER_SR.stb  
Prodigal=DEER_SR.genes.fna


## SUBSET DEER ##
for bam in "$BAM_DIR"/1_*bam
do

ID1=$(basename "$bam")
ID="${ID1%.bam}"

SNP_OUT="$OUTPUT_DIR"/"$ID"_SR_InStrain

echo "Call snps $ID on $REF"

inStrain profile $bam "$REF_DIR"/"$REF" -o $SNP_OUT -s "$REF_DIR"/"$STB" -g "$REF_DIR"/"$Prodigal" -p 4 --database_mode

done
