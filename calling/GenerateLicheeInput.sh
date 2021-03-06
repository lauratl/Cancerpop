#!/bin/sh
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mail-user lauratomaslopezslurm@gmail.com
#SBATCH --mail-type FAIL
#SBATCH --cpus-per-task 1
#SBATCH -t 00:10:00
#SBATCH --mem 30G
#SBATCH -p shared
#SBATCH --qos shared

#usage GenerateLicheeInput.sh <Config file> [<depth threshold>]
# Reading config

source ReadConfig.sh $1

# Loading modules


# Selecting samples



HEALTHY=`head -1 ${WORKDIR}/${CONTROL}`

# Commands


# Depth filtering threshold (default 0)

depth=$2
if [ -z "$depth" ]; then
depth=0
fi



grep -v '^##' ${WORKDIR}/${PATIENT}.vcf | awk -v healthy=$HEALTHY -v depththreshold=$depth 'BEGIN{printf "#chr\tposition\tdescription\tprofile\t"}{if(NR==1){for(i=10;i<=NF;i++){if($i==healthy){idx_healthy=i}};printf $idx_healthy;for(i=10;i<=NF;i++){if(i!=idx_healthy){printf "\t"$i}}printf "\n"}else{pass=1; for(i=10;i<=NF;i++){if(i!=idx_healthy){split($i,a,":");if(a[4]<depththreshold){pass=0}}}if($7=="PASS" && $1!="MT" && pass==1){profile="0";for(i=10;i<=NF;i++){if(i!=idx_healthy){split($i,b,":");split(b[2],c,",");if(c[2]>0){result="1"}else{result="0"};profile=profile""result}};split($idx_healthy,a,":");split(a[3],vafs,",");split($5,altalleles,",");printf $1"\t"$2"\t"$4"/"altalleles[1]"\t"profile"\t"vafs[1]; for(i=10;i<=NF;i++){if(i!=idx_healthy){split($i,a,":");split(a[3],vafs,",");printf "\t"vafs[1]}}printf "\n"}}}' > ${WORKDIR}/${PATIENT}.LicheeInput.depth${depth}.table








echo "FINISHED"
