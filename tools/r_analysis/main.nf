#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
def options    = initOptions(params.options)

process r_analysis {

    publishDir "${params.outdir}",
        mode: 'copy',
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:'') }

    container "rocker/tidyverse:3.6.3"

    input:
        path 'input/*'

    output:
        file '*'

    script:

        """
        Rscript ${options.script} --cores ${task.cpus} --runtype nextflow ${options.args}
        rm -r input
        """
}