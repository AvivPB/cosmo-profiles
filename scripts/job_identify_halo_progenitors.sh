#!/bin/bash -l
#########################################################
#SBATCH -J identify_halo_progenitors-snap_145

#SBATCH --mail-user=apadawer@uvic.ca
#SBATCH --mail-type=ALL
#SBATCH --account=rrg-babul-ad
#SBATCH -o /scratch/aspadawe/snapshots/Obsidian/N1024L100/Groups/slurm_files/slurm-%j.out
#########################################################
#SBATCH --time=0:30:00
#SBATCH --nodes=1
#SBATCH --ntasks=192
#SBATCH --mem=0
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


module load StdEnv/2023 python/3.13

source /scratch/aspadawe/manhattan_suite/observables/pyenvs/mansuite-obs/bin/activate


snap_dir=/scratch/aspadawe/snapshots/Obsidian/N1024L100
snap_base=snapshot_

caesar_dir=/scratch/aspadawe/snapshots/Obsidian/N1024L100/Groups
# echo $caesar_dir

caesar_base=caesar_
caesar_suffix=''

source_snap_nums=150
# # target_snap_nums=$(seq 50 1 272)
# target_snap_nums={0..151}
target_snap_nums=145
# source_halo_ids=0

# Read source_halo_ids from file
progen_file=$caesar_dir/halo_info_snap_150
while IFS=$'\t' read -r -a line; do
    # source_snap_nums+="${line[1]} "
    source_halo_ids+="${line[3]} "
done < $progen_file

echo source_snap_nums:
echo $source_snap_nums
echo

echo source_halo_ids:
echo $source_halo_ids
echo

n_most=1
nproc=192

output_file=$caesar_dir/halo_progen_info_snap_${target_snap_nums}
clear_output_file=--clear_output_file


echo
echo 'Identifying Progenitors'
echo

python identify_halo_progenitors.py --snap_dir=$snap_dir --snap_base=$snap_base --caesar_dir=$caesar_dir --caesar_base=$caesar_base --caesar_suffix=$caesar_suffix --source_snap_nums $source_snap_nums --target_snap_nums $target_snap_nums --source_halo_ids $source_halo_ids --n_most=$n_most --nproc=$nproc --output_file=$output_file $clear_output_file

echo
echo 'done'

########################################################
