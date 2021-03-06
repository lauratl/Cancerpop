#!/bin/bash
# SNVs calling of Cancerpop WGS data


# Reading configuration file

source ReadConfig.sh $1


# Samples and chromosomes counting

number_samples=`wc -l ${WORKDIR}/${SAMPLELIST} | awk '{print $1}'`    # Total number of samples
number_fastqs=`wc -l ${WORKDIR}/${SAMPLELIST}Full | awk '{print $1}'`    # Number of fastqs (R1 and R2 are one)
nchrs=`cat ${RESDIR}/${REF}.chrs | wc -l`     # Total number of chromosomes
ntumors=`diff ${WORKDIR}/${SAMPLELIST} ${WORKDIR}/${CONTROL} | grep '^<'| wc -l`  # Total number of tumor samples

echo "Analyzing "$number_samples" samples, including $ntumors tumor samples"

njobs_bytumor_bychr=$(( nchrs*ntumors ))   # When splitting by chromosomes for each tumor sample


## Create a folder and put slurm output inside

pipeline_name=`basename $0`

slurm_info=$(echo `date` | awk -v argument=$pipeline_name '{print "Slurm"argument"_"$3"-"$2"-"$6"_"$4}')
mkdir -p ${WORKDIR}/$slurm_info
cd ${WORKDIR}/$slurm_info

echo "Launched at `date`"
echo "Launched at `date`" >> ${WORKDIR}/$slurm_info/README
echo "Sending slurm output to ${WORKDIR}/$slurm_info"
echo "Using Configuration file $1" >> ${WORKDIR}/$slurm_info/README

#### PIPELINE #####

## QUALITY CONTROL AND TRIMMING

#jid0=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/FastQCRaw.sh $1 | awk '{print $4}')
#jid0=$(sbatch --array=9,10 ${SCRIPTDIR}/FastQCRaw.sh $1 | awk '{print $4}')
echo "FastQCRaw.sh Job ID $jid0" | tee -a ${WORKDIR}/$slurm_info/README

#jid1=$(sbatch --array=1-${number_fastqs} ${SCRIPTDIR}/Cutadapt.sh $1 | awk '{print $4}')
#jid1=$(sbatch --array=9-${number_fastqs} -p amd-shared --qos=amd-shared ${SCRIPTDIR}/Cutadapt.sh $1 | awk '{print $4}')
#jid1=$(sbatch --array=9-24 ${SCRIPTDIR}/Cutadapt.sh $1 | awk '{print $4}')
#jid1=$(sbatch --array=9-32 ${SCRIPTDIR}/Cutadapt.sh $1 | awk '{print $4}')
#jid1=$(sbatch --array=1-8 ${SCRIPTDIR}/Cutadapt.sh $1 | awk '{print $4}')
#jid1=$(sbatch --array=1-${number_fastqs} -p amd-shared --qos=amd-shared ${SCRIPTDIR}/Cutadapt.sh $1 | awk '{print $4}')
#jid1=$(sbatch --array=24,25 -t 15:00:00 --mem 50G -p thinnodes ${SCRIPTDIR}/Cutadapt.sh $1 | awk '{print $4}')
#jid1=$(sbatch --array=1 ${SCRIPTDIR}/Cutadapt.sh $1 | awk '{print $4}')
echo "Cutadapt.sh Job ID $jid1" | tee -a ${WORKDIR}/$slurm_info/README

#jid2=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/FastQCTrimmed.sh $1 | awk '{print $4}')
#jid2=$(sbatch --dependency=afterok:$jid1 --array=1-${number_samples} ${SCRIPTDIR}/FastQCTrimmed.sh $1 | awk '{print $4}')
echo "FastQCTrimmed.sh Job ID $jid2" | tee -a ${WORKDIR}/$slurm_info/README

## MAPPING, SORTING AND STATS

