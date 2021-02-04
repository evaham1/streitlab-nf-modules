#!/usr/bin/env nextflow

nextflow.enable.dsl=2

// Don't overwrite global params.modules, create a copy instead and use that within the main script.
def modules = params.modules.clone()

include {r_analysis as r_analysis_1} from '../main.nf' addParams(options: modules['r_analysis_1'])
include {r_analysis as r_analysis_2} from '../main.nf' addParams(options: modules['r_analysis_2'])

// Define test data channel
Channel.value(file("../../../test_data/misc/test.txt"))
       .set {ch_test}

workflow {
    r_analysis_1 (ch_test)
    r_analysis_2 (r_analysis_1.out)
}