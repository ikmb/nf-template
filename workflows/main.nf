include { INPUT_CHECK } from '../modules/input_check'
include { FASTP } from '../modules/fastp'
include { SOFTWARE_VERSIONS } from '../modules/software_versions'
include { MULTIQC } from './../modules/multiqc'
include { CUSTOM_DUMPSOFTWAREVERSIONS } from './../modules/custom/dumpsoftwareversions'

ch_versions = Channel.from([])
multiqc_files = Channel.from([])

workflow MAIN {

	take:
	samplesheet
	
	main:
	INPUT_CHECK(samplesheet)
        FASTP(
            INPUT_CHECK.out.reads
        )

	ch_versions = ch_versions.mix(FASTP.out.version)
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
	qc = MULTIQC.out.report
	
}
