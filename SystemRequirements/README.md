# TCGA_PanCancer_Genotyping_Imputation

Last updated: 03/23/2022

## Description
We present a protocol for quality control and assessment of the TCGA Affymetrix Genome-Wide Human SNP Array 6.0 data to generate a high-quality imputed genotyping dataset comprised of ~11M SNPs for more than 9000 patients in the TCGA cohort. The protocol is developed around the structure of TCGA, but it can be adapted to explore other genotyping array data sets.

The code and data deposited here were used to generate the results and resource files for the Sayaman, Saad et al., Immunity 2021 and Carrot-Zhang et al., Cancer Cell 2020 papers.

Code contained herein are meant as a guide and should be modified and adapted to match your server specifications and directories.


## Citations
Please cite Sayaman*, Saad* et al., Immunity 2021 when using the data and code contained here in, and downloading the TCGA QC and HRC imputed genotyping data. 
* Sayaman*, Saad* et al., Immunity (2021). Germline genetic contribution to the immune landscape of cancer. https://doi.org/10.1016/j.immuni.2021.01.011
* Chambwe*, Sayaman*, et al., Analysis of Germline-Driven Ancestry-Associated Gene Expression in Cancers.

Please additionally cite: Carrot-Zhang et al., Cancer Cell 2020 when referencing ancestry assignments and downloading the TCGA QC and HRC imputed genotyping data.
* Carrot-Zhang et al., Cancer Cell (2020). Comprehensive Analysis of Genetic Ancestry and Its Molecular Correlates in Cancer. https://doi.org/10.1016/j.ccell.2020.04.012


## Contents
**System Requirements**

This protocol describes workflows that require a high-performance compute environment and data storage capabilities. Ensure that you have adequate computational resources. 

Expected run times are dependent on system specifications and availability of computational resources – e.g., communal vs. dedicated resources. 

**Note:** For reference, the “Quality Control Analysis of Germline Data”, “Stranding”, and “Genotype Imputation” workflows were performed in a University of California, San Francisco (UCSF) high-performance compute environment which had 8 communal compute nodes and 1 dedicated node, each with 12 to 64 cores (each node had from 64 to 512 GB of RAM and at least 1.8 TB of fast local disk space). All input and output data were saved in a dedicated storage server with ~200TB of space. Estimated run times are based on these specifications and the availability of communal nodes.     



