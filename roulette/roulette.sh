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

ctrl_c ()
{
  echo -e "\n\n[!] Saliendo del programa.."
  tput cnorm
  exit 1
}

helpText ()
{
 echo -e "\n${yellowColor}[!]${endColor}${greenColor} Usage:${endColor}${purpleColor} $0${endColor}\n"
 echo -e "\t${blueColor}-m${endColor}\t${greenColor} Money you want to start with."
 echo -e "\t${blueColor}-t${endColor}\t${greenColor} Technique you want to use [martingala | inverseLabrouchere]."
 echo -e "\t${blueColor}-h${endColor}\t${greenColor} Show this help pannel."
 exit 1
}


martingala ()
{
  echo -e "\n${yellowColor}[+]${endColor} Current money $money€"
  echo -ne "\n${yellowColor}[+]${endColor} How much you wanna bet? -> " && read initial_bet
  echo -ne "\n${yellowColor}[+]${endColor} Odd or even (odd/even)? -> "&& read odd_even
  echo -e "\n${yellowColor}[+]${endColor} You are gonna bet ${greenColor}$money€${endColor} to ${purpleColor}$odd_even${endColor}"
  
  backup_bet=$initial_bet
  games_count=1
  bad_games="[ "

  tput civis
  while [[ true ]]; do
    random_number="$(($RANDOM % 37))"
    
    money=$(($money-$initial_bet))
    #echo -e "\n[+] You bet $initial_bet€ and you have $money€ in your wallet."

    if [[ ! "$money" -lt 0 ]]; then
      if [ "$odd_even" == "even" ]; then
        if [[ "$(($random_number % 2))" -eq 0 ]]; then
          if [[ "$random_number" -eq 0 ]]; then
            #echo -e "\n[+] Zero, you lost!"
            initial_bet=$(($initial_bet * 2))
            bad_games+="$random_number "
            #echo -e "\n[+] You have $money€ left."
          else
            #echo -e "\n${yellowColor}[+]${endColor}${greenColor} Even, you won!${endColor}"
            reward=$(($initial_bet * 2))
            #echo -e "\n[!] You have won $reward€"
            money=$(($money + $reward))
            #echo -e "\n[+] You have $money€ in your wallet."
            initial_bet=$backup_bet
            bad_games=""
            bad_games="[ "
          fi
        else
          #echo -e "\n${yellowColor}[!]${endColor} ${redColor}Odd, you lost!${endColor}"
          initial_bet=$(($initial_bet * 2))
          bad_games+="$random_number "
          #echo -e "\n[+] You have $money€ left."
        fi
      else
        if [[ "$(($random_number % 2))" -eq 1 ]]; then
            #echo -e "\n${yellowColor}[+]${endColor}${greenColor} Even, you won!${endColor}"
            reward=$(($initial_bet * 2))
            #echo -e "\n[!] You have won $reward€"
            money=$(($money + $reward))
            #echo -e "\n[+] You have $money€ in your wallet."
            initial_bet=$backup_bet
            bad_games=""
        else
          #echo -e "\n${yellowColor}[!]${endColor} ${redColor}Odd, you lost!${endColor}"
          initial_bet=$(($initial_bet * 2))
          bad_games+="$random_number "
          #echo -e "\n[+] You have $money€ left."
        fi
      fi
    else
      echo -e "\n${redColor}[!] You are broken!${endColor}"
      echo -e "\n${yellowColor}[!]${endColor} You played ${purpleColor}$games_count${endColor} games."
      echo -e "\n${yellowColor}[!]${endColor} Bad games in a row: $bad_games"
      bad_games+="]"
      tput cnorm
      exit 0
    fi
    let games_count+=1
  done

  tput cnorm
}

# Ctrl+C 
trap ctrl_c INT

while getopts "m:t:h" arg; do
  case $arg in 
    m) money=$OPTARG;;
    t) technique=$OPTARG;;
    h) helpText;;
  esac
done

if [[ $money ]] && [[ $money -gt 0 ]] && [[ $technique ]]; then
  echo -e "\n Your starting budget is $money and you are gonna use the technique $technique\n"
  if [[ "$technique" == "martingala" ]]; then
    martingala
  fi
else
  helpText;
fi
