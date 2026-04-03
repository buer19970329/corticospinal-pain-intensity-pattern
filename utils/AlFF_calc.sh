#!/usr/bin/env bash

# 1. input data in MNI standard space 2. output dir 3. output name 4.mask
## directory setup
ALFF_dir=$2

#subject name
rest=$3
subject=$1
## number of timepoints
n_vols=`fslval $subject dim4`
## TR
#TR=`fslval $subject pixdim4`
TR=2.68;

LP=0.01 ; HP=0.13;

##########################################################################################################################
##---START OF SCRIPT----------------------------------------------------------------------------------------------------##
##########################################################################################################################

echo ---------------------------------------
echo !!!! CALCULATING ALFF AND fALFF !!!!
echo ---------------------------------------

echo --------------------------
echo running subject ${rest}
echo --------------------------

mkdir -p ${ALFF_dir} ; cd ${ALFF_dir}

## CALCULATING ALFF AND fALFF
## 1. primary calculations
echo "there are ${n_vols} vols"
echo TR is $TR;
## decide whether n_vols is odd or even
MOD=`expr ${n_vols} % 2` ; echo "Odd (1) or Even (0): ${MOD}"
## if odd, remove the first volume
N=$(echo "scale=0; ${n_vols}/2"|bc) ; N=$(echo "2*${N}"|bc)  ; echo ${N}

## 2. Computing power spectrum
echo "Computing power spectrum"
fslpspec $subject ${rest}_prealff_func_data_ps.nii.gz
## copy power spectrum to keep it for later (i.e. it does not get deleted in the clean up at the end of the script)
#cp prealff_func_data_ps.nii.gz power_spectrum_distribution.nii.gz
echo "Computing square root of power spectrum"
fslmaths ${rest}_prealff_func_data_ps.nii.gz -sqrt ${rest}_prealff_func_data_ps_sqrt.nii.gz

## 3. Calculate ALFF
echo "Extracting power spectrum at the slow frequency band"
## calculate the low frequency point
n_lp=$(echo "scale=10; ${LP}*${N}*${TR}"|bc)
n1=$(echo "${n_lp}-1"|bc|xargs printf "%1.0f") ;
echo "${LP} Hz is around the ${n1} frequency point."
## calculate the high frequency point
n_hp=$(echo "scale=10; ${HP}*${N}*${TR}"|bc)
n2=$(echo "${n_hp}-${n_lp}+1"|bc|xargs printf "%1.0f") ;
echo "There are about ${n2} frequency points before ${HP} Hz."
## cut the low frequency data from the the whole frequency band
fslroi ${rest}_prealff_func_data_ps_sqrt.nii.gz ${rest}_prealff_func_ps_slow.nii.gz ${n1} ${n2}
## calculate ALFF as the sum of the amplitudes in the low frequency band
echo "Computing amplitude of the low frequency fluctuations (ALFF)"
fslmaths ${rest}_prealff_func_ps_slow.nii.gz -Tmean -mul ${n2} ${rest}_ALFF.nii.gz

## 4. Calculate fALFF
echo "Computing amplitude of total frequency"
fslmaths ${rest}_prealff_func_data_ps_sqrt.nii.gz -Tmean -mul ${N} -div 2 ${rest}_prealff_func_ps_sum.nii.gz
## calculate fALFF as ALFF/amplitude of total frequency
echo "Computing fALFF"
fslmaths ${rest}_ALFF.nii.gz -div ${rest}_prealff_func_ps_sum.nii.gz ${rest}_fALFF.nii.gz

## 5. Z-normalisation across whole brain
echo "Normalizing ALFF/fALFF to Z-score across full brain"
mean=`fslstats ${rest}_ALFF.nii.gz -k $4 -m`;
std=`fslstats ${rest}_ALFF.nii.gz -k $4 -s`;
echo $mean $std
fslmaths ${rest}_ALFF.nii.gz -sub ${mean} -div ${std} -mas $4 ${rest}_ALFF_Z.nii.gz
mean=`fslstats ${rest}_fALFF.nii.gz -k $4 -m`;
std=`fslstats ${rest}_fALFF.nii.gz -k $4 -s`;
echo $mean $std
fslmaths ${rest}_fALFF.nii.gz -sub ${mean} -div ${std} -mas $4 ${rest}_fALFF_Z.nii.gz

## 7. Clean up
echo "Clean up temporary files"
rm -rf *prealff_*.nii.gz

cd ${cwd}
