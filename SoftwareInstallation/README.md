# TCGA_PanCancer_Genotyping_Imputation

Last updated: 03/23/2022

## Description
We present a protocol for quality control and assessment of the TCGA Affymetrix Genome-Wide Human SNP Array 6.0 data to generate a high-quality imputed genotyping dataset comprised of ~11M SNPs for more than 9000 patients in the TCGA cohort. The protocol is developed around the structure of TCGA, but it can be adapted to explore other genotyping array data sets.

The code and data deposited here were used to generate the results and resource files for the Sayaman, Saad et al., Immunity 2021 and Carrot-Zhang et al., Cancer Cell 2020 papers.

Code contained herein are meant as a guide and should be modified and adapted to match your server specifications and directories.


## Citations
Please cite Sayaman, Saad et al., Immunity 2021 when using the data and code contained here in, and downloading the TCGA QC and HRC imputed genotyping data. 
* Sayaman, Saad et al., Immunity (2021). Germline genetic contribution to the immune landscape of cancer. https://doi.org/10.1016/j.immuni.2021.01.011
* Chambwe, Sayaman, et al., Analysis of Germline-Driven Ancestry-Associated Gene Expression in Cancers.

Please additionally cite: Carrot-Zhang et al., Cancer Cell 2020 when referencing ancestry assignments and downloading the TCGA QC and HRC imputed genotyping data.
* Carrot-Zhang et al., Cancer Cell (2020). Comprehensive Analysis of Genetic Ancestry and Its Molecular Correlates in Cancer. https://doi.org/10.1016/j.ccell.2020.04.012


## Contents
**Software Installation**
This protocol describes the manipulation of large-scale genomic datasets on the order of millions of genetic markers in thousands of samples.
This protocol was developed in PLINK 1.9 beta: (https://www.cog-genomics.org/plink/1.9)

 
## Workflow
**Timing: 1h**

1.	Install PLINK software (version. 1.9 or current version) on the high-performance compute environment (Chang et al., 2015; Purcell et al., 2007) (http://www.cog-genomics.org/plink).

2.	Install bcftools software (version 1.9 or current version) (Danecek et al., 2021) (https://samtools.github.io/bcftools/).

3. Install R programming software (https://www.r-project.org/)
