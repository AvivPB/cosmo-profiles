#!/bin/bash -l
#########################################################
#SBATCH -J obsidian_profiles-snap_150

#SBATCH --mail-user=apadawer@uvic.ca
#SBATCH --mail-type=ALL
#SBATCH --account=rrg-babul-ad
#SBATCH -o /scratch/aspadawe/snapshots/Obsidian/N1024L100/Groups/slurm_files/slurm-%j.out
#########################################################
#SBATCH --time=5:00:00
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
source /scratch/aspadawe/igrm-turbulent-diffusion/pyenvs/main/bin/activate

sim=obsidian
code=Simba
# redshift=0

xscale=R500
ndim=3
filter=Sphere
profile_type=Profile
weight_by=mass

temp_cut='5e5 K'
nh_cut='0.13 cm**-3'

snap_dir=/scratch/aspadawe/snapshots/Obsidian/N1024L100
snap_file=snapshot_150
caesar_dir=/scratch/aspadawe/snapshots/Obsidian/N1024L100/Groups
caesar_file=caesar_150
profiles_dir=/scratch/aspadawe/snapshots/Obsidian/N1024L100/Groups/profiles
save_file="$sim"-"$snap_file"-"$ndim"d_"${filter,,}"_profiles-xscale_"${xscale,,}"-temp_cut"=$temp_cut"-nh_cut"=$nh_cut"
suffix=igrm_props

halo_particles=--halo_particles
dm_particles=--no-dm_particles
bh_particles=--no-bh_particles
gas_particles=--no-gas_particles
igrm_particles=--igrm_particles

calc_thermo_props=--calc_thermo_props
calc_metal_props=--calc_metal_props
calc_gradients=--no-calc_gradients
calc_log_props=--calc_log_props

# halo_ids=0
# Read halo_ids from file
halo_file=$caesar_dir/halo_info_snap_150
while IFS=$'\t' read -r -a line; do
    # source_snap_nums+="${line[1]} "
    # halo_ids+="${line[8]} "
    halo_ids+="${line[3]} "
done < $halo_file

echo halo_ids:
echo $halo_ids
echo

echo $snap_file
echo $caesar_file
echo $save_file

echo
echo 'CALCULATING PROFILES'
echo

python gen_nd_profile_by_halo_id_v2.py --code=$code --snap_file=$snap_dir/$snap_file.hdf5 --caesar_file=$caesar_dir/$caesar_file.hdf5 --halo_ids $halo_ids --save_file=$profiles_dir/"$save_file" --filter=$filter --profile_type=$profile_type --ndim=$ndim --weight_by=$weight_by --xscale=$xscale --temp_cut="$temp_cut" --nh_cut="$nh_cut" $halo_particles $dm_particles $bh_particles $gas_particles $igrm_particles

echo
echo 'CALCULATING EXTRA PROPERTIES OF PROFILES'
echo

python calc_profile_properties.py --dir=$profiles_dir --name="$save_file" --caesar_file=$caesar_dir/$caesar_file.hdf5 --suffix=$suffix --code=$code --ndim=$ndim $calc_thermo_props $calc_metal_props $calc_gradients $calc_log_props

echo
echo 'done'

########################################################
