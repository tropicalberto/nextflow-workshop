#!/usr/bin/env nextflow

// Activate the DSL2 - always include at beginning of Nextflow script.
nextflow.enable.dsl=2

// Create the channels
//strings_ch = Channel.from('This', 'is', 'a', 'channel')
strings_ch = Channel.fromFilePairs('../../nextflow-workshop/data/ggal_gut_*_{1,2}.fq.gz')
// Option 1
paired_ch = Channel.fromFilePairs('../../data/*{1,2}.fq.gz')
// Option 2
paired_ch = Channel.fromFilePairs('../../data/ggal_gut_{1,2}.fq.gz')


//strings_ch = Channel.fromFilePairs('~/nextflow-workshop/data/SRR*_{1,2}.fastq')

// Inspect a channels contents with the operator .view()
paired_ch.view()