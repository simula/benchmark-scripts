#!/bin/bash
if [ "$#" -ne 2 ]; then
  echo "Usage:  #iterations rate_limit"
  echo "Example: sudo ./runSyntheticTests.sh 10000000 200" 
  exit 1
fi

sudo ./run_new_JPDC.sh $1 $2
sleep 5
sudo ./run_third_scenario_bw.sh $1 $2
sleep 5
sudo ./run_new_scenario_fair.sh $1 $2
sleep 5
sudo ./run_fair_four_scenario.bw $1 $2
sleep 5
sudo ./run_ctree_first_scenario.bw $1 $2
sleep 5
sudo ./run_ctree_third_scenario.bw $1 $2
