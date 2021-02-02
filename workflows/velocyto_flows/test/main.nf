#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Don't overwrite global params.modules, create a copy instead and use that within the main script.
def modules = params.modules.clone()

//  include whole alignment workflow
include { velocyto_cellranger } from '../main.nf' addParams( velocyto_samtools_options: modules['velocyto_samtools'],
                                                                                // velocyto_run_10x_options: modules['velocyto_run_10x'],
                                                                                velocyto_run_options: modules['velocyto_run'] )



test_data_barcodes = [
    [[sample_id:"sample1"], params.barcodes],
]

test_data_bam = [
    [[sample_id:"sample1"], params.bam],
]

Channel
    .from(test_data_barcodes)
    .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
    .set {ch_barcodes}

Channel
    .from(test_data_bam)
    .map { row -> [ row[0], file(row[1], checkIfExists: true) ] }
    .set {ch_bam}

Channel
    .value(file(params.gtf, checkIfExists: true))
    .set {ch_gtf}


workflow {
    velocyto_cellranger( ch_gtf, ch_barcodes, ch_bam )
}