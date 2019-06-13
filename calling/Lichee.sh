#!/bin/sh
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mail-user lauratomaslopezslurm@gmail.com
#SBATCH --mail-type FAIL
#SBATCH --cpus-per-task 1
#SBATCH -t 10:00:00
#SBATCH --mem 50G
#SBATCH -p thin-shared,cola-corta


# Reading config

source ReadConfig.sh $1

# Loading modules

module load jdk/8u181

# Selecting samples


# Commands

LICHEE=/mnt/netapp1/posadalab/APPS/lichee/LICHeE/release/
cd $LICHEE
./lichee -build \
	-i ${WORKDIR}/${PATIENT}.LicheeInput.table \
	-sampleProfile \
	-n 0 \
	-o ${WORKDIR}/${PATIENT}.Lichee \
	-v \
	-color \
	-dot  


echo "FINISHED"
