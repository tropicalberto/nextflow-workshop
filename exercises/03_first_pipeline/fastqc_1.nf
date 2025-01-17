#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// params.reads = "$launchDir/../../data/*.fq.gz"
params.reads = "$launchDir/../../data/*{1,2}.fq.gz"

/**
 * Quality control fastq
 */

// reads_ch = Channel
//     .fromPath( params.reads )

reads_ch = Channel
    .fromFilePairs(params.reads)
    .view()

process fastqc {
    container 'quay.io/biocontainers/fastqc:0.11.9--0'

    input:
    // file read  
    tuple val(sample), path(read)
    // why val(sample)?

    script:
    """
    fastqc ${read}
    """
}

workflow{
    fastqc(reads_ch)
}