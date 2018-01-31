task spades {
    String outputDir
    String? preCommand
    File? read1
    File? read2
    File? singleRead
    File? interlacedReads
    File? sangerReads
    File? pacbioReads
    File? nanoporeReads
    File? tslrContigs
    File? trustedContigs
    File? untrustedContigs
    Boolean? singleCell
    Boolean? metagenomic
    Boolean? rna
    Boolean? plasmid
    Boolean? ionTorrent
    Boolean? onlyErrorCorrection
    Boolean? onlyAssembler
    Boolean? careful
    Boolean? disableGzipOutput
    Boolean? disableRepeatResolution
    File? dataset
    Int? threads = 1
    Int? memoryGb = 4
    File? tmpDir
    String? k
    Float? covCutoff
    Int? phredOffset

    command {
        set -e -o pipefail
        ${preCommand}
        spades.py \
        ${"-o " + outputDir} \
        ${true="--sc" false="" singleCell} \
        ${true="--meta" false="" metagenomic} \
        ${true="--rna" false="" rna} \
        ${true="--plasmid" false="" plasmid} \
        ${true="--iontorrent" false="" ionTorrent} \
        ${"--12 " + interlacedReads }
        ${"--threads " + threads } \
        ${"-1 " + read1 } \
        ${"-2 " + read2 } \
        ${"-s " + singleRead } \
        ${"--sanger " + sangerReads } \
        ${"--pacbio " + pacbioReads } \
        ${"--nanopore " + nanoporeReads } \
        ${"--tslr " + tslrContigs } \
        ${"--trusted-contigs " + trustedContigs } \
        ${"--untrusted-contigs" + untrustedContigs } \
        ${true="--only-error-correction" false="" onlyErrorCorrection } \
        ${true="--only-assembler" false="" onlyAssembler } \
        ${true="--careful" false="" careful } \
        ${true="--disable-gzip-output" false="" disableGzipOutput} \
        ${true="--disable-rr" false="" disableRepeatResolution } \
        ${"--dataset " + dataset } \
        ${"--threads " + threads } \
        ${"--memory " + memoryGb } \
        ${"-k " + k } \
        ${"--cov-cutoff " + covCutoff } \
        ${"--phred-offset " + phredOffset }
    }
    output {
        Array[File] correctedReads = glob(outputDir + "/corrected/*.fastq*")
        File scaffolds = outputDir + "/scaffolds.fasta"
        File contigs = outputDir + "/contigs.fasta"
        File assemblyGraphGfa = outputDir + "/assembly_graph.gfa"
        File assemblyGraphFastg = outputDir + "/assembly_graph.fastq"
        File contigsPaths = outputDir + "/contigs.paths"
        File scaffoldsPaths = outputDir + "/scaffolds.paths"
        File params = outputDir + "/params.txt"
        File log = outputDir + "/spades/log"
    }
    runtime {
        cpu: select_first([threads])
        memory: select_first([memoryGb]) + "G"
    }
}