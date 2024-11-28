#!/bin/bash
#SBATCH --mem=100M
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mail-user=<russell.jasper@unibe.ch>
#SBATCH --mail-type=FAIL,END
#SBATCH --output=slurm-%x.%j.out
module load Python/3.10.8-GCCcore-12.2.0

DIR=/storage/scratch/users/rj23k073/04_DEER/10_Consolidate_Bins


for i in $(cat redux_sample_list.txt)
do

mkdir "$DIR"/03_Temp_Winner/"$i"_deer

## MetaBAT2 vs MaxBin2
python consolidate_two_sets_of_bins.py $DIR/01_Bins/MetaBAT2/"$i"_deer_metabat $DIR/01_Bins/MaxBin2/"$i"_deer_maxbin $DIR/02_Stats/"$i"_MetaBAT2_stats.txt $DIR/02_Stats/"$i"_MaxBin2_stats.txt $DIR/03_Temp_Winner/"$i"_deer/round1 70 10

## CONCOCT NAME STUFF ###########
## Previous winners vs CONCOCT
python consolidate_two_sets_of_bins.py $DIR/03_Temp_Winner/"$i"_deer/round1 $DIR/01_Bins/CONCOCT/"$i"_concoct $DIR/03_Temp_Winner/"$i"_deer/round1.stats $DIR/02_Stats/"$i"_CONCOCT_stats.txt $DIR/03_Temp_Winner/"$i"_deer/round2 70 10

## Previous winners vs (MaxBin2 + CONCOCT) ... and so on
python consolidate_two_sets_of_bins.py $DIR/03_Temp_Winner/"$i"_deer/round2 $DIR/01_Bins/MaxCon/"$i"_Binning_refiner_outputs $DIR/03_Temp_Winner/"$i"_deer/round2.stats $DIR/02_Stats/"$i"_MaxCon_stats.txt $DIR/03_Temp_Winner/"$i"_deer/round3 70 10

python consolidate_two_sets_of_bins.py $DIR/03_Temp_Winner/"$i"_deer/round3 $DIR/01_Bins/MetaCon/"$i"_Binning_refiner_outputs $DIR/03_Temp_Winner/"$i"_deer/round3.stats $DIR/02_Stats/"$i"_MetaCon_stats.txt $DIR/03_Temp_Winner/"$i"_deer/round4 70 10

python consolidate_two_sets_of_bins.py $DIR/03_Temp_Winner/"$i"_deer/round4 $DIR/01_Bins/MetaMax/"$i"_Binning_refiner_outputs $DIR/03_Temp_Winner/"$i"_deer/round4.stats $DIR/02_Stats/"$i"_MetaMax_stats.txt $DIR/03_Temp_Winner/"$i"_deer/round5 70 10

python consolidate_two_sets_of_bins.py $DIR/03_Temp_Winner/"$i"_deer/round5 $DIR/01_Bins/MetaMaxCon/"$i"_Binning_refiner_outputs $DIR/03_Temp_Winner/"$i"_deer/round5.stats $DIR/02_Stats/"$i"_MetaMaxCon_stats.txt $DIR/03_Temp_Winner/"$i"_deer/round6 70 10

mkdir $DIR/04_Top_Bins/"$i"_deer
cp -r $DIR/03_Temp_Winner/"$i"_deer/round6/*fa $DIR/04_Top_Bins/"$i"_deer
cp $DIR/03_Temp_Winner/"$i"_deer/round6.stats $DIR/04_Top_Bins/STATS/"$i".stats

echo "Done"
echo $i
done
