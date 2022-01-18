#!/usr/bin/env nextflow
// Runline: ~/nextflow run main.nf -profile docker -bg -with-report

// This is needed for activating the new DLS2
nextflow.enable.dsl=2

// Parameters
params.reads = "$launchDir/../data1/*_R{1,2}.fastq"
params.outdir = "$launchDir/results"

params.forwardprimer = "GTGCCAGCMGCCGCGGTAA"
params.reverseprimer = "GGACTACHVHHHTWTCTAAT"

params.script = "$launchDir/reads2counts.r"
log.info """\
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
Threads          : $params.threads
Length-reads     : $params.lengthreads
SAindexNbases    : $params.genomeSAindexNbases
================================
"""

// Create Channels
raw_reads = Channel
             .fromFilePairs(params.reads, checkIfExists:true)
             .view()
forward_primer = Channel
                    .from(params.forwardprimer)


include { fastqc as fastqc_raw; fastqc as fastqc_trim } from "${launchDir}/../modules/fastqc.nf" //addParams(OUTPUT: fastqcOutputFolder)
include { trimmomatic } from "${launchDir}/../modules/trimmomatic"
include { star_idx; star_alignment } from "${launchDir}/../modules/star"
include { multiqc as multiqc_raw; multiqc as multiqc_trim } from "${launchDir}/../modules/multiqc" 
include { cutadapt } from "${launchDir}/../modules/cutadapt" 
include { dada2 } from "${launchDir}/../modules/DADA2" 

// include { reverse_complement } from "${launchDir}/../modules/reverse_complement" 
// include { reverse_complement } from "${launchDir}/../modules/reverse_complement_R" 

//# Calculate reverse complements
def complements = [ 
            A:'T', T:'A', U:'A', G:'C',
            C:'G', Y:'R', R:'Y', S:'S', 
            W:'W', K:'M', M:'K', B:'V',
            D:'H', H:'D', V:'B', N:'N'
            ]

def fw_rc_primer = params.forwardprimer.collect{ base -> return complements[base] ?: 'X' }.reverse().join()
def rv_rc_primer = params.reverseprimer.collect{ base -> return complements[base] ?: 'X' }.reverse().join()


// Workflow
workflow{
    raw_reads.view()
    // #1 Quality control
    fastqc_raw(raw_reads)
    multiqc_raw(fastqc_raw.out.fastqc_out.collect())

    // // #2 Trimming and filtering
    cutadapt(params.forwardprimer, params.reverseprimer, fw_rc_primer, rv_rc_primer, raw_reads)
    // // #3 Re-evaluate
    fastqc_trim(cutadapt.out.trim_fq)
    multiqc_trim(fastqc_trim.out.fastqc_out.collect())
    // // #4 Find unique sequences and plot
    // dada2(cutadapt.out.trim_fq, 'reads2counts.R')
    dada2(cutadapt.out.trim_fq.collect{x -> x[1]}, params.script)

    // // #5 Rinse and repeat


}


workflow.onComplete {
    println "Pipeline completed at: $workflow.complete"
    println "Time to complete workflow execution: $workflow.duration"
    println "Execution status: ${workflow.success ? 'Succesful' : 'Failed' }"
}

workflow.onError {
    println "Oops... Pipeline execution stopped with the following message: $workflow.errorMessage"
}