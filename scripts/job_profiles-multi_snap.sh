#!/bin/bash -l
#########################################################
#SBATCH -J run_profiles-multi_snap

#SBATCH --mail-user=apadawer@uvic.ca
#SBATCH --mail-type=ALL
#SBATCH --account=rrg-babul-ad
#SBATCH -o /scratch/aspadawe/snapshots/Obsidian/N1024L100/Groups/slurm_files/slurm-%j.out
#########################################################
#SBATCH --time=24:00:00
#SBATCH --nodes=1
##SBATCH --ntasks=32
##SBATCH --mem=0
#########################################################

##SBATCH --array=1-10%1 # Run a N-job array, 1 job at a time
#########################################################


# ---------------------------------------------------------------------
#echo "Current working directory: `pwd`"
#echo "Starting run at: `date`"
# ---------------------------------------------------------------------
#echo ""
#echo "Job Array ID / Job ID: $SLURM_ARRAY_JOB_ID / $SLURM_JOB_ID"
#echo "Job task $SLURM_ARRAY_TASK_ID / $SLURM_ARRAY_TASK_COUNT"
#echo ""
# ---------------------------------------------------------------------


source /scratch/aspadawe/igrm-turbulent-diffusion/pyenvs/main/bin/activate

python ./run_profiles-multi_snap.py

########################################################
