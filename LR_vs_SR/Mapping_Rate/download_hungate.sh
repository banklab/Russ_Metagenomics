# 400 genomes from hungate400.tsv
https://vetgenomics.github.io/metagenomics/hungate1000/


conda activate ncbi-datasets

datasets download genome accession --inputfile hungate1000_400_accessions.txt --include genome --filename hungate1000_400.zip
