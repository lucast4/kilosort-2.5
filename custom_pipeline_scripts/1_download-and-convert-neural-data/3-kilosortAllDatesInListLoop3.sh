#!/bin/bash -e
# takes list of dates, creates .bin files in N batches (default N=8), and runs kilosort on all of them

# load necessary variables and paths
#source /home/kgg/Desktop/kilosort-2.5/custom_pipeline_scripts/globals.sh
source /gorilla4/kilosort-2024/kilosort-2.5/custom_pipeline_scripts/globals.sh
# #  mount hopfield using kgupta ssh key (-wx access)
# if [ ! -d /mnt/hopfield_data01 ]; then
#   #bash /mnt/mount_hopfield_kgupta.sh
#   hopfield_mount
# fi

#a="Pancho"
a="Diego" # KG 10/18/23

# date_list=(220930 221014 221020 221031 221102 221107 221114 221121 221125)
# date_list=(221020 220930 221014 221031 221102 221107 221114 221121 221125)
# date_list=(220715 220709 220714 230105)
# date_list=(221020 220715 221014 220714 220709 220930)
#date_list=(220716 220717 230106 221031 221102 221107 221114 221121 221125)

# Before 6/16/23
# date_list=(220709 220714 220716 220717 220930 221014 221107 221114 221121 221125 230106)

# 6/16/23 - LT added:
#date_list=(230105 230108 230109 221031 221102 220727 220731)
#date_list=(220621 220624 220703 220706 220715 220805)
# date_list=(220815)
# date_list=(220815)
# date_list=(230620)
# date_list=(230621 230622 230623 230626) # LT, 8/15/23
# date_list=(221015 221024 221220 230616) # LT, 8/17/23
# date_list=(221015 221024) # LT, 8/18/23
# date_list=(220724 220918 220719 221217) # LT, 8/21/23
# date_list=(230103 230104 221218 230612) # LT, 8/21/23
# date_list=(230613 230105) # LT, 
# date_list=(230108 230109) # LT, 
# date_list=(230608 230615) # LT, 
# date_list=(230122) # LT, 
# date_list=(230120 220909) # LT, 
# date_list=(220929 220908) # LT, 
# date_list=( 221001 ) # LT, 
# date_list=(220906 221121 220925) # LT, 
# date_list=(230126 230127) # KGG
# date_list=(230125 220915) # KGG
# date_list=(230811) # KGG
# date_list=(220831 220916) # KGG
#date_list=(221023) # KGG
# date_list=(221120 230307 230306 230320 230310 220831 220901 220902 220907 221107 221106 231113 231114 220913 220916 220921 220920 220928 220926)

#date_list=(230919 230912) # LT 10/14/23
#date_list=(230618 230619 230616 230625 230627 230628 230629 230624 230630) # KG 10/18/23
#date_list=(230704 230707 230711 230713 230717 230831 230617 230614 230615 230622 230623)
#date_list=(231116 231118 231019 231020 231023 231024)
#date_list=(231023 231020)
#date_list=(230626 231130 231201 231204 231205 231206 231207 231211 231213 231218 230830)
#date_list=(230814 231101 231102 231103 231106 231107 231108 231109 231110 231111 231112 231113 231114 231115 231016 231025 231026 231027 231029 230810 230811 230821)
#date_list=(230525 230527 230601 230605 230607 230608 230609 230610 230612 230613 230621 230626 230810 230811 230814 230830 230912 230925 230927 231005 231013 231016 231017 231025 231026 231027 231029 231101 231102 231106 231107 231108 231109 231113 231115 231130 231201 231204 231205 231206 231207 231209 231211)
# date_list=(231102 231103 231106 231107 231108 231109 231110 231113 231114 231115 231026 231027 231029)

date_list=(231115 231026 231027 231029) # LT 3/13/24

# # LOGGING DATES TO DO (8/21/23)
# # singleprims
# 
# 
# 

# # complexvar

# # pig
# 
# 
# 
# 
# 

#  - SKIP, too large for GPU for now...

# # AnBm
# 
# 220901
# 220902
# 
# 
# 

# #AnBmCk

# # dir vs dir vs superv
# 

# # dir vs. dir
# 
# 221119
# 

# # AnBm vs. sup
# 
# 
# 
# 

# # AnBm vs. dir vs. sup
# 

# # dir vs. dir vs. shape
# 
# 221021

# # rowcol
# 230307
# 230306
# 230320
# 230310

# Command to track gpu usage.
# touch gpu_log.txt && nvidia-smi dmon -s mu -d 5 -o TD >> gpu_log.txt 

# main
for d in ${date_list[@]}; do
  if [ -f "${SERVER_KILOSORT_DATA_PATH}/${a}/${d}/KS_done.txt" ]; then
    echo "${d} kilosort full run is found on server... SKIPPING"
    continue
  fi

  #if [ -f "${SERVER_DATA_PATH}/${a}/${d}/KS_done.txt" ]; then
  #  echo "${d} is kilosorted on server"
  #fi
  logfile="log_kilosortOneDate_${d}.txt"
  touch ${logfile}  
  # bash ./3-kilosortOneDate.sh $a $d 2>&1 | tee ${logfile} &

  # NOTE: this runs in parallel, but we are instead running in serial and then running 3 of these scripts in parallel.
  #/usr/bin/time -v ./3-kilosortOneDate.sh $a $d 2>&1 | tee ${logfile} &
  /usr/bin/time -v ./3-kilosortOneDate.sh $a $d 2>&1 | tee ${logfile}
  ./7-uploadKilosortedDayFromLocalToServer.sh $a $d &
done




