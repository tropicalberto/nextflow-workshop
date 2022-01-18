process cutadapt{
    publishDir "$params.outdir/cutadapt-reads", mode: 'copy' , overwrite: true
    label 'medium'
    container 'quay.io/biocontainers/cutadapt:3.5--py36hc5360cc_0'

    input:
    val(fw_primer)
    val(rv_primer)
    val(fw_rc_primer)
    val(rv_rc_primer)
    tuple val(sample), path(reads) 

    output:
    tuple val("${sample}"), path("${sample}*_TRIMMED.FASTQ"), emit: trim_fq
    
    """
    cutadapt -a ^${fw_primer}...${fw_rc_primer} \\
            -A ^${rv_primer}...${rv_rc_primer} \\
            --quality-cutoff 28 \\
            --max-n 0 \\
            --minimum-length 30 \\
            --output ${sample}_R1_TRIMMED.FASTQ --paired-output ${sample}_R2_TRIMMED.FASTQ \\
            ${reads[0]} ${reads[1]}
    """

}