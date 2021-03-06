#!/bin/sh
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mail-user lauratomaslopezslurm@gmail.com
#SBATCH --mail-type FAIL
#SBATCH --cpus-per-task 1
#SBATCH -t 5:00:00
#SBATCH --mem 30G
#SBATCH -p shared
#SBATCH --qos shared


# Reading config

source ReadConfig.sh $1


# Loading modules

module load gcc/6.4.0 ascatngs/4.2.1 R/3.6.0


# Selecting samples


TUMOR=$(diff ${WORKDIR}/${SAMPLELIST} ${WORKDIR}/${CONTROL} | grep '^<' | cut -d " " -f2|sed "${SLURM_ARRAY_TASK_ID}q;d")
HEALTHY=`head -1 ${WORKDIR}/${CONTROL}`


# Commands

SNPGC=AscatNgsSnpCorrections.tsv
GENDER=XX
mkdir -p ${WORKDIR}/AscatNGS/${TUMOR}


time(

ascat.pl \
    -outdir ${WORKDIR}/AscatNGS/${TUMOR} \
    -tumour ${WORKDIR}/${TUMOR}.recal.bam \
    -normal ${WORKDIR}/${HEALTHY}.recal.bam \
    -reference ${RESDIR}/${REF}.fasta \
    -snp_gc ${RESDIR}/${SNPGC} \
    -protocol WGS \
    -gender ${GENDER} \
    -platform ILLUMINA \
    -species Human \
    -cpus 1 \
    -assembly b37 \
    -genderChr Y

)


echo "FINISHED"
