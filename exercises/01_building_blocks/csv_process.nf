#!/usr/bin/env nextflow


// Create the channels
csv_ch = Channel
    .fromPath('input.csv')
    .splitCsv(header:true)      
    .map{ row -> tuple(row.sampleId, tuple(file(row.forward_read), file(row.reverse_read)))}
    .vie


// Create the channels
csv_ch = Channel
    .fromPath('input.csv')
    .splitCsv(header:true)      
    .map{ row -> tuple(row.sampleId, 
                    tuple(file(row.forward_read), file(row.reverse_read)))}
    .view()