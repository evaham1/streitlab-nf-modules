#!/usr/bin/env nextflow
nextflow.enable.dsl=2

include {modify_gtf} from "$baseDir/../main.nf"
params.gtf = "$baseDir/../../../test_data/modify_gtf/test.gtf"

Channel
    .from(params.gtf)
    .set {ch_gtf}
    
workflow {
    modify_gtf(params.modules['modify_gtf'], ch_gtf)
}