# run_pilon_batches.sh
Script to run pilon by batches of sequences, developed to avoid out of memory issues.

# Input
Same as pilon, a fasta file and bam files (reads aligned to the assembly).
This script also needs the fasta index (.fai) to get the scaffolds IDs (then uses pilon --targets option to launch pilon on these Ids).

# Output
Output is one folder for each batch, then all the fasta are merged into a corrected version of the assembly.

# Usage

bash run_pilon_batches.sh -t <i>Number of threads</i> -m <i>Memory limit in Gb</i> -a <i>Assembly.fasta</i> -b <i>batch size</i> -f <i>"--frags file1.bam --frags file2.bam ..."</i>  -o <i>"/path/to/outputDir"</i> -p <i>"/path/to/pilon.jar"</i>

         
```
	-h	Print this help message
	-t	Number of threads to use (default: 20)
	-m	Memory limit to use in Gb (default: 250)
	-a	Assembly in fasta format (required)
	-b	Batch size: how many sequences to process per pilon run (default: 100)
	-f	Indicate the bam files location, format : '--frags /path/to/file1.bam --frags /path/to/file2.bam' (required + the bams must be indexed !)
	-o	Output directory (default: current directory)
	-p	Path to pilon jar file (required)
	-n	Use nostray with pilon, this skip the identification of stray pairs but decrease memory usage (optional)
```

# Miscellaneous
- The script needs a fasta index (.fai) next to the assembly.
- You need to put the quotes around the values for the -f and -p options, for the -f option you can put as many <i>--frags file.bam</i> as desired,
- The bam (sorted and indexed) should be from an alignment against the -a <i>assembly.fasta</i> (cf pilon)

# To implement 
- More checks for user input (notably the --frags option) + check if bams are indexed
- Add a possibility to perform more than one iteration (need to have access to reads and aligner)
