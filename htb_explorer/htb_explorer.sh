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
  tput cnorm && exit 1
}

# Ctrl+C
trap ctrl_c INT

# Global variables

main_url="https://htbmachines.github.io/bundle.js"


# Help -h
helpText() {
  echo -e "\n${yellowColor}[+]${endColor}${grayColor} Usage:${endColor}"
  echo -e "\t${purpleColor}u)${endColor}${grayColor} Update required files.${endColor}"
  echo -e "\t${purpleColor}m)${endColor}${grayColor} Search by machine name.${endColor}"
  echo -e "\t${purpleColor}d)${endColor}${grayColor} Search by difficulty.${endColor}"
  echo -e "\t${purpleColor}o)${endColor}${grayColor} Search by operative system.${endColor}"
  echo -e "\t${purpleColor}s)${endColor}${grayColor} Search by skills required for the machine.${endColor}"
  echo -e "\t${purpleColor}y)${endColor}${grayColor} Get the video of the resolution of the machine.${endColor}"
  echo -e "\t${purpleColor}h)${endColor}${grayColor} Show this help panel.${endColor}"
}

# Check if the machines source file is up-to-date (Updates if not)
updateFiles ()
{
  if [ ! -f bundle.js ]; then
    tput civis
    echo -e "\n${yellowColor}[!]${endColor}${grayColor}Downloading files..${endColor}"
    curl -s $main_url > bundle.js
    js-beautify bundle.js | sed "s/Difícil/Hard/" | sed "s/Fácil/Easy/" | sed "s/Media/Medium/" | sponge bundle.js
    echo -e "\n${yellowColor}[!]${endColor}${grayColor}All files have been downloaded.${endColor}"
    tput cnorm
  else 
    tput civis
    echo -e "\n${yellowColor}[+]${endColor}${greenColor} Checking if there are any updates..${endColor}"
    curl -s $main_url > bundle_temp.js
    js-beautify bundle_temp.js | sed "s/Difícil/Hard/" | sed "s/Fácil/Easy/" | sed "s/Media/Medium/" | sponge bundle_temp.js
    md5_temp_value=$(md5sum bundle_temp.js | awk '{print $1}')
    md5_og_value=$(md5sum bundle.js | awk '{print $1}')
    if [ "$md5_temp_value" == "$md5_og_value" ]; then
      echo -e "\n${yellowColor}[+]${endColor}${greenColor} All up-to-date.${endColor}"
      rm bundle_temp.js
    else
      echo -e "\n${yellowColor}[+]${endColor}${greenColor} Update available, updating..${endColor}"
      rm bundle.js && mv bundle_temp.js bundle.js
      echo -e "\n${yellowColor}[+]${endColor}${greenColor} Update done.${endColor}"
    fi
    tput cnorm
  fi
}

searchMachine ()
{
  machineName="$1"
  machineName_check="$(cat bundle.js | awk "/name: \"$machineName\"/ ,/resuelta:/" | grep -vE "id:|sku:|resuelta:|Active Directory:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/dificultad/difficulty/')"
  
  if [[ $machineName_check ]]; then
    
    echo -e "\n${yellowColor}[+]${endColor}${greenColor} Displaying results for the${endColor} ${blueColor}$machineName${endColor}${greenColor} machine${endColor}\n"
    cat bundle.js | awk "/name: \"$machineName\"/ ,/resuelta:/" | grep -vE "id:|sku:|resuelta:|Active Directory:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | sed 's/dificultad/difficulty/'

  else
    echo -e "\n${redColor}[!]${endColor} Machine not found.\n"
  fi
}

