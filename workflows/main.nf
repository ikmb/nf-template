// DEV: rename this file to something matching this workflow, e.g. exome.nf

include { INPUT_CHECK } from '../modules/input_check'
include { FASTP } from '../modules/fastp/main'
include { SOFTWARE_VERSIONS } from '../modules/software_versions'
include { MULTIQC } from './../modules/multiqc/main'
include { CUSTOM_DUMPSOFTWAREVERSIONS } from './../modules/custom/dumpsoftwareversions'

ch_versions = Channel.from([])
multiqc_files = Channel.from([])

// DEV: Rename block to something matching this workflow, e.g. EXOME
workflow MAIN {

    take:
    samplesheet
	
    main:

    // DEV: Make sure this module is compatible with the samplesheet format you create
    INPUT_CHECK(samplesheet)
	
    FASTP(
        INPUT_CHECK.out.reads
    )

    ch_versions = ch_versions.mix(FASTP.out.versions)
    multiqc_files = multiqc_files.mix(FASTP.out.json)

    SOFTWARE_VERSIONS(
        ch_versions.collect()
    )		
	
    CUSTOM_DUMPSOFTWAREVERSIONS (
        ch_versions.unique().collectFile(name: 'collated_versions.yml')
    )
	
    multiqc_files = multiqc_files.mix(CUSTOM_DUMPSOFTWAREVERSIONS.out.mqc_yml)

    MULTIQC(
        multiqc_files.collect()
    )

    emit:
    qc = MULTIQC.out.html
	
}
