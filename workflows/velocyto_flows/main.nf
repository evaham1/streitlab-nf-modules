#!/usr/bin/env nextflow

// Specify DSL2
nextflow.enable.dsl=2

include {tenx_fastq_metadata} from "../../tools/metadata/main.nf"
include {velocyto_samtools; velocyto_run_10x} from "../../tools/velocyto/main.nf"

// Define workflow to subset and index a genome region fasta file
workflow velocyto_cellranger {
    take:
        gtf
        cellranger_out
        
    main:
        // Sort bam
        velocyto_samtools(params.modules['velocyto_samtools'], cellranger_out)

        // Calculate velocity
        velocyto_run_10x(params.modules['velocyto_run_10x'], velocyto_samtools.out.sorted_cellranger_out, gtf)

    emit:
        velocyto_counts = velocyto_run_10x.out.velocyto_counts
}
