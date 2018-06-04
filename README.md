# run_pilon_batches.sh
Script to run pilon by batches of sequences, develop to avoid out of memory issues.
At the end, the script checks the number of batches and merge them into a corrected assembly.


# Usage

bash run_pilon_batches.sh -t <i>threads</i> -a <i>assembly.fasta</i> -b <i>batchSize</i> -f <i>"--frags file1.bam --frags file2.bam ..."</i>  -o <i>"/path/to/outputDir"</i> -p <i>"/path/to/pilon.jar"</i>


- The script needs a fasta fai file next to the assembly (you can create it using samtools faidx)

- You need to put the quotes around the values for the -f and -p options, for the -f option you can put as any <i>--frags file.bam</i> as desired,

- The bam (sorted and indexed) should be from an alignment against the -a <i>assembly.fasta</i> (cf pilon)

# To implement 

- Add memory setting option (now hard coded to 250 Gb)
- More checks for user input (notably the --frags option)
- Automatically create fasta.fai if not there
- Add a possibility to perform more than one iteration (need to have access to reads and aligner)
