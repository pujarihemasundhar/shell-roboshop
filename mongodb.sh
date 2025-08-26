#!/bin/bash

userid=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
M="\e[35m"
N="\e[0m"

LOGS_FOLDER="/var/log/roboshop-logs"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "script started executing at :($ date)" | tee -a $LOG_FILE

# check the user has root priveleges or not
if [ $userid -ne 0 ]
then
    echo -e "$R ERROR:: Please run the script with root user"
    exit 1
else
    echo -e "$G You are running with root user"
fi

# validate functions takes input as exit status, what command they tried to install
VALIDATE(){

    if [ $1 -eq 0 ]
    then
        echo -e "$2 is..........$G SUCCCESS $N" | tee -a $LOG_FILE
    else
        echo -e "$2 is...........$R FAILURE $N" | tee -a $LOG_FILE
        exit 1
    fi
}

cp mongo.repo /etc/yum.repos.d/mongodb.repo
VALIDATE $? "Copying mongodb repo"

dnf install mongodb-org -y &>>LOG_FILE
VALIDATE $? "Installing mongodb server"

systemctl enable mongodb &>>LOG_FILE
VALIDATE $? "Enabling mongodb"

systemctl start mongodb &>>LOG_FILE
VALIDATE $? "Starting mongodb "

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongodb.conf
VALIDATE $? "Editing mongoDB conf file for remote connections"

systemctl restart mongodb &>>LOG_FILE
VALIDATE $? "Restarting MongoDB"
