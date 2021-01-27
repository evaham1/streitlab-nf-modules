#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include {cellranger_alignment} from "$baseDir/../../../workflows/cellranger_flows/main.nf"
include {velocyto_samtools; velocyto_run_10x} from "$baseDir/../main.nf"


Channel
    .from(params.gtf)
    .set {ch_gtf}

Channel
    .from(params.fasta)
    .set {ch_fasta}


workflow {

    cellranger_alignment(ch_fasta, ch_gtf, "$baseDir/../../../test_data/cellranger/sample_info.csv")

    // velocyto_run(params.modules['velocyto_run'], ch_velocyto, ch_gtf)
    velocyto_samtools(params.modules['velocyto_samtools'], cellranger_alignment.out.cellranger_out)

    velocyto_run_10x(params.modules['velocyto_run_10x'], velocyto_samtools.out, ch_gtf)
}