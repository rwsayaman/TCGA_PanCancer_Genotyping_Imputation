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
**Genotype Imputation**

This section describes generation of Haplotype Reference Consortium (HRC) imputed genotyping files from the stranded and QC’ed data, see Figure 2a from (Chambwe, Sayaman et al., 2022).

**Note:**  To skip this step, download the controlled access “HRC Imputed Genotyping Data” generated from  (Sayaman et al., 2021) as described in Step 8 of the “Prepare Germline Genetic Variation Dataset” section of this protocol OR proceed with phasing and imputation protocol steps provided below. 


## Workflow
**Timing: Approximately 1 week. Dependent on imputation server availability.**

1. 	Perform phasing and imputation using the Haplotype Reference Consortium (HRC) (Loh et al., 2016b; McCarthy et al., 2016)). 
  
  	a. 	To reduce the run time, divide the VCF file into 22 files corresponding to individual autosomal chromosomes. 
	
	* **Run code:** "qsub_plink_clean.rmPalindromic.HRC_vcfrecode.txt"
  	
  	b. 	Conduct phasing and imputation using a standard pipeline on the Michigan Imputation Server (MIS). 
  	
	c. 	Perform phasing using Eagle (version v2.3 or current version) on the variant call file (VCF) (Loh et al., 2016a). By default, Eagle restricts analysis to bi-allelic variants that exist in both the target and reference data. 

	d.	Run Minimac3 (Das et al., 2016) for imputation. For each of the 22 VCF files, the MIS breaks the dataset into non-overlapping chunks prior to imputation. For HRC imputation, select the HRC reference panel (version r1.1.2016) using mixed population for QC.
	
2.	Download the HRC imputed germline files for each chromosome (“chr*.zip) from the MIS.

	a.	Unzip each file using the provided password 
	
	* **Run code:** "qsub_unzip_HRC_chr.txt" (see READ_ME_4.txt)

	b.	Each unzipped folder contains 3 files: 
	
	* i.	.dose.vcf.gz - imputed genotypes with dosage information
	
	* ii.	.dose.vcf.gz.tbi - index file of the .vcf.gz file
	
	* iii.	 .info.gz file - information for each variant including quality and frequency (For Minimac3 info file, see: https://genome.sph.umich.edu/wiki/Minimac3_Info_File)

3.	Filter to exclude SNPs with imputation R2 < 0.5 using bcftools, see Figure 2b from (Chambwe, Sayaman et al., 2022). The imputation R2 is the estimated value of the squared correlation between imputed genotypes and true, unobserved genotypes.

	a.	Filter "chr*.dose.vcf.gz" files for R2 ≥ 0.5 and index. Generate filtered "chr*.rsq0.5.dose.vcf.gz" and "chr*.rsq0.5.dose.vcf.gz.tbi" files
	
	* **Run code:** "qsub_filter_vcf_R2.txt"
	
	b.	Generate new filtered "chr*.info.rsq0.5.gz" files
	
	* **Run code:** "qsub_make_py_format_info.txt" which requires the "Format_Impute_HRC_Info_chr1.py" template file 
	
	* **Run code:** "qsub_py_format_info.txt" which runs "Format_Impute_HRC_Info_chr*.py" files

4.	Convert VCF files to PLINK files. Filter to exclude SNPs with MAF < 0.005, see Figure 2b from (Chambwe, Sayaman et al., 2022).

	a.	Convert VCF "chr*.rsq0.5.dose.vcf.gz" files to PLINK "tcga_imputed_hrc1.1_rsq0.5_chr*.bed" files
	
	* **Run code:** "qsub_convert_vcf_plink.txt"

	b.	Filter out SNPs (--maf) with MAF < 0.005 in PLINK

	* **Run code:** "qsub_plink_filter_maf.txt"

**Note:** If you plan to analyze only a subset of the samples, recalculate the MAF in PLINK (--freq) for the population of interest. Filter SNPs based on the recalculated frequency. Filter SNPs based on the recalculated frequency.


## Expected outcomes


*Good Quality TCGA Germline Imputation Calls*

If this protocol is carried out as described here, you can expect to identify a total of 838,948 autosomal chromosome variants for 10,128 unique individuals that pass the QC filters. After removal of palindromic SNPs and stranding to the HRC panel 680,389 correctly matched variants remain. These are submitted to the MIS which returns 39,127,678 SNPs for 10,128 unique individuals (Figure 2a). Subsequent quality control analysis and filtering based on imputation quality (R2 ≥ 0.5) and  minor allele frequency (MAF ≥ 0.005) thresholds yields 10,955,441 SNPs, see Figure 2a, 2b from (Chambwe, Sayaman et al., 2022).


## Troubleshooting

**Problem:** 

Issues or errors running commands on the high-performance compute server or implementing available code from GitHub. (Quality Control Analysis of Germline Data (Steps 1-9); Stranding (Steps 12-13); Genotype Imputation (Steps 14 – 17))

**Potential solution** 

Ensure the proper software, libraries and dependencies are installed. Software implementation may be version specific, the versions used in the protocol are provided to ensure reproducibility. The provided GitHub code for pre-processing genotyping data was optimized for the specifications of the TIPCC high-performance compute (HPC) environment at University of California, San Francisco (UCSF) (which had 8 communal compute nodes and 1 dedicated node, each with 12 to 64 cores, 64 to 512 GB of RAM and at least 1.8 TB of fast local disk space) employing Portable Batch System (PBS) job scheduling. Consult your system administrator to adapt the provided code to your system.


**Problem:** 
Computation run times are much slower than expected. Inadequate computational power to run workflows. (Quality Control Analysis of Germline Data (Steps 1-9); Stranding (Steps 12-13); Genotype Imputation (Steps 14 – 17)

**Potential solution** 

Some sections of this protocol require intensive computation that requires high-performance computing as outlined in the ‘Before Your Begin’ section. Note that run times are dependent on the specifications of the compute environment. Before running analysis of the whole genome, consider first benchmarking performance on a single chromosome – e.g., the smallest chromosome, chr21 or largest chromosome, chr1, to estimate run times and assess if you have compute resources with adequate specifications. If you encounter difficulties running the protocol such as inadequate disk storage or slow processing speeds such that the protocol takes a prohibitively longer time than is useful, you can consider alternatives such as using an adequately provisioned system in a cloud-computing environment. Work with the relevant vendors to create virtual instances that will meet both the need for data security and processing power to run the workflows described in this protocol.