getYoutubeLink ()
{
  machineName="$1"
  youtubeLink="$(cat bundle.js | awk "/name: \"$machineName\"/ ,/resuelta:/" | grep -vE "id:|sku:|resuelta:|Active Directory:" | tr -d '"' | tr -d ',' | sed 's/^ *//' | grep youtube | awk 'NF{print $NF}')"
  if [ $youtubeLink ]; then
    echo -e "\n${yellowColor}[+]${endColor}${greenColor} The URL of the video for the${endColor} ${blueColor}$machineName${endColor}${greenColor} machine${endColor}${greenColor} is${endColor}${purpleColor} $youtubeLink${endColor}.\n"
  else
    echo -e "\n${redColor}[!]${endColor} Machine not found.\n"
  fi
}

searchByDiff ()
{
  difficulty="$1"
  resultCheck="$(cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [[ $resultCheck ]]; then
 
    echo -e "\n${yellowColor}[+]${endColor}${greenColor} The machines available for the difficulty selected (${endColor}${blueColor}$difficulty${endColor}${greenColor}) are:${endColor}\n"
  cat bundle.js | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColor}[!]${endColor} Difficulty not found.\n"
  fi
}

searchByOs ()
{
  os="$1"
  osCheck="$(cat bundle.js | grep -i "so: \"$os\"" -B 5 | grep name | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [[ $osCheck ]]; then
    echo -e "\n${yellowColor}[+]${endColor}${greenColor} The machines available with the OS${endColor}${blueColor} $os${endColor}${greenColor} are:${endColor}\n"
  cat bundle.js | grep -i "so: \"$os\"" -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColor}[!]${endColor} OS not found.\n"
  fi
}

searchByOsDiff ()
{
  difficulty="$1"
  os="$2"
  searchCheck="$(cat bundle.js | grep -i "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"
  if [[ $searchCheck ]]; then
    echo -e "\n${yellowColor}[+]${endColor}${greenColor} The machines available with the OS${endColor}${blueColor} $os${endColor}${greenColor} and difficulty ${endColor}${redColor}$difficulty${endColor}${greenColor} are:${endColor}\n"
    cat bundle.js | grep -i "so: \"$os\"" -C 4 | grep "dificultad: \"$difficulty\"" -B 5 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColor}[!]${endColor} No results found.\n"
  fi
}

searchBySkill ()
{
  skill = "$1"
  skillCheck="$(cat bundle.js | grep -i "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column)"

  if [[ "$skillCheck" ]]; then
    echo -e "\n${yellowColor}[+]${endColor}${greenColor} The machines available that require the skill${endColor}${blueColor} $skill${endColor}${greenColor} are:${endColor}\n"
    cat bundle.js | grep -i "skills: " -B 6 | grep "$skill" -i -B 6 | grep "name: " | awk 'NF{print $NF}' | tr -d '"' | tr -d ',' | column
  else
    echo -e "\n${redColor}[!]${endColor} No results found.\n"
  fi
}

# Indicators
declare -i parameter_counter=0

# Snitch
declare -i sn_difficulty=0 
declare -i sn_os=0 

while getopts "m:y:d:o:s:uh" arg; do
  case $arg in
    m) machineName=$OPTARG; let parameter_counter+=1;;
    u) let parameter_counter+=2;;
    y) machineName=$OPTARG; let parameter_counter+=3;;
    d) difficulty=$OPTARG; let sn_difficulty=1; let parameter_counter+=4;;
    o) os=$OPTARG; let sn_os=1; let parameter_counter+=5;;
    s) skill=$OPTARG; let parameter_counter+=6;;
    h) ;;
  esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName
elif [ $parameter_counter -eq 2 ]; then
  updateFiles
elif [ $parameter_counter -eq 3 ]; then
  getYoutubeLink $machineName
elif [ $parameter_counter -eq 4 ]; then
  searchByDiff $difficulty
elif [[ $parameter_counter -eq 5 ]]; then
  searchByOs $os
elif [ $sn_difficulty -eq 1 ] && [ $sn_os -eq 1 ]; then
  searchByOsDiff $difficulty $os
elif [[ $parameter_counter -eq 6 ]]; then
  searchBySkill "$skill"
else
  helpText
fi