#jid3=$(sbatch --array=1-${number_fastqs} ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=9-${number_fastqs} ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=1-8 ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=11-23 ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=23 ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=11 ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --dependency=afterok:$jid1 --array=1-${number_samples} ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=9-16 ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=9-24 ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=9-32 ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=14 -t 10:00:00 ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
#jid3=$(sbatch --array=24,25 -t 15:00:00 --mem 50G -p thinnodes ${SCRIPTDIR}/BWA.sh $1 | awk '{print $4}')
echo "BWA.sh Job ID $jid3"  | tee -a ${WORKDIR}/$slurm_info/README

#jid3b=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/Flagstat.sh $1 | awk '{print $4}')
#jid3b=$(sbatch --dependency=afterok:$jid3 --array=1-${number_samples} ${SCRIPTDIR}/Flagstat.sh $1 | awk '{print $4}')
#jid3b=$(sbatch --array=1,2,3,4,5,6,7,9,10 ${SCRIPTDIR}/Flagstat.sh $1 | awk '{print $4}')
echo "Flagstat.sh Job ID $jid3b" | tee -a ${WORKDIR}/$slurm_info/README

#jid4=$(sbatch --array=1-${number_fastqs} -p shared --qos shared ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=9-${number_fastqs} ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=24,25 -t 20:00:00 ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=9-16 ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=9-24 ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=9-32 ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=1-8 --dependency=afterok:3312026 ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=1-${number_samples} --dependency=afterok:$jid3 ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=1,5 ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=23 ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
#jid4=$(sbatch --array=11 ${SCRIPTDIR}/SortSam.sh $1 | awk '{print $4}')
echo "SortSam.sh Job ID $jid4"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_Genomecov=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/Genomecov.sh $1 | awk '{print $4}')
#jid_Genomecov=$(sbatch --array=8 ${SCRIPTDIR}/Genomecov.sh $1 | awk '{print $4}')
echo "Genomecov.sh Job ID $jid_Genomecov"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_SamtoolsDepth=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/SamtoolsDepth.sh $1 | awk '{print $4}')
#jid_SamtoolsDepth=$(sbatch --array=8 ${SCRIPTDIR}/SamtoolsDepth.sh $1 | awk '{print $4}')
echo "SamtoolsDepth.sh Job ID $jid_SamtoolsDepth"  | tee -a ${WORKDIR}/$slurm_info/README

## REMOVING DUPLICATES AND RECALIBRATING (GATK4)

# for CNAG samples MarkDuplicatesAndMerge.sh

#jid5b=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/MarkDuplicatesAndMerge.sh $1 | awk '{print $4}')
#jid5b=$(sbatch --array=6 ${SCRIPTDIR}/MarkDuplicatesAndMerge.sh $1 | awk '{print $4}')
#jid5b=$(sbatch --array=3,4 ${SCRIPTDIR}/MarkDuplicatesAndMerge.sh $1 | awk '{print $4}')
#jid5b=$(sbatch --array=2,3,4 ${SCRIPTDIR}/MarkDuplicatesAndMerge.sh $1 | awk '{print $4}')
#jid5b=$(sbatch --array=2 ${SCRIPTDIR}/MarkDuplicatesAndMerge.sh $1 | awk '{print $4}')
echo "MarkDuplicatesAndMerge.sh Job ID $jid5b"  | tee -a ${WORKDIR}/$slurm_info/README


