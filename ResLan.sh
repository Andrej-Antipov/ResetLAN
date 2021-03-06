#!/bin/sh

GET_USER_PASSWORD(){
PASSWORD="0"
if (security find-generic-password -a ${USER} -s euthanasia -w) >/dev/null 2>&1; then
                PASSWORD="$(security find-generic-password -a ${USER} -s PasswordResetLAN -w)"
fi
}

####### INIT ##################
GET_USER_PASSWORD
old_status=""
######### MAIN ###############
while true; do
sleep 1
status=$(ifconfig en0 | grep "status" | cut -f2 -d ":" | tr -d " \n")

if [[ ! "$old_status" = "$status" ]]; then
old_status="$status"
 
    if [[ "$status" = "active" ]]; then
        echo "$PASSWORD" | sudo -S ifconfig en0 down 
        echo "$PASSWORD" | sudo -Sk ifconfig en0 up 
        sleep 2
    fi    
fi
sleep 1
done

