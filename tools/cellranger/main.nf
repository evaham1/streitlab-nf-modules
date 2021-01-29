#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
def options    = initOptions(params.options)

println(options.args)

process cellranger_count {

    label 'process_high'
    publishDir "${params.outdir}",
        mode: 'copy',
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process)) }

    container "streitlab/custom-nf-modules-cellranger:latest"

    input:
        tuple val(meta), path(reads)
        path reference_genome

    output:
        tuple val(meta), path("${meta.sample_name}_filtered_feature_bc_matrix"), emit: read_counts
        tuple val(meta), path("cellrangerOut_${meta.sample_name}"), emit: cellranger_out

    script:
        cellranger_count_command = "cellranger count --id='cellrangerOut_${meta.sample_name}' --fastqs='./' --sample=${meta.sample_id} --transcriptome=${reference_genome} ${options.args}"
        
        // Log
        if (params.verbose){
            println ("[MODULE] cellranger count command: " + cellranger_count_command)
        }

       //SHELL
        """
        ${cellranger_count_command}
        mkdir ${meta.sample_name}_filtered_feature_bc_matrix
        cp cellrangerOut_${meta.sample_name}/outs/filtered_feature_bc_matrix/*.gz ${meta.sample_name}_filtered_feature_bc_matrix
        """
}


process cellranger_mkgtf {

    label 'process_med'
    publishDir "${params.outdir}",
        mode: 'copy',
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process)) }

    container "streitlab/custom-nf-modules-cellranger:latest"

    input:
        path(gtf)

    output:
        path("${task.process}.gtf")

    script:
        
        mkgtf_command = "cellranger mkgtf ${gtf} ${task.process}.gtf ${options.args}"
        
        // Log
        if (params.verbose){
            println ("[MODULE] filter gtf command: " + mkgtf_command)
        }

       //SHELL
        """
        ${mkgtf_command}
        """
}

process cellranger_mkref {

    label 'process_high'
    publishDir "${params.outdir}",
        mode: 'copy',
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process)) }

    container "streitlab/custom-nf-modules-cellranger:latest"

    input:
        path(filt_genome)
        path(fasta)

    output:
        path("reference_genome")

    script:
        mkref_command = "cellranger mkref --genome=reference_genome --genes=${filt_genome} --fasta=${fasta} --nthreads=${task.cpus}"
        
        // Log
        if (params.verbose){
            println ("[MODULE] mkref command: " + mkref_command)
        }

        //SHELL
        """
        ${mkref_command}
        """
}
