#!/bin/bash

#Colors
greenColor="\e[0;32m\033[1m"
endColor="\033[0m\e[0m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

########

ctrl_c(){
  echo -e "\n\n${redColor}[!] Exiting..\n"
  exit 1
}

# Ctrl+C
trap ctrl_c INT

# Global variables

main_url="https://htbmachines.github.io/bundle.js"

helpText() {
  echo -e "\n${yellowColor}[+]${endColor}${grayColor} Usage:${endColor}"
  echo -e "\t${purpleColor}u)${endColor}${grayColor} Update required files.${endColor}"
  echo -e "\t${purpleColor}m)${endColor}${grayColor} Search by machine name.${endColor}"
  echo -e "\t${purpleColor}h)${endColor}${grayColor} Show this help panel.${endColor}"
}


searchMachine ()
{
  machineName="$1"

  echo "$machineName"
} 

updateFiles ()
{
  echo -e "\n${yellowColor}[+]${endColor}${greenColor} Updating source files..${endColor}"
  if []; then
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sponge bundle.js
  else
    
  fi
}

# Indicators
declare -i parameter_counter=0

while getopts "m:uh" arg; do
  case $arg in
    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
else
  helpText
fi
