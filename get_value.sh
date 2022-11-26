#!/bin/bash

password=""
echo "Enter Username : "

# it will read username
read username
pass_var="Enter Password :"

# this will take password letter by letter
while IFS= read -p "$pass_var" -r -s -n 1 letter
do
    # if you press enter then the condition 
    # is true and it exit the loop
    if [[ $letter == $'\0' ]]
    then
        break
    fi
    
    # the letter will store in password variable
    password=password+"$letter"
    
    # in place of password the asterisk (*) 
    # will printed
    pass_var="*"
done
echo
echo "Your password is read with asterisk (*)."

echo "Username is: ${username}."
echo "Password is: ${password}."

