#!/bin/bash

# This script runs pilon in batches of sequences.
# Motivation: running pilon on a whole assembly can produce out of memory errors + it is faster to do it by batches.

# Input: same as pilon, a fasta file and bam files (reads aligned to the assembly)m it also needs the fasta index (.fai) to get the scaffolds IDs (then uses pilon --targets option to launch pilon on these Ids)
# Output is one folder for each batch, then all the fasta are merged into a corrected version of the assembly.


# TO ADD :
#	- create fata fai if not already there
#	- add checks for frags + heck if bams are indexed
#	- add option for java memory
#


# Default values
batchSize=100
threads=20
nostray="F"
outputDir="./"


function usage {
        echo "USAGE run_pilon_batches.sh -t [Threads] -a [Assembly fasta] -b [Batch size] -f [--frags align.bam] -o [Output directory] -p [pilon.jar] -n"
        echo "  -h Print this help message"
        echo "  -t Number of threads to use (default: 20)"
        echo "  -a Assembly in fasta format (required)"
        echo "  -b batch size: how many sequences to process per pilon run (default: 100)"
        echo "  -f indicate the bam files location, format : '--frags /path/to/file1.bam --frags /path/to/file2.bam' (required + the bams must be indexed !)"
	echo "	-o output directory (default: current directory)"
	echo "  -p path to pilon jar file (required)"
	echo "	-n use nostray with pilon, this skip the identification of stray pairs but decrease memory usage"
}


# This method generate the pilon command for one batch and runs it
function do_batch {
	batchNumber=$((${batchNumber}+1))

	# To avoid having a comma at the beginning (and avoid pilon throwing an error)
	batch=$(echo ${batch} | sed 's/^,//')

	if [ ${nostray} == "T" ]; then
		cmd="java -jar -Xmx250G ${pilonJar} --nostrays"
	else
		cmd="java -jar -Xmx250G ${pilonJar}"
	fi

	cmd="${cmd} --genome ${assemblyFasta} ${FRAGS} --output pilon_on_batch${batchNumber} --outdir ${outputDir}/pilon_on_batch${batchNumber}/ --changes --fix all --threads ${threads} --targets '${batch}' >  ${outputDir}/pilon_on_batch${batchNumber}.log"
	echo ${cmd}
	eval ${cmd}

	batch=""
	count=0

	echo "BATCH ${batchNumber} Done !"
	echo ""
}


while getopts ht:a:b:f:o:p:n opt; do
        case ${opt} in
                h)
                        usage
			exit 1
                ;;
                t)
                        threads=${OPTARG}
                ;;
                a)
                        assemblyFasta=${OPTARG}
                ;;
                b)
                        batchSize=${OPTARG}
                ;;
                f)
                        FRAGS=${OPTARG}
		;;
		o)
			outputDir=${OPTARG}
		;;
		p)
			pilonJar=${OPTARG}
                ;;
		n)
			nostray="T"
		;;
                \?)
                        echo "Invalid option: -${OPTARG}"
                        exit 1
                ;;
                :)
                        echo "Option -${OPTARG} requires an argument"
                        exit 1
                ;;
        esac
done

# Check user input
if [ ! -r ${assemblyFasta} ]; then
	echo ""
	echo "Cannot read the Assembly fasta file: ${assemblyFasta}"
	echo ""
	usage
	exit 1
fi

fastaFaiFile=${assemblyFasta}".fai"
if [ ! -r ${fastaFaiFile} ]; then
	echo ""
	echo "Cannot read the fasta.fai file, it must be next to the fasta file and have the same name: ${fastaFaiFile}"
	echo ""
	usage
	exit 1
fi


if [ ! -w ${outputDir} ]; then
	echo ""
	echo "Cannot write to output directory : \"${outputDir}\" ! Please check your permissions"
	echo ""
	usage
	exit 1
fi

##### Add tests for other inputs (--frags etc... + check if bam.bai exists)




# Variable for each Batch
count=0
batch=""
batchNumber=0

# Get the list of scaffolds names (fasta fai first column)
scaffoldIDs=`cut -f 1 ${fastaFaiFile}`

for ID in ${scaffoldIDs}; do

	count=$((${count}+1))

	batch="${batch},${ID}"

	# Launch Pilon every "batchSize" IDs
	if [ ${count} -ge ${batchSize} ]; then
		do_batch
	fi

done

echo "FINAL BATCH"
# The last batch for the Ids left (not useful if number of scaffolds is modulo the batch size)
if [ "$batch" != "" ]; then
	do_batch
fi


echo "All the batches have been processed"
echo ""
echo "Merging ${NbPilonFasta} fasta files..."

# Merge fasta here
NbPilonFasta=$(find ${outputDir}/pilon_on_batch* -maxdepth 1 -name "*.fasta" | wc -l)
if [ ${NbPilonFasta} -eq ${batchNumber} ]; then
	prefix="pilon_corrected_assembly"
	cat ${outputDir}/pilon_on_batch*/*.fasta > ${outputDir}/${prefix}.fasta
	echo "Done, the corrected assembly is: ${outputDir}/${prefix}.fasta"
else
	echo "Wrong number of fasta!"
	echo "Pilon should have created ${batchNumber} fasta, we found ${NbPilonFasta} fasta..."
	exit 1
fi

exit 0
