## Introduction

Workflows to analyze single-cell RNA-sequencing data using CellRanger, including gene-expression (GEX) library and VDJ library. Utilized by both VSDB/VPT and IPB/MVVT. The ultimate goal is to integrate these workflows into Clarity for automation.

## Prerequisite

* Cell Ranger 7.1.0 has been installed in Rosalind. 
* Make sure the naming of the fastq files follow the convention as <SampleID>_<IndexSequence>_L<lane>_R<read>_001.fastq.gz.
* Make sure no ‘_’ in SampleID

## Reference preparation

Referenced stored at /scicomp/reference/cellranger/7.1.0. These references include:
* Human reference (GRCh38) dataset
* Mouse reference dataset
* Human reference (GRCh38) and mouse dataset
* GRCh38 Human V(D)J Reference - 7.1.0
* GRCm38 Mouse V(D)J Reference - 7.0.0

VDJ reference for humanized mice is available [here](humanized_vdj_ref). These were built by adding mouse constant genes into the human VDJ reference.

## Running steps

1. BCLtoFASTQ, demultiplexing and upload to SciComp (source_directory) using current GDT pipeline (merge reads of one sample from all lanes into one fastq file?)

2. (Optional) copy to working directory (destination_directory) on SciComp: run copy.sh with parameters --source_directory and --destination_directory

```sh copy.sh --source_directory=/path/to/source_directory --destination_directory=/path/to/destination_directory```

3. If samples belong to VDJ libraries - generate shell scripts and submit to Rosalind for execution for all samples: run submit_CellRanger_jobs.sh with parameters --sequencing_directory and --reference_location

```sh VDJ_jobs.sh --sequencing_directory=/path/to/sequencing_results --reference_location=/path/to/reference```

4. If samples belong to gene expression (GEX) libraries - generate shell scripts and submit to Rosalind for execution for all samples: run submit_CellRanger_jobs.sh with parameters --sequencing_directory, --reference_location and --expect_cells

```sh GEX_jobs.sh --sequencing_directory=/path/to/sequencing_results --reference_location=/path/to/reference --expect_cells=expected_cell_number```

Each job will be run in 2 cores with 64G memory.
