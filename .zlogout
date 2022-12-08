if [ -z "$SSH_CONNECTION" ]
then
  echo Leaving $(pwd)
else
  echo Leaving `echo $SSH_CONNECTION | cut -d \  -f 3`:`pwd`
fi
