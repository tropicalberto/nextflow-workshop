#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.reads = "$launchDir/../../data/*{1,2}.fq.gz"

/**
 * Quality control fastq
 */

reads_ch = Channel
    .fromFilePairs( params.reads, checkIfExists:true)
    .view()
    
process fastqc {
    input:
    tuple val(sample), path(read) 
    // why val(sample)

    script:
    """
    fastqc ${read}
    """
}

workflow{
    fastqc(reads_ch)
}