#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// Create channel
fifo = Channel.from(1,2,3,4,5,6,7,8,9,10)

// Define the process
process whosfirst {

    input:
    val x 

    // Using the native execution instead of the more common 'script':
    exec:
    println "This is job number $x"
}

workflow {
    // call the process as a function with channel as its input
    whosfirst(fifo)
}

// output is shown at random
// (nextflow didnt take into consideration the sequencial data)