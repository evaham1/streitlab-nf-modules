#!/usr/bin/env nextflow

// Specify DSL2
nextflow.enable.dsl=2

params.cellranger_mkgtf_options    = [:]
params.cellranger_mkref_options    = [:]
params.cellranger_count_options    = [:]

include {tenx_fastq_metadata} from "../../luslab-nf-modules/tools/metadata/main.nf" 
include {cellranger_mkgtf} from "../../tools/cellranger/main.nf" addParams(options: params.cellranger_mkgtf_options)
include {cellranger_mkref} from "../../tools/cellranger/main.nf" addParams(options: params.cellranger_mkref_options)
include {cellranger_count} from "../../tools/cellranger/main.nf" addParams(options: params.cellranger_count_options)

// Define workflow to subset and index a genome region fasta file
workflow scRNAseq_alignment_cellranger {
    take:
        fasta
        gtf
        sample_csv

    main:

        // Enumerate samples from sample csv
        tenx_fastq_metadata(sample_csv)

        // Filter GTF based on gene biotypes passed in params.modules
        cellranger_mkgtf( gtf )

        // Make reference genome
        cellranger_mkref( cellranger_mkgtf.out, fasta )

        // Obtain read counts
        cellranger_count( tenx_fastq_metadata.out, cellranger_mkref.out.collect() )

    emit:
        read_counts = cellranger_count.out.read_counts
        cellranger_out = cellranger_count.out.cellranger_out
}