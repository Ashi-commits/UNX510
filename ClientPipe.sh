fifo=/tmp/log_server_pipe 
if [[ ! -p $fifo ]] 
   then echo "Sorry, log server not running" >&2 
        exit 1 
fi 
printf "Please enter a comment: " 
read log_record 
echo "$log_record" > $fifo
