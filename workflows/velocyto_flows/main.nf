#!/usr/bin/env nextflow

// Specify DSL2
nextflow.enable.dsl=2

params.velocyto_samtools_options    = [:]
// params.velocyto_run_10x_options     = [:]
params.velocyto_run_options     = [:]

include {tenx_fastq_metadata} from "../../luslab-nf-modules/tools/metadata/main.nf" 
include {velocyto_samtools} from "../../tools/velocyto/main.nf" addParams(options: params.velocyto_samtools_options)
// include {velocyto_run_10x} from "../../tools/velocyto/main.nf" addParams(options: params.velocyto_run_10x_options)
include {velocyto_run} from "../../tools/velocyto/main.nf" addParams(options: params.velocyto_run_options)

// Define workflow to subset and index a genome region fasta file
workflow velocyto_cellranger {
    take:
        gtf
        barcodes
        bam
        
    main:
        // Sort bam
        velocyto_samtools( bam )

        // Calculate velocity
        // velocyto_run_10x( velocyto_samtools.out.sorted_cellranger_out, gtf )
        velocyto_run( velocyto_samtools.out.bam.combine(barcodes, by: 0), gtf )
        

    emit:
        velocyto_counts = velocyto_run.out.velocyto_counts
}
