#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.reads = "$launchDir/../../data/*.fq.gz"
// params.reads = "$launchDir/../../data/*{1,2}.fq.gz"

/**
 * Quality control fastq
 */

reads_ch = Channel
    .fromPath( params.reads, checkIfExists: true )

// reads_ch = Channel
//     .fromFilePairs(params.reads)
//     .view()

process fastqc {
    container 'quay.io/biocontainers/fastqc:0.11.9--0'

    input:
    file read

    script:
    """
    fastqc ${read}
    """
}

workflow{
    fastqc(reads_ch)
}