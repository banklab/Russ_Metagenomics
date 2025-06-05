# Russ_Metagenomics

Author Contact Information

russell.jasper@unibe.ch

https://banklab.github.io/


DOI

## Pervasive Intraspecific Genetic Local Adaptation Within the Natural Gut Microbiome 

Workflow to assemble metagenomes from short-read metagenomic data and to detect candidate loci for genetic local adaptation.

03_Trim: trim and process reads

04_FastUniq: deduplicate reads

06_Assembly: individual assemblies

07_BAM: align reads to assemblies

08_Binning: bin alignments into putative species-level bins, binning refinement

09_CheckM2: quantify quality metrics of bins

10_Consolidate_Bins: find best bins from different bin sets

11_dRep: dereplicate redundant bins

12_Alignment: align reads against dereplicated reference assemblies

13_Prodigal: infer gene space in each genome

14_InStrain: call snps

15_Salmon: quantify relative abundance of each species

16_Taxonomy: infer taxonomy of each species-level bin

17_CMH: detect candidate snps for genetic local adaptation

18_eggNOG: infer gene function of all predicted genes

19_Diversity: calculate population genetics metrics

20_MEME_Suite: infer function of intergenic regions

