#!/bin/bash
# Need following applications to be installed jq, aws cli
# This is a shell script which EC2 instances accross the AWS Cloud
#Define all arrays to store values
declare -a typearray
declare -a statearray
declare -a zonearray
declare -a valuearray
declare -a keynamearray
set +m
for region in $(aws ec2 describe-regions --query "Regions[*].[RegionName]" --output text); do 
  aws ec2 describe-instances --region "$region" | jq ".Reservations[].Instances[] | {type: .InstanceType, keyname: .KeyName, instanceID: .InstanceId, device: .BlockDeviceMappings, state: .State.Name, tags: .Tags, zone: .Placement.AvailabilityZone}" >> tet.txt &
done;  wait; set -m

awk -F'[, | ]' '{for(i=1;i<=NF;i++){gsub(/"|:/,"",$i);if($i=="type"){gsub(/"|:/,"",$(i+1));print $(i+1)}}}' tet.txt  >> type.txt # look for type of instance in file
awk -F'[, | ]' '{for(i=1;i<=NF;i++){gsub(/"|:/,"",$i);if($i=="state"){gsub(/"|:/,"",$(i+1));print $(i+1)}}}' tet.txt  >> state.txt # look for instance state in file
awk -F'[, | ]' '{for(i=1;i<=NF;i++){gsub(/"|:/,"",$i);if($i=="zone"){gsub(/"|:/,"",$(i+1));print $(i+1)}}}' tet.txt  >> zone.txt # look for zone name in the  file
awk -F'[, | ]' '{for(i=1;i<=NF;i++){gsub(/"|:/,"",$i);if($i=="Value"){gsub(/"|:/,"",$(i+1));print $(i+1)}}}' tet.txt  >> value.txt # look for zone name in the  file
awk -F'[, | ]' '{for(i=1;i<=NF;i++){gsub(/"|:/,"",$i);if($i=="instanceID"){gsub(/"|:/,"",$(i+1));print $(i+1)}}}' tet.txt  >> instanceid.txt # look for zone name in the  file
awk -F'[, | ]' '{for(i=1;i<=NF;i++){gsub(/"|:/,"",$i);if($i=="keyname"){gsub(/"|:/,"",$(i+1));print $(i+1)}}}' tet.txt  >> keyname.txt # look for zone name in the  file
#clean up blank spaces for the pool file
		  sed 's/"//g' type.txt >> cleantype.txt
		  sed 's/"//g' state.txt >> cleanstate.txt
		  sed 's/"//g' zone.txt >> cleanzone.txt
		  sed 's/"//g' value.txt >> cleanvalue.txt
		  sed 's/"//g' instanceid.txt >> cleaninstanceid.txt
		  sed 's/"//g' keyname.txt >> cleankeyname.txt
		  # Load file into array.

let i=0
		  # Read file cleanstore.txt line by line and put the details in array 
		  while IFS=$'\n' read -r line_data; do
    	  typearray[i]="${line_data}"
          ((++i))
          done < cleantype.txt

let j=0
 # Read file cleanstore.txt line by line and put the details in array
                  while IFS=$'\n' read -r line_data; do
          statearray[j]="${line_data}"
          ((++j))
          done < cleanstate.txt

          let j=0
 # Read file cleanstore.txt line by line and put the details in array
                  while IFS=$'\n' read -r line_data; do
          zonearray[j]="${line_data}"
          ((++j))
          done < cleanzone.txt
let j=0
# Read file cleanstore.txt line by line and put the details in array
                  while IFS=$'\n' read -r line_data; do
          valuearray[j]="${line_data}"
          ((++j))
          done < cleanvalue.txt
let j=0
# Read file cleanstore.txt line by line and put the details in array
                  while IFS=$'\n' read -r line_data; do
          instanceidarray[j]="${line_data}"
          ((++j))
          done < cleaninstanceid.txt
let j=0
# Read file cleanstore.txt line by line and put the details in array
                  while IFS=$'\n' read -r line_data; do
          keynamearray[j]="${line_data}"
          ((++j))
          done < cleankeyname.txt


          printf "\033[0;32m You have following Instances type for AWS Account XXX  : \033[0m \n"

 let i=0
          while (( ${#instanceidarray[@]} > i )); do
          ((++i))
          printf "\033[0;32m $i  ${zonearray[i]}      ${valuearray[i]}    ${typearray[i]}   ${instanceidarray[i]}      ${keynamearray[i]}        ${statearray[i]}   \033[0m \n\n"
          done
rm *.txt
