process MULTIQC {

   container 'quay.io/biocontainers/multiqc:1.12--pyhdfd78af_0'

   input:
   path('*')

   output:
   path('*.html'), emit: html

   script:

   """
      multiqc . 
   """	

}


