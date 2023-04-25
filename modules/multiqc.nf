process MULTIQC {

    publishDir "${params.outdir}/MultiQC", mode: 'copy'

    container 'quay.io/biocontainers/multiqc:1.12--pyhdfd78af_0'

    input:
    path('*')

    output:
    path('*.html'), emit: html
    path("versions.yml"), emit: versions

    script:

    """
        multiqc . 
    cat <<-END_VERSIONS > versions.yml

    "${task.process}":
        multiqc: \$( multiqc --version | sed -e "s/multiqc, version //g" )
    END_VERSIONS
    """	
}


