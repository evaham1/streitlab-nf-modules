#!/usr/bin/env nextflow

// Import groovy libs
import groovy.transform.Synchronized

// Specify DSL2
nextflow.enable.dsl=2


workflow metadata_enumerate_files {
    take: file_path
    main:
        Channel
            .fromPath( file_path )
            .splitCsv(header:true)
            .map { row -> ProcessRowFiles(row) }
            .set { metadata }
    emit:
        metadata
}

workflow metadata_enumerate_dir {
    take: file_path
    main:
        Channel
            .fromPath( file_path )
            .splitCsv(header:true)
            .map { row -> ProcessRowDir(row) }
            .set { metadata }
    emit:
        metadata
}


def ProcessRowFiles(LinkedHashMap row, boolean flattenData = false) {
    def meta = [:]
    meta.sample_id = row.sample_id

    for (Map.Entry<String, ArrayList<String>> entry : row.entrySet()) {
        String key = entry.getKey();
        String value = entry.getValue();
    
        if(key != "sample_id" && key != "data") {
            meta.put(key, value)
        }
    }

    def array = []
    array = [ meta, file(row.data, checkIfExists: true) ] //read in list of files into an array

    return array
}

def ProcessRowDir(LinkedHashMap row, boolean flattenData = false) {
    def meta = [:]
    meta.sample_id = row.sample_id

    for (Map.Entry<String, ArrayList<String>> entry : row.entrySet()) {
        String key = entry.getKey();
        String value = entry.getValue();
    
        if(key != "sample_id" && key != "data") {
            meta.put(key, value)
        }
    }

    def array = []
    array = [ meta, [ row.data ] ] //read entire dir into an array

    return array
}