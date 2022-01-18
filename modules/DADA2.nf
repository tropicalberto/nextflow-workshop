process dada2 {
    // publishDir("$params.outdir/dada2/", mode: 'copy', overwrite: true)
    publishDir("outputs", mode: 'copy', overwrite: true)
    // label 'medium'
    cpus 4
    container 'golob/dada2:1.14.1.ub.1804'

    input:
    path(reads)
    path(script)
    // tuple val(sample), path(reads)

    output:
    path('counts_matrix.csv')
    path('dendrogram.png')

    script:
    def reads_arg=reads.join(' ')
    """
    Rscript $script $reads_arg
    """
    // """
    // Rscript "$launchDir/reads2counts.r" results/cutadapt-reads/${reads[0]} results/cutadapt-reads/${reads[1]}
    // """
}