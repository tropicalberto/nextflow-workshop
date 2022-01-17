#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// params.reads = "$launchDir/../../data/*.fq.gz"
params.reads = "$launchDir/../../data/*{1,2}.fq.gz"
params.outdir = "$launchDir/results"

/**
 * Quality control fastq
 */

// reads_ch = Channel
//     .fromPath( params.reads )

reads_ch = Channel
    .fromFilePairs(params.reads, checkIfExists:true)
    .view()

process fastqc {
    container 'quay.io/biocontainers/fastqc:0.11.9--0'

    // publishDir '~/nextflow-workshop/data/output/',mode: 'copy', overwrite: true
    publishDir "$params.outdir/quality-control-$sample/", mode: 'copy', overwrite: true
    // if I add [ pattern: "*.hmtl"  ] it will only output hmtl


    input:
    // file read  
    tuple val(sample), path(read)
    // why val(sample)?

    output:
    path("*_fastqc.{zip,html}") 
    // I could also use [ path("*_fastqc.zip") emit: kskks  ] to emit for further processes

    script:
    """
    fastqc ${read}
    """   
}

workflow{
    fastqc(reads_ch)
}