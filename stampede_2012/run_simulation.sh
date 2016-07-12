#!/bin/bash
# Run a yearlong SELFE sediment simulation

# ----------------------------------------------------------------------------
# Simulation
# - 2 parts for 1 year
# ----------------------------------------------------------------------------
# first simulation - ~250 days in 48 hours
job1=$(sbatch run.sub)

# start combine after 1st job finishes
# - days 1 - 250
job2=$(sbatch --dependency=afterany:$job1 combine.sub)

# create hotstart and setup job to finish
job3=$(sbatch --dependency=afterany:$job1 hotstart.sub) 

# launch completion of simulation
# - days 1 - 250
job4=$(sbatch --dependency=afterany:$job3 run_continue.sub)

# combine rest of days
# start combine after 1st job finishes
job5=$(sbatch --dependency=afterany:$job4 combine_finish.sub)

# ----------------------------------------------------------------------------
# Skill
# ----------------------------------------------------------------------------
# skill extract and plot and compute metrics
job6=$(sbatch --dependency=afterany:$job5 skill.sub)
job7=$(sbatch --dependency=afterany:$job6 skill_plot.sub)
job8=$(sbatch --dependency=afterany:$job6 calc_skil_metrics.sub)

# ----------------------------------------------------------------------------
# Profiles 
# ----------------------------------------------------------------------------
# extract profiles
job8=$(sbatch --dependency=afterany:$job5 extract_profiles.sub)

# ----------------------------------------------------------------------------
# Bed flux 
# ----------------------------------------------------------------------------
# extract bed flux and slab
job9=$(sbatch --dependency=afterany:$job5 make_bed_flux.sub)
job10=$(sbatch --dependency=afterany:$job9 extract_bed_flux_slab.sub)

# ----------------------------------------------------------------------------
# Transects 
# ----------------------------------------------------------------------------
# extract transects
job11=$(sbatch --dependency=afterany:$job5 extract_transects.sub)
