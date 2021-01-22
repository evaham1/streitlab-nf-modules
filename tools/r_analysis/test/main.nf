#!/usr/bin/env nextflow

// Define DSL2
nextflow.enable.dsl=2

/*------------------------------------------------------------------------------------*/
/* Module inclusions 
--------------------------------------------------------------------------------------*/

include {r_analysis as test1; r_analysis as test2} from '../main.nf'


// Define test data channel
Channel.value(file("$baseDir/../../../test_data/misc/test.txt"))
       .set {ch_test}

workflow {
    test1 (params.modules['test1'], ch_test)

    test2 (params.modules['test2'], test1.out)

}