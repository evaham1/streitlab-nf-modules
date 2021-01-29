#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Don't overwrite global params.modules, create a copy instead and use that within the main script.
def modules = params.modules.clone()

//  include modules
include { gtf_tag_chroms } from '../../tools/genome_tools/main.nf'           addParams(  options: modules['gtf_tag_chroms'] )

//  include cellranger and velocyto subworkflows
include { scRNAseq_alignment_cellranger } from '../cellranger_flows/main.nf' addParams(  cellranger_mkgtf: modules['cellranger_mkgtf'],
                                                                                            cellranger_mkref: modules['cellranger_mkref'],
                                                                                            cellranger_count: modules['cellranger_count'] )

include { velocyto_cellranger } from '../velocyto_flows/main.nf'             addParams(  velocyto_samtools: modules['velocyto_samtools'],
                                                                                            velocyto_run_10x: modules['velocyto_run_10x'] )

Channel
    .from(params.gtf)
    .set {ch_gtf}

Channel
    .from(params.fasta)
    .set {ch_fasta}

workflow {
    gtf_tag_chroms( ch_gtf )
    scRNAseq_alignment_cellranger( ch_fasta, gtf_tag_chroms.out.gtf, params.samplesheet )
    velocyto_cellranger( gtf_tag_chroms.out.gtf, scRNAseq_alignment_cellranger.out.cellranger_out )
}