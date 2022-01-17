#!/usr/bin/env nextflow

// Activate the DSL2 - always include at beginning of Nextflow script.
nextflow.enable.dsl=2

// Create the channels
//strings_ch = Channel.from('This', 'is', 'a', 'channel')
strings_a = Channel
    .fromPath('input.csv')
    .splitCsv(header:true)


//strings_ch = Channel.fromFilePairs('~/nextflow-workshop/data/SRR*_{1,2}.fastq')

// Inspect a channels contents with the operator .view()
// strings_a.view()
// strings_a
//     .view{row -> "${row.sampleID} - ${row.forward_read} - ${row.reverse_read}"}
// strings_a
//     .view{ row -> tuple(row.sampleId, file(row.forward_read), file(row.reverse_read)) }
strings_a
    .map{ row -> tuple(row.sampleId, file(row.forward_read), file(row.reverse_read)) }
    .view()