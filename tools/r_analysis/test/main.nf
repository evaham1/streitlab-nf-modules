#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Don't overwrite global params.modules, create a copy instead and use that within the main script.
def modules = params.modules.clone()

include {metadata_enumerate_dir} from "../../metadata/main.nf"
include {r_analysis as r_analysis_1} from '../main.nf' addParams(options: modules['r_analysis_1'])
include {r_analysis as r_analysis_2} from '../main.nf' addParams(options: modules['r_analysis_2'])

workflow {
    metadata_enumerate_dir(params.input)
    metadata_enumerate_dir.out.view()
    r_analysis_1 (metadata_enumerate_dir.out.filter{ it[0].sample_id == 'test' } )
    // r_analysis_2 (r_analysis_1.out)
}