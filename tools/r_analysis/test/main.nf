#!/usr/bin/env nextflow

// Define DSL2
nextflow.enable.dsl=2

/*------------------------------------------------------------------------------------*/
/* Module inclusions 
--------------------------------------------------------------------------------------*/

include {r_analysis} from '../main.nf'


// Define test data channel
Channel.value(file("$baseDir/../../../test_data/misc/test.txt"))
       .set {ch_test}

workflow {
    r_analysis (params.modules['r_analysis'], ch_test)
}