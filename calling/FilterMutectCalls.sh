#!/bin/sh
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mail-user lauratomaslopez@gmail.com
#SBATCH --mail-type FAIL
#SBATCH --cpus-per-task 1
#SBATCH -t 00:05:00
#SBATCH --mem 10G
#SBATCH -p thin-shared,cola-corta

# Chr1 ~40x 57% 10hours
# Change to 30h and from shared_short to thin-shared
# Change to 40h
# Change to 50h for chr1 and 2 CRC02

# Reading config

source ReadConfig.sh $1

# Loading modules

module load jdk/8u181
GATK=/mnt/netapp1/posadalab/APPS/gatk-4.1.1.0/gatk


# Selecting samples


CHR=$(sed "${SLURM_ARRAY_TASK_ID}q;d" ${RESDIR}/${REF}.chrs) # We select the chromosome using the job array task id variable
HEALTHY=`head -1 ${WORKDIR}/${CONTROL}`
SAMPLES=$( diff ${WORKDIR}/${SAMPLELIST} ${WORKDIR}/${CONTROL} | grep '^<' | cut -d " " -f2 | awk -v healthyname=${HEALTHY} -v chr=${CHR} -v dir=$WORKDIR 'BEGIN{printf "-I "dir"/"healthyname".recal.bam "}{printf "-I "dir"/"$0".recal.bam "}' | tr '\n' ' ') #We select all the samples to pass them to MultiSNV






HEALTHY=`head -1 ${WORKDIR}/${CONTROL}`

# Commands

GERMRES=${RESDIR}/af-only-gnomad.raw.sites.b37.vcf.gz


echo "Starting the filtering!"

# Filtering

CONTABLES=$( diff ${WORKDIR}/${SAMPLELIST} ${WORKDIR}/${CONTROL} | grep '^<' | cut -d " " -f2 | awk -v healthyname=${HEALTHY} -v chr=${CHR} -v dir=$WORKDIR '{printf "-contamination-table "dir"/"$0".recal.bam_calculatecontamination.GATK-4.1.1.0.table "}' | tr '\n' ' ') 

$GATK FilterMutectCalls \
        -V ${WORKDIR}/Mutect2_mseq.${CHR}.${PATIENT}.vcf \
        -O ${WORKDIR}/Mutect2_mseq.${CHR}.${PATIENT}.filtered.vcf \
        -R ${RESDIR}/${REF}.fasta \
	$CONTABLES \
        --stats ${WORKDIR}/Mutect2_mseq.${CHR}.${PATIENT}.vcf.stats


echo "FINISHED"
