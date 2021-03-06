#!/bin/sh

#MyPID=`echo $$`
#string=$(ps -xa | grep ResLan | awk '{ print $1 }' | tr '\n' ';')
#IFS=";"; ResLan=($string); unset IFS; pos=${#ResLan[@]}
#if [[ ! $pos = 0 ]]; then
#for (( i=0; i<$pos; i++ )); do 
#if [[ ! ${ResLan[i]} = $MyPID ]]; then kill ${ResLan[i]} &>/dev/null; fi
#done
#fi

loc=$(cat ~/.auth/auth.plist | grep -A 1 "Locale" | grep string | sed -e 's/.*>\(.*\)<.*/\1/' | tr -d '\n')

echo "ResLan starts" >> ~/temp.txt

PASSWORD="nopassword"
if [[ -f ~/.auth/auth.plist ]]; then
      login=`cat ~/.auth/auth.plist | grep -Eo "LoginPassword"  | tr -d '\n'`
    if [[ $login = "LoginPassword" ]]; then
PASSWORD=`cat ~/.auth/auth.plist | grep -A 1 "LoginPassword" | grep string | sed -e 's/.*>\(.*\)<.*/\1/' | tr -d '\n'`
    fi 
fi 

if [[ ! $PASSWORD = "nopassword" ]]; then

old_status=""
varn=0
while [[ $varn = 0 ]]; do
sleep 1
status=$(ifconfig en0 | grep "status" | cut -f2 -d ":" | tr -d " \n")

if [[ ! "$old_status" = "$status" ]]; then
old_status="$status"
 
    if [[ "$status" = "active" ]]; then
        echo "$PASSWORD" | sudo -S ifconfig en0 down 2>&-
        echo "$PASSWORD" | sudo -Sk ifconfig en0 up 2>&-
        sleep 2
    fi    
fi
sleep 1
done
fi
##################################                   #############################################################
cat  ~/.bash_history | sed -n '/startResLan/!p' >> ~/new_hist.txt; rm ~/.bash_history; mv ~/new_hist.txt ~/.bash_history
cat  ~/.bash_history | sed -n '/ResLan/!p' >> ~/new_hist.txt; rm ~/.bash_history; mv ~/new_hist.txt ~/.bash_history
#####################################################################################################################
exit
