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
**Quality Control Analysis of Germline Data**

This section describes quality control (QC) assessment of the TCGA Affymetrix Genome-Wide SNP 6.0 germline genotyping data (Figure 1) using PLINK to generate a high-quality set of SNPs for all whitelisted TCGA samples (i.e. a list of platform-specific samples verified to be appropriate for use). See Key Resources Table.  

Review other resources for suitable QC steps based on the study design (Anderson, 2011; Anderson et al., 2010; Aron and Choudhury, 2015)

**Note:** Original QC steps were performed in PLINK version. 1.9. QC analysis requires a high-performance compute cluster. 

**Note:** To skip this step, download the controlled access “QC Unimputed Genotyping Data” generated from (Sayaman et al., 2021), as described in Step 8 of the “Prepare Germline Genetic Variation Dataset” section of this protocol OR proceed with the QC protocol steps provided below. 


## Workflow
**Timing: Approximately 1-2 weeks. Dependent on server capabilities.**

1.	Map birdseed genotyping file names to corresponding TCGA aliquot barcode using the download annotation JSON file from GDC TCGA legacy archive.

2.	Verify sample list for inclusion in the analysis and filter out samples which are not represented in the whitelist, and which do not pass the analyte code filter.

	a.	Cross-reference sample set with whitelisted germline samples from GDC PanCanAtlas Publications page (https://gdc.cancer.gov/about-data/publications/pancanatlas). Non-whitelisted samples have since been flagged for withdrawal in the various TCGA projects.

	* i.	Download the Merged Sample Quality Annotations file (merged_sample_quality_annotations.tsv).

	* ii.	To select whitelisted samples, filter for samples with “platform” column set to  “Genome_Wide_SNP_6” and the “Do not use”’ column set to “FALSE”.

	b.	Based on established TCGA barcode identifiers, ensure all whitelisted samples have Analyte code “D” (DNA). Exclude samples with other Analyte codes.

**Note:** The final TCGA whitelisted samples used in this analysis are available from (Sayaman et al., 2021), Table S1. The GDC Genome Wide SNP 6.0 platform whitelisted files included samples with TCGA analyte barcode identifiers annotated “D” (DNA) or “G” (Whole Genome Amplification). Samples with analyte barcode identifier “G” were excluded from our analysis. 

3.	Load and concatenate individual whitelisted genotyping birdseed files using custom scripts, selecting SNPs with call confidence values ≤ 0.1. Annotate variants and generate PLINK files.

	a.	To take advantage of parallel processing, concatenate and filter birdseed text files in batches.

	b.	Read each birdseed text file as a tab delimited table with 906,600 SNPs as rows and three columns containing the following information:   (See page 1, 
http://tools.thermofisher.com/content/sfs/brochures/genome_wide_snp6_sample_dataset_readme.pdf).

	* i.	Composite Element REF: the probeset ID

	* ii.	Call: the genotype call with values of {-1, 0, 1, 2} corresponding to {NoCall, AA, AB, BB}

	* iii.	Confidence: the call confidence with values ranging from [0,1] with lower values corresponding to greater confidence

	c.	Pre-filter to exclude SNPs with lower call confidence and set the “Call” value to NA for SNPs with “Confidence” > 0.1 prior to concatenation.

	d.	Iteratively concatenate each call column, generating a table with SNPs as rows, samples as columns, and call values as elements.

	i.	Check that probeset IDs match prior to concatenating a genotyping call; if not, exclude and log the mismatched birdseed file.

	e.	Using a custom script, convert batch concatenated birdseed files into PLINK standard input transposed text format files.

	* i.	Using the Affymetrix SNP Array 6.0 (release 35) annotation file, convert concatenated data into PLINK transposed text genotype tables (.tped) with allele calls (See .tped file format specification:
https://www.cog-genomics.org/plink2/formats#tped).
	
	* ii.	Create corresponding PLINK sample information files (.tfam) (See .tfam file format specification:
 https://www.cog-genomics.org/plink2/formats#tfam).

4.	Import whitelisted germline data into PLINK for QC. Convert PLINK standard input transposed text files (--tfile) to standard input binary files (--bfile).
https://www.cog-genomics.org/plink2/input

	a.	Import the tfile set (--tfile) into PLINK and create a bfile set (--make-bed --out) that generates corresponding PLINK binary biallelic genotype tables (.bed), PLINK extended MAP files (.bim) and PLINK sample information files (.fam). See file format specifications:
	
	* https://www.cog-genomics.org/plink2/formats#bed
	* https://www.cog-genomics.org/plink2/formats#bim
	* https://www.cog-genomics.org/plink2/formats#fam

5.	Impute the genotyping sex associated with each sample by calculating the X chromosome homozygosity estimate (XHE):
https://www.cog-genomics.org/plink/1.9/basic_stats#check_sex.

	a.	Split off the X chromosome's pseudo-autosomal region (--split-x) which is treated by PLINK as a separated XY chromosome. Indicate the proper build code.
	
	b.	Perform LD pruning (--indep-pairphrase).
	
	c.	Run check sex (--check-sex) which compares reported sex assignments with those imputed from X chromosome F coefficients.
	
	d.	Plot a histogram of the XHE F coefficients (F coeff). See Figure 1a from (Chambwe, Sayaman et al., 2022).
	
	* i.	A very tight distribution of F coeff around 1 is expected for males, and a more spread distribution of F coeff centered around zero is expected for females. 
	
	* ii.	In PLINK, F estimates < 0.2 are by default assigned female and F estimates > 0.8 assigned male. However, when (i) is observed and there is a clear gap between the two distributions, F coeff thresholds can be loosened and adjusted to correspond to the empirical gap. See --check-sex implementation and notes on TCGA sex assignment below.
	
	e.	Impute sex (--impute-sex) based on the XHE F coefficient.
	
	f.	Curate imputed sex assignments as needed.

**Note:**  To minimize loss of TCGA samples when no self-reported sex is available and sex information is needed as a covariate in the analysis, sex can be imputed based on the XHE (F or inbreeding coefficient). 

**Note:**  Not all TCGA samples have self-reported sex information and we imputed sex based XHE. However, we found cases where self-reported and imputed sex were discordant; sex assignments were curated depending on whether F coefficients fall within the expected range (F coeff < 0.2 for females and > 0.8 for males) or F coefficients fall out of the expected range (F coeff > 0.2 and < 0.8) (see Troubleshooting section, Problem 4). These imputed/curated sex assignments for TCGA germline samples are available in Table S1 from (Sayaman et al., 2021).

6.	Exclude SNPs and individuals with greater than 5% missingness. 

	a.	Filter variants (--geno) to include only SNPs with 95% genotyping rate (5% missing).

	b.	Filter samples (--mind) to exclude individuals with more than 5% missing genotypes.

7.	Calculate heterozygosity within each ancestry cluster, and filter samples with excess heterozygosity.
https://www.cog-genomics.org/plink/1.9/basic_stats#ibc

	a.	Using downloaded ancestry assignments, calculate heterozygosity (--het) by filtering for samples (--keep) within each of the European (EUR), African (AFR),  East Asian (EAS) and Admixed American (AMR) ancestry clusters.

	b.	Calculate heterozygosity means and standard deviations in each ancestry cluster.

	c.	Plot the log10 proportion of missing genotypes against heterozygosity rates with mean +/-3*SD for each ancestry cluster for QC. See Figure 1b from (Chambwe, Sayaman et al., 2022).

	d.	Remove samples (--remove) with heterozygosity >3*SD above the mean for each ancestry cluster. 

**Note:** Not all TCGA samples have self-reported race and ethnicity data. Ancestry can be calculated based on Principal Component Analysis (PCA) of germline data (--pca). In (Sayaman et al., 2021) initial ancestry calls were made based on Partition Around Medoids (PAM) clustering with k=4 using the first 3 principal components as described in  ((Sayaman et al., 2021), (Carrot-Zhang et al., 2020) 2020).

**Note:** Samples with low heterozygosity are expected for certain ancestry groups and are not removed.

8.	Select a representative sample for each individual with replicate samples. Conduct final filtering steps for all autosomal SNPs across the set of unique individuals.

	a.	Restrict to autosomal chromosomes by excluding all unplaced and non-autosomal (--autosomes).

	b.	Preferentially select blood-derived normal samples; for those with more than one blood-derived sample, retain the samples with higher call rates (--keep).

**Note:** All individuals and selected representative sample aliquots from TCGA germline data are listed in Table S1 from (Sayaman et al., 2021).

9.	Calculate Hardy-Weinberg Equilibrium (HWE) within the largest ancestry cluster (EUR ancestry cluster). 
https://www.cog-genomics.org/plink/1.9/basic_stats#hardy

	a.	Calculate HWE (--hardy) across autosomal chromosomes.

	b.	Plot the -log10 HWE p-value distribution for QC. See Figure 1c from (Chambwe, Sayaman et al., 2022).

	c.	Exclude SNPs (--exclude) that deviate from the expectation under HWE (p < 1x10-6) within the EUR ancestry cluster with the exception of SNPs previously associated with any cancer as reported in the GWAS catalog (p < 5x10-8)(Rashkin et al., 2020) since they may deviate from HWE in cancer patients. 

10.	Calculate Minor allele frequency (MAF) and exclude SNPs with MAF less than 0.5%. 
https://www.cog-genomics.org/plink/1.9/filter#maf

	a.	Calculate SNP MAFs (--freq).

	b.	Plot the MAF cumulative distribution and histogram of -log10 MAF for QC. See Figure 1d from (Chambwe, Sayaman et al., 2022).

	c.	Filter out SNPs (--maf) with MAF < 0.005. 

11.	Remove duplicate SNPs with identical genomic first position.

	a.	Using custom script, find SNPs with duplicate genomic first positions in the .bim file or alternatively identify SNPs sharing the same bp coordinate and allele codes in PLINK (--list-duplicate-vars). 

	b.	Filter out duplicate SNPs (--exclude).

**Note:**  The final QC’d list of samples (.fam) and SNP (.bim) files are available as part of the “Quality-controlled unimputed genotyping data plink files - QC_Unimputed_plink.zip” file under the “QC Unimputed Genotyping Data” sub-section of “TCGA QC HRC Imputed Genotyping Data used by the AIM AWG (from Sayaman et al.)” section of the “Supplemental Data Files”: 
https://gdc.cancer.gov/about-data/publications/CCG-AIM-2020



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


**Problem:** 

Sex imputation based on XHE yields discordant self-reported and imputed sex in TCGA. (Step 5)

**Potential solution** 

Not all TCGA samples have self-reported sex information and we imputed sex based XHE. However, we found cases where self-reported and imputed sex were discordant. Moreover, we found no clear empirical gap in the distribution between those self-reporting as female and male (Figure 1a). In (Sayaman et al., 2021), we used both imputed and self-reported sex to curate sex assignments in TCGA. 

(1) For all individuals falling within the expected XHE distributions, individuals with F coefficients < 0.2 were assigned female and those with F coefficients > 0.8 were assigned male, this includes: (i) individuals with concordant imputed and self-reported sex (Figure 4a, 4f), (ii) individuals with discordant imputed and self-reported sex, where imputed sex is assigned (Figure 4c, 4d), and (iii) individuals with no self-reported sex (4g, 4i). 

(2) For individuals with an uncharacteristic distribution of F coeff > 0.2 < 0.8 (Figure 4b, 4e) with an unexpectedly significant proportion of individuals self-reporting as male with F coeff < 0.8 (Figure 4e), we elected to keep the self-reported sex assignment. We reasoned that since the distribution of F coeff for those self-reporting as female is still centered around 0 just with larger spread (Figure 4b), the uncharacteristic distribution of F coeff for those self-reporting as male (Figure 4e) may be due to array quality. 

(3) For the single individual with F coeff > 0.2 < 0.8 and no self-reported sex, the individual was assigned female based on distribution of F coeff (Figure 1h). These imputed/curated sex assignments for TCGA germline samples are available in Table S1 from (Sayaman et al., 2021).
