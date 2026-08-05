
## predict 16S from MAGs


for f in TEST/*.fa
do
    base=$(basename "$f" .fa)
    barrnap --kingdom bac "$f" > "02_Barrnap/${base}.gff"
done
