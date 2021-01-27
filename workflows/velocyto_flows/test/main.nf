#!/usr/bin/env nextflow

nextflow.enable.dsl=2

//  include cellranger workflow
include {cellranger_alignment} from "$baseDir/../../../workflows/cellranger_flows/main.nf"
include {velocyto_cellranger} from "$baseDir/../../../workflows/velocyto_flows/main.nf"

Channel
    .from(params.gtf)
    .set {ch_gtf}

Channel
    .from(params.fasta)
    .set {ch_fasta}

workflow {
    cellranger_alignment(ch_fasta, ch_gtf, params.samplesheet)
    velocyto_cellranger(ch_gtf, cellranger_alignment.out.cellranger_out)
}