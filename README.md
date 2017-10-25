# run_pilon_batches.sh
Script to run pilon by batches of contigs (to avoid out of memory issues)


# Usage

bash run_pilon_batches.sh -t <i>threads</i> -a <i>assembly.fasta</i> -b <i>batchSize</i> -f <i>"--frags file1.bam --frags file2.bam ..."</i> -p "<i>/path/to/pilon.jar</i>"


- The script needs a fasta fai file next to the assembly (you can create it using samtools faidx)

- You need to put the quotes around the values for the -f and -p options, for the -f option you can put as any <i>--frags file.bam</i> as needed,

- The bam (sorted and indexed) should be from an alignment against the -a <i>assembly.fasta</i> (cf pilon)

# To implement 

- More checks for user input
- Add output directory option
