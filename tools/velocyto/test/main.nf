#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include {velocyto_run_10x; velocyto_samtools} from "$baseDir/../main.nf"

Channel
    .fromPath("$baseDir/../../../test_data/velocyto/cellrangerOut_hh*", type: 'dir' )
    .view()
    .set {ch_cellranger_out}
    
// Channel
//     .from(params.gtf)
//     .set {ch_gtf}

// workflow {
//     velocyto_samtools(params.modules['velocyto_samtools'], ch_cellranger_out)
//     velocyto_run_10x(params.modules['velocyto_run_10x'], velocyto_samtools.out.sorted_cellranger_out, ch_gtf)
// }