// Import generic module functions
include { initOptions; saveFiles } from './functions'

def SOFTWARE = 'bwa'

process BWA_INDEX {
    tag "$fasta"
    label 'process_high'
    publishDir "${params.outdir}/${options.publish_dir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename, options, SOFTWARE) }

    container "biocontainers/bwa:v0.7.17_cv1"
    //container "https://depot.galaxyproject.org/singularity/bwa:0.7.17--hed695b0_7"

    conda (params.conda ? "bioconda::bwa=0.7.17" : null)

    input:
    path fasta
    val options

    output:
    path "${fasta}.*", emit: index
    path "*.version.txt", emit: version

    script:
    def ioptions = initOptions(options, SOFTWARE)
    """
    bwa index $ioptions.args $fasta
    echo \$(bwa 2>&1) | sed 's/^.*Version: //; s/Contact:.*\$//' > ${SOFTWARE}.version.txt
    """
}
