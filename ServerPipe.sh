#!/bin/bash

fifo=/tmp/log_server_pipe
if [[ ! -p $fifo ]] && ! mkfifo -m 666 $fifo
 then echo "Error: could not create pipe" >&2
 exit 1
fi
while :
do
 if read log_rec < $fifo
 then
   if [[ "$log_rec" == 'stop' ]]; then
     break
   fi
   echo "$log_rec"
 fi
done
echo "Server exiting"

