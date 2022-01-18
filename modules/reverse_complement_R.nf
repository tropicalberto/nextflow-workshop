process reverse_complement {
    label 'low'

    input:
    val(reads)

    output:
    val , emit reverse_comp

    """"
    #!/usr/bin/R
    mapvalues(as.list(strsplit(reads,""))[[1]], from=c('A','G','C','T','U'), to=c('T','C','G','A', 'A'))     
    """
}