#jid5b=$(sbatch --array=1-${number_samples} --dependency=afterok:$jid4 ${SCRIPTDIR}/MarkDuplicates.sh $1 | awk '{print $4}')
#jid5b=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/MarkDuplicates.sh $1 | awk '{print $4}')
#jid5b=$(sbatch --array=1,5,11,12,17,21,13,14,15,16,18,19,20,22,23 ${SCRIPTDIR}/MarkDuplicates.sh $1 | awk '{print $4}')
#jid5b=$(sbatch --array=24,25 ${SCRIPTDIR}/MarkDuplicates.sh $1 | awk '{print $4}')
echo "MarkDuplicates.sh Job ID $jid5b"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_BaseRecalibratorI=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/BaseRecalibratorI.sh $1 | awk '{print $4}')
#jid_BaseRecalibratorI=$(sbatch --array=24,25 ${SCRIPTDIR}/BaseRecalibratorI.sh $1 | awk '{print $4}')
#jid_BaseRecalibratorI=$(sbatch -t 48:00:00 -p amd-shared --qos amd-shared --array=24 ${SCRIPTDIR}/BaseRecalibratorI.sh $1 | awk '{print $4}')
#jid_BaseRecalibratorI=$(sbatch --array=3,4 ${SCRIPTDIR}/BaseRecalibratorI.sh $1 | awk '{print $4}')
#jid_BaseRecalibratorI=$(sbatch --array=2,3,4 ${SCRIPTDIR}/BaseRecalibratorI.sh $1 | awk '{print $4}')
echo "BaseRecalibratorI.sh Job ID $jid_BaseRecalibratorI"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_BaseRecalibratorII=$(sbatch --array=1-${number_samples} --dependency=afterok:$jid_BaseRecalibratorI ${SCRIPTDIR}/BaseRecalibratorII.sh $1 | awk '{print $4}')
#jid_BaseRecalibratorII=$(sbatch --array=24,25 -p amd-shared --qos amd-shared --dependency=afterok:$jid_BaseRecalibratorI ${SCRIPTDIR}/BaseRecalibratorII.sh $1 | awk '{print $4}')
#jid_BaseRecalibratorII=$(sbatch --array=6 ${SCRIPTDIR}/BaseRecalibratorII.sh $1 | awk '{print $4}')
#jid_BaseRecalibratorII=$(sbatch --array=3,4 ${SCRIPTDIR}/BaseRecalibratorII.sh $1 | awk '{print $4}')
#jid_BaseRecalibratorII=$(sbatch --array=3,4 --dependency=afterok:$jid_BaseRecalibratorI ${SCRIPTDIR}/BaseRecalibratorII.sh $1 | awk '{print $4}')
#jid_BaseRecalibratorII=$(sbatch --array=2,3,4 --dependency=afterok:$jid_BaseRecalibratorI ${SCRIPTDIR}/BaseRecalibratorII.sh $1 | awk '{print $4}')
#jid_BaseRecalibratorII=$(sbatch --array=1-${number_samples} ${SCRIPTDIR}/BaseRecalibratorII.sh $1 | awk '{print $4}')
echo "BaseRecalibratorII.sh Job ID $jid_BaseRecalibratorII"  | tee -a ${WORKDIR}/$slurm_info/README


## CONTAMINATION AND CALLING

#jid_HealthyPileup=$(sbatch --array=1 -p amd-shared --qos amd-shared ${SCRIPTDIR}/HealthyPileup.sh $1 | awk '{print $4}')
echo "HealthyPileup.sh Job ID $jid_HealthyPileup"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_CalculateContamination=$(sbatch -p amd-shared --qos amd-shared --array=1-${ntumors} ${SCRIPTDIR}/CalculateContamination.sh $1 | awk '{print $4}')
#jid_CalculateContamination=$(sbatch -p amd-shared --qos amd-shared --array=20 ${SCRIPTDIR}/CalculateContamination.sh $1 | awk '{print $4}')
#jid_CalculateContamination=$(sbatch -p amd-shared --qos amd-shared --array=1-${ntumors} --dependency=afterok:$jid_HealthyPileup ${SCRIPTDIR}/CalculateContamination.sh $1 | awk '{print $4}')
#jid_CalculateContamination=$(sbatch --array=1-${ntumors} ${SCRIPTDIR}/CalculateContamination.sh $1 | awk '{print $4}')
#jid_CalculateContamination=$(sbatch --array=7 ${SCRIPTDIR}/CalculateContamination.sh $1 | awk '{print $4}')
echo "CalculateContamination.sh Job ID $jid_CalculateContamination"  | tee -a ${WORKDIR}/$slurm_info/README

