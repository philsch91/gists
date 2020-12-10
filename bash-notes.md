# used to prevent filling up disk space in the CISL container
while((1)); do echo "$(date)">/tmp/db2logfile.log; sleep 60; done &