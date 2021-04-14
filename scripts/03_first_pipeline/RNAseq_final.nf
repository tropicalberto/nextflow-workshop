#!/usr/bin/env nextflow

// This is needed for activating the new DLS2
nextflow.enable.dsl=2


// General parameters
params.datadir = "$launchDir/../../data"
params.outdir = "$launchDir/results"

// Input parameters
params.reads = "${params.datadir}/*{1,2}.fq.gz"
params.genome = "${params.datadir}/Drosophila_melanogaster.BDGP6.dna.fa"
params.gtf = "${params.datadir}/Drosophila_melanogaster.BDGP6.85.sample.gtf"

// Trimmomatic
params.slidingwindow = "SLIDINGWINDOW:4:15"
params.avgqual = "AVGQUAL:30"

// Star
params.threads = 2
params.genomeSAindexNbases = 10
params.lengthreads = 98
params.indexpath = "${params.datadir}/index/"


println """\
      LIST OF PARAMETERS
================================
            GENERAL
Data-folder      : $params.datadir
Results-folder   : $params.outdir
================================
      INPUT & REFERENCES 
Input-files      : $params.reads
Reference genome : $params.genome
GTF-file         : $params.gtf
================================
          TRIMMOMATIC
Sliding window   : $params.slidingwindow
Average quality  : $params.avgqual
================================
             STAR
Length-reads     : $params.lengthreads
SAindexNbases    : $params.genomeSAindexNbases
================================
"""


// Also channels are being created. 
read_pairs_ch = Channel
        .fromFilePairs(params.reads, checkIfExists:true)

genome = file(params.genome)
gtf = file(params.gtf)

include { fastqc as fastqc_raw; fastqc as fastqc_trim } from "${launchDir}/../../modules/fastqc" //addParams(OUTPUT: fastqcOutputFolder)
include { trimmomatic } from "${launchDir}/../../modules/trimmomatic"
include { star_idx; star_alignment } from "${launchDir}/../../modules/star"
include { multiqc } from "${launchDir}/../../modules/multiqc" 

// Running a workflow with the defined processes here.  
workflow {
  // QC on raw reads
  fastqc_raw(read_pairs_ch) 
	
  // Trimming & QC
  trimmomatic(read_pairs_ch)
  fastqc_trim(trimmomatic.out.trim_fq)
	
  // Mapping
  star_idx(genome, gtf)
  star_alignment(trimmomatic.out.trim_fq, star_idx.out.index, gtf)
  
  // Multi QC on all results
  multiqc((fastqc_raw.out.fastqc_out).mix(fastqc_trim.out.fastqc_out).collect())
}