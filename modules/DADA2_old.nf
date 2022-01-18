process dada2 {
    // publishDir("$params.outdir/dada2/", mode: 'copy', overwrite: true)
    publishDir("outputs", mode: 'copy', overwrite: true)
    // label 'medium'
    cpus 4
    container 'golob/dada2:1.14.1.ub.1804'

    input:
    // path(reads)
    // path(script)
    tuple val(sample), path(reads)

    output:
    path('counts_matrix.csv')
    path('dendrogram.png')

    script:
    // def reads_arg=reads.join(' ')
    // """
    // Rscript $script $reads_arg
    // """
    """
    Rscript "$launchDir/reads2counts.r" results/cutadapt-reads/${reads[0]} results/cutadapt-reads/${reads[1]}
    """
}
// Why doesn't this work? 
//    Not a valid path value: reads2counts.R

// Command executed:

//   Rscript "reads2counts.r" results/cutadapt-reads/DC01_R1_TRIMMED.FASTQ results/cutadapt-reads/DC01_R2_TRIMMED.FASTQ

// Command exit status:
//   2

// Command output:
//   Fatal error: cannot open file 'reads2counts.r': No such file or directory

// Command executed:

//   Rscript "/Users/a.gil.jimenez/nextflow-workshop/project/reads2counts.r" results/cutadapt-reads/DC03_R1_TRIMMED.FASTQ results/cutadapt-reads/DC03_R2_TRIMMED.FASTQ

// Command exit status:
//   2

// a.gil.jimenez@MB0294~> ls /Users/a.gil.jimenez/nextflow-workshop/project/reads2counts.r
// /Users/a.gil.jimenez/nextflow-workshop/project/reads2counts.r
// a.gil.jimenez@MB0294~> 
