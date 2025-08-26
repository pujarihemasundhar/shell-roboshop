#!/bin/bash

userid=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
M="\e[35m"
N="\e[0m"

if [ $userid -ne 0 ]
then
    echo -e "$R ERROR:: Please run the script with root user"
    exit 1
else
    echo -e "$G You are running with root user"