#jidMuTect2=$(sbatch --array=1-${njobs_bytumor_bychr} ${SCRIPTDIR}/MuTect2.sh $1 | awk '{print $4}')
#jidMuTect2=$(sbatch --array=101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,117,118,121,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,183,184,187,188,191,192,197,198,199,200 ${SCRIPTDIR}/MuTect2.sh $1 | awk '{print $4}')

echo "MuTect2.sh Job ID $jidMuTect2"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_MuTect2_mseq=$(sbatch -p amd-shared --qos amd-shared --array=1-${nchrs} ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq=$(sbatch --array=1 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq=$(sbatch --array=10,12,2,3,5,6,7,8 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq=$(sbatch --array=2-${nchrs} ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq=$(sbatch --array=10,11,12,13,14,15,16,17,19,1,2,3,4,5,6,7,8,9 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq=$(sbatch --array=1,2 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq=$(sbatch --array=17,19,21 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#### Each chr the right time  ####
#jid_MuTect2_mseq_chr1_2=$(sbatch --array=1,2 -t 50:00:00 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq2_chr3_12=$(sbatch --array=3-12 -t 40:00:00 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq3_chr13_25=$(sbatch --array=13-25 -t 30:00:00 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')

#jid_MuTect2_mseq_chr1_2=$(sbatch --array=1,2 -p shared --qos shared_long -t 300:00:00 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq2_chr3_12=$(sbatch --array=3-12 -p shared --qos shared_long -t 200:00:00 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq3_chr13_25=$(sbatch --array=13-25 -p shared --qos shared_long -t 150:00:00 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')

#jid_MuTect2_mseq=$(sbatch --array=23 -t 100:00:00 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq=$(sbatch --array=1-23 -t 60:00:00 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')
#jid_MuTect2_mseq=$(sbatch --array=1-25 -t 00:15:00 ${SCRIPTDIR}/MuTect2_mseq.sh $1 | awk '{print $4}')  # Very short one, to repeat only the filtering
echo "MuTect2_mseq.sh Job ID $jid_MuTect2_mseq_chr1_2 $jid_MuTect2_mseq2_chr3_12 $jid_MuTect2_mseq3_chr13_25"  | tee -a ${WORKDIR}/$slurm_info/README
echo "MuTect2_mseq.sh Job ID $jid_MuTect2_mseq"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_FilterMutectCalls=$(sbatch --array=1-${nchrs} ${SCRIPTDIR}/FilterMutectCalls.sh $1 | awk '{print $4}')
#jid_FilterMutectCalls=$(sbatch --array=3 ${SCRIPTDIR}/FilterMutectCalls.sh $1 | awk '{print $4}')
echo "FilterMutectCalls.sh Job ID $jid_FilterMutectCalls"  | tee -a ${WORKDIR}/$slurm_info/README

#${SCRIPTDIR}/MergeMutect2mseqVCFs_unfilt.sh $1
#${SCRIPTDIR}/MergeMutect2mseqVCFs.sh $1
echo "Run MergeMutect2mseqVCFs.sh"


##############
# COPY NUMBER

#jid_sequenza=$(sbatch -p shared,cl-intel-shared --qos=cl-intel-shared -t 48:00:00 --array=1-${ntumors} ${SCRIPTDIR}/Sequenza.sh $1 | awk '{print $4}')
#jid_sequenza=$(sbatch -p amd-shared --qos amd-shared -t 48:00:00 --array=1-${ntumors} ${SCRIPTDIR}/Sequenza.sh $1 | awk '{print $4}')
# BY CHR
#jid_sequenza=$(sbatch -p shared --qos shared -t 10:00:00 --array=1-$((${ntumors}*${nchrs})) ${SCRIPTDIR}/Sequenza_bychr.sh $1 | awk '{print $4}')
#jid_sequenza=$(sbatch -p shared --qos shared -t 10:00:00 --array=1-200 ${SCRIPTDIR}/Sequenza_bychr.sh $1 | awk '{print $4}')
#jid_sequenza=$(sbatch -p amd-shared --qos amd-shared -t 10:00:00 --array=201-300 ${SCRIPTDIR}/Sequenza_bychr.sh $1 | awk '{print $4}')
#jid_sequenza=$(sbatch -p cola-corta --qos default -t 10:00:00 --array=301-400 ${SCRIPTDIR}/Sequenza_bychr.sh $1 | awk '{print $4}')
jid_sequenza=$(sbatch -p amd-shared --qos amd-shared -t 10:00:00 --array=401-500 ${SCRIPTDIR}/Sequenza_bychr.sh $1 | awk '{print $4}')
#jid_sequenza=$(sbatch -p amd-shared --qos amd-shared -t 10:00:00 --array=401-$((${ntumors}*${nchrs})) ${SCRIPTDIR}/Sequenza_bychr.sh $1 | awk '{print $4}')
echo "Sequenza.sh Job ID $jid_sequenza"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_sequenzamerge=$(sbatch -p amd-shared --qos amd-shared -t 5:00:00 --array=1-${ntumors} ${SCRIPTDIR}/Sequenza_merge.sh $1 | awk '{print $4}')
echo "Sequenza_merge.sh Job ID $jid_sequenzamerge"  | tee -a ${WORKDIR}/$slurm_info/README


#jid_sequenza_binning=$(sbatch -p amd-shared --qos amd-shared -t 8:00:00 --array=1-${ntumors} ${SCRIPTDIR}/Sequenza_binning.sh $1 | awk '{print $4}')
echo "Sequenza_binning.sh Job ID $jid_sequenza_binning"  | tee -a ${WORKDIR}/$slurm_info/README


#jid_sequenza_R=$(sbatch -p amd-shared --qos amd-shared -t 3:00:00 --array=1-${ntumors} ${SCRIPTDIR}/SequenzaR.sh $1 | awk '{print $4}')
echo "SequenzaR.sh Job ID $jid_sequenza_R"  | tee -a ${WORKDIR}/$slurm_info/README


##############


#jid_GatherVcfs=$(sbatch --array=1 ${SCRIPTDIR}/GatherVcfs.sh $1 | awk '{print $4}')
#echo "GatherVcfs.sh Job ID $jid_GatherVcfs"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_HaplotypeCaller=$(sbatch --array=1 ${SCRIPTDIR}/HaplotypeCaller.sh $1 | awk '{print $4}')
echo "HaplotypeCaller.sh Job ID $jid_HaplotypeCaller"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_AscatNGS=$(sbatch --array=1-${ntumors} --x11=all ${SCRIPTDIR}/AscatNGS.sh $1 | awk '{print $4}')
echo "AscatNGS.sh Job ID $jid_AscatNGS"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_Lichee=$(sbatch --array=1 ${SCRIPTDIR}/Lichee.sh $1 | awk '{print $4}')
echo "Lichee.sh Job ID $jid_Lichee"  | tee -a ${WORKDIR}/$slurm_info/README

# Calculating depth in healthy bulks

#jid_Genomecov=$(sbatch --array=1 ${SCRIPTDIR}/Genomecov.sh $1 | awk '{print $4}')
echo "Genomecov.sh Job ID $jid_Genomecov"  | tee -a ${WORKDIR}/$slurm_info/README

#jid_SamtoolsDepth=$(sbatch --array=1 ${SCRIPTDIR}/SamtoolsDepth.sh $1 | awk '{print $4}')
echo "SamtoolsDepth.sh Job ID $jid_SamtoolsDepth"  | tee -a ${WORKDIR}/$slurm_info/README



echo "PIPELINE LAUNCHED"
