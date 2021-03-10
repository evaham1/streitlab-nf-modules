#!/usr/bin/env nextflow

// Import groovy libs
import groovy.transform.Synchronized

// Specify DSL2
nextflow.enable.dsl=2


workflow tenx_metadata {
    take: file_path
    main:
        Channel
            .fromPath( file_path )
            .splitCsv(header:true)
            .map { row -> tenxProcessRow(row) }
            .set { metadata }
    emit:
        metadata
}


def tenxProcessRow(LinkedHashMap row, boolean flattenData = false) {
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
    array = [ meta, file(row.data, checkIfExists: true) ]

    return array
}