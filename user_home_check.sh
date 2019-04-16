#!/bin/bash

#Here we declare variable LIMIT with max of used space
LIMIT='10'

#Here we declare variable DIR with name of directory
DIR='/home'

#Here we declare variable MAILTO with email address
MAILTO='shehbaz.pathan@teradata.com'

#Here we declare variable SUBJECT with subject of email
SUBJECT="Top Ten users using  high disk space under $DIR"

#Here we declare variable MAILX with mailx command that will send email
MAILX='mailx'

#Here we check if mailx command exist
which $MAILX > /dev/null 2>&1

#We check exit status of previous command if exit status not 0 this mean that mailx is not installed on system
if ! [ $? -eq 0 ]
then
#Here we warn user that mailx not installed
          echo "Please install $MAILX"
#Here we will exit from script
          exit 1
fi

#To check real used size, we need to navigate to folder
cd $DIR

#This line will get used space of partition where we currently, this will use df command, and get used space in %, and after cut % from value.
USED=`df . | awk '{print $5}' | sed -ne 2p | cut -d"%" -f1`

#If used space is bigger than LIMIT
if [ $USED -gt $LIMIT ]
then
#This will print space usage by each directory inside directory $DIR, and after MAILX will send email with SUBJECT to MAILTO
      du -sh ${DIR}/* | sort -rh | head -3 | $MAILX -s "$SUBJECT" "$MAILTO"
fi