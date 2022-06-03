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
**Apply for dbGaP Authorization**

**Critical:** dbGAP authorization is necessary to download controlled-access TCGA germline data. While the application process is relatively straightforward, the review process can take some time. We recommend applying for as soon as is feasible.

 
## Workflow
**Timing: 1-3 weeks**

1.	Verify that you institution has an account. If not, apply for an institutional dbGap account with the relevant institutional officers.  
2.	Apply for dbGaP authorization to access TCGA controlled-access data. See instructions here: https://dbgap.ncbi.nlm.nih.gov/aa/wga.cgi?page=login
3.	Prepare a data access request: https://www.ncbi.nlm.nih.gov/projects/gap/cgi-bin/GetPdf.cgi?document_name=GeneralAAInstructions.pdf


## Troubleshooting

**Problem:** 

Issues accessing controlled-access data from the GDC Portal or the GDC publication page associated with (Carrot-Zhang et al., 2020). (Step 6 of before you begin)

**Potential solution** 
All TCGA germline data are controlled access. Ensure that you have followed all steps required by the GDC to obtain controlled-access data including authentication through eRA Commons and dbGaP authorization. Step by step instructions for obtaining access are outlined in the ‘Before You Begin’ section above and further details can be found here: https://gdc.cancer.gov/access-data/obtaining-access-controlled-data.


