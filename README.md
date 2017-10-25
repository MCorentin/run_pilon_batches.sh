# run_pilon_batches.sh
Script to run pilon by batches of contigs (to avoid out of memory issues)


# Usage

bash /home/corentin/git_scripts/run_pilon_batches/run_pilon_batches.sh -t <i>threads</i> -a <i>assembly.fasta</i> -b <i>batchSize</i> -f <i>"--frags file2.bam --frags file1.bam"</i> -p <i>/path/to/pilon.jar</i>


1- The script needs a fasta fai file next to the assembly (you can create it using samtools faidx)
2- You need to put the quotes around the values for the -f and -p options


# To implement 

- More checks for user input
- Merge fasta at the end to get the corrected assembly
- Add output directory option
