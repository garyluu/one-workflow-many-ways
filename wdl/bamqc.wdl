

workflow BamQC {
    String SAMTOOLS
    File BAMFILE

    call flagstat {
        input : samtools=SAMTOOLS, bamfile=BAMFILE
    }
    call bamqc { 
        input : samtools=SAMTOOLS, bamfile=BAMFILE, xtra_json=flagstat.flagstat_json
    }
    meta {
        author: "Muhammad Lee"
        email: "Muhammad.Lee@oicr.on.ca"
        description: "Implementing bamqc over and over again to get an idea of how easy or hard it is for a beginner to implement a basic workflow in different workflow systems."
    }
}

task flagstat {
    String samtools
    File flagstat_to_json
    File bamfile
    String dollar="$"
    String outfile="flagstat.json"

    command {
        ${samtools} flagstat ${bamfile} | ${flagstat_to_json} > ${outfile}
    }

    output {
        File flagstat_json = "${outfile}"
    }

}

task bamqc {
    String samtools
    File bamqc_pl
    File bamfile
    File bedfile
    String outjson
    String xtra_json

    command {
        eval '${samtools} view ${bamfile} | perl ${bamqc_pl} -r ${bedfile} -j "${xtra_json}" > ${outjson}'
    }
    output {
        File out = "${outjson}"
    }
}

