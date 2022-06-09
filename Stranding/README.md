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
**Stranding**

This section describes the stranding of the QC’ed genotyping data to the Haplotype Reference Consortium (HRC) prior to imputation.

**Note:** To skip this step, download the controlled access “HRC Stranded Genotyping Data” generated from (Sayaman et al., 2021), as described in Step 8 of the “Prepare Germline Genetic Variation Dataset” section of this protocol OR proceed with the Stranding protocol steps provided below. 


## Workflow
**Timing: Approximately <1 day. Dependent on server capabilities.**

1.	Prior to stranding, identify and remove all palindromic SNPs (A/T or G/C).

2.	Perform stranding to the Haplotype Reference Consortium using the McCarthy Group tools. (https://www.well.ox.ac.uk/~wrayner/tools/; see section “HRC or 1000G Imputation preparation and checking”)

	a.	Download and unzip the tab delimited HRC reference file (currently v1.1 HRC.r1-1.GRCh37.wgs.mac5.sites.tab) from the Haplotype Reference Consortium (http://www.haplotype-reference-consortium.org/site)

	b.	Perform stranding of the quality-controlled genotyping file against the HRC reference panel using the high performance cluster version of the script (HRC-1000G-check-bim-v4.2.13-NoReadKey.zip), which compares genotyping alleles to the corresponding SNP alleles from HRC
	
	c.	Provide the .bim file, the calculated allele frequencies (--freq) and the reference panel as input	s (See “Usage with HRC reference panel”)

**Note:** The McCarthy Group tools (https://www.well.ox.ac.uk/~wrayner/tools/) stranding script removes SNPs with differing alleles, SNPs with > 0.2 allele frequency difference, and SNPs not in the reference panel. The McCarthy Group stranding script would also remove A/T & G/C palindromic SNPs with MAF > 0.4, however we chose to remove all palindromic SNPs in the preceding step to remove ambiguity.


## Expected outcomes

*Good Quality TCGA Germline Imputation Calls*

If this protocol is carried out as described here, you can expect to identify a total of 838,948 autosomal chromosome variants for 10,128 unique individuals that pass the QC filters. After removal of palindromic SNPs and stranding to the HRC panel 680,389 correctly matched variants remain. These are submitted to the MIS which returns 39,127,678 SNPs for 10,128 unique individuals (Figure 2a). Subsequent quality control analysis and filtering based on imputation quality (R2 ≥ 0.5) and  minor allele frequency (MAF ≥ 0.005) thresholds yields 10,955,441 SNPs (Figure 2a, 2b).


## Troubleshooting

**Problem:** 

Issues or errors running commands on the high-performance compute server or implementing available code from GitHub. (Quality Control Analysis of Germline Data (Steps 1-9); Stranding (Steps 12-13); Genotype Imputation (Steps 14 – 17))

**Potential solution** 

Ensure the proper software, libraries and dependencies are installed. Software implementation may be version specific, the versions used in the protocol are provided to ensure reproducibility. The provided GitHub code for pre-processing genotyping data was optimized for the specifications of the TIPCC high-performance compute (HPC) environment at University of California, San Francisco (UCSF) (which had 8 communal compute nodes and 1 dedicated node, each with 12 to 64 cores, 64 to 512 GB of RAM and at least 1.8 TB of fast local disk space) employing Portable Batch System (PBS) job scheduling. Consult your system administrator to adapt the provided code to your system.


**Problem:** 
Computation run times are much slower than expected. Inadequate computational power to run workflows. (Quality Control Analysis of Germline Data (Steps 1-9); Stranding (Steps 12-13); Genotype Imputation (Steps 14 – 17)

**Potential solution** 

Some sections of this protocol require intensive computation that requires high-performance computing as outlined in the ‘Before Your Begin’ section. Note that run times are dependent on the specifications of the compute environment. Before running analysis of the whole genome, consider first benchmarking performance on a single chromosome – e.g., the smallest chromosome, chr21 or largest chromosome, chr1, to estimate run times and assess if you have compute resources with adequate specifications. If you encounter difficulties running the protocol such as inadequate disk storage or slow processing speeds such that the protocol takes a prohibitively longer time than is useful, you can consider alternatives such as using an adequately provisioned system in a cloud-computing environment. Work with the relevant vendors to create virtual instances that will meet both the need for data security and processing power to run the workflows described in this protocol.
