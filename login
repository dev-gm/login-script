#!/bin/bash

username="gavin"
salt=$(awk -F[:$] '$1 == "'$username'" {print $4}' /etc/shadow)
epassword=$(awk -F[:] '$1 == "'$username'" {print $2}' /etc/shadow)
# epassword=$(awk -F[:$] '$1 == "root" {print $5}' /etc/shadow)

backspace=$(cat << eof
0000000 005177
0000002
eof
)

clear

chvt 2

echo "Verify you are '$username'"

count=0
while true; do
if [[ $count = 3 ]]; then
	echo "Too many tries! Reboot or try again later."
	exit 0
fi
echo -n "Password: "
unset password;
pw_len=0
while IFS= read -r -s -n1 pass; do
  if [[ -z $pass ]]; then
     echo
     break
  else
  	 if [[ ($(echo $pass | od) = "$backspace") &&  ($pw_len > 0) ]]; then
	 	echo -ne "\b \b"
	 	pw_len=$((pw_len-1))
	 elif [[ !("$(echo $pass | od)" = "$backspace") ]]; then
     	echo -n '*'
	 	pw_len=$((pw_len+1))
	 fi
     password+=$pass
  fi
done
count=$((count+1))
match=$(python -c 'import crypt; print(crypt.crypt("'"${password}"'", "$6$'${salt}'"))')
if [ ${match} == ${epassword} ]; then
	su -c ". \$HOME/.loginmanrc" $username
	exit 0
else
	echo "Error!"
fi
done
