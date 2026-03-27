## copy files to a common directory
## format names so they are congruent with metabat/maxbin names

dest="/data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/06_Binning/03_SemiBin2/bins"

cd /data/projects/p898_Deer_RAS_metagenomics/04_Deer/LONG_READS/06_Binning/03_SemiBin2/out

for d in */; do
    dir=${d%/} 
    for f in "$dir"/output_bins/SemiBin_*.fa; do
        base=$(basename "$f")
        new="semibin_${dir}_bin.${base#SemiBin_}"
        #cp "$f" "$dest/$new"
	echo $f
	echo $new
    done
done
