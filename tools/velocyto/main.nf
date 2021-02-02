#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
def options    = initOptions(params.options)

process velocyto_run_10x {

    label "min_cores"
    label "max_mem"

    publishDir "${params.outdir}",
        mode: 'copy',
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:'') }
    
    container "quay.io/biocontainers/velocyto.py:0.17.17--py37h97743b1_2"

    input:
        tuple val(meta), path(reads)
        path gtf

    output:
        tuple val(meta), path("*.loom"), emit: velocyto_counts

    script:
        prefix = meta.run ? "${meta.sample_name}_${meta.run}" : "${meta.sample_name}"

        velocyto_command = "velocyto run10x ${options.args} ${reads} ${gtf}"

        if (params.verbose){
            println ("[MODULE] velocyto/run_10x command: " + velocyto_command)
        }

        """
        ${velocyto_command}
        mv ${prefix}/velocyto/${prefix}.loom ./
        """
}

process velocyto_samtools {

    label "high_cores"
    label "avg_mem"

    publishDir "${params.outdir}",
        mode: 'copy',
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:'') }
    
    container "quay.io/biocontainers/samtools:1.10--h2e538c0_3"

    input:
        tuple val(meta), path(bam)

    output:
        tuple val(meta), path('*.bam'), emit: bam

    script:
        prefix = meta.run ? "${meta.sample_name}_${meta.run}" : "${meta.sample_name}"

        velocyto_samtools_command = "samtools sort -t CB -O BAM -@ ${task.cpus} -o possorted_genome_bam.bam ${bam}"

        if (params.verbose){
            println ("[MODULE] velocyto/samtools command: " + velocyto_samtools_command)
        }

        """
        ${velocyto_samtools_command}
        """
}


process velocyto_run {

    label "min_cores"
    label "max_mem"

    publishDir "${params.outdir}",
        mode: 'copy',
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:'') }
    
    container "quay.io/biocontainers/velocyto.py:0.17.17--py37h97743b1_2"

    input:
        tuple val(meta), path(bam), path(barcodes)
        path gtf

    output:
        tuple val(meta), path("*.loom"), emit: velocyto_counts

    script:
        prefix = meta.run ? "${meta.sample_name}_${meta.run}" : "${meta.sample_name}"

        velocyto_command = "velocyto run -b ${barcodes} -o ./ ${options.args} ${bam} ${gtf}"

        if (params.verbose){
            println ("[MODULE] velocyto/run_10x command: " + velocyto_command)
        }

        """
        ${velocyto_command}
        """
}



