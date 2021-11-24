#!/bin/bash

# check number of arguments
if [ $# -ne 2 ]; then
    echo "Usage: ./nullproxy.sh rhost rport"
    exit 1
fi

RHOST=$1
RPORT=$2

# generate random port
min=10000
max=50000
LPORT=`expr $min + $RANDOM % $max`
FPORT=`expr $min + $RANDOM % $max`

echo -e "Running Proxy on Port - $LPORT \n"

echo "Run the following command on remote device:"

echo "'ssh -g -L $FPORT:localhost:$LPORT -N `whoami`@`curl --silent ifconfig.me`' # if you have a public IP address, else use the command below"
echo -e "'ssh -g -L $FPORT:localhost:$LPORT -N `whoami`@`hostname -I | awk '{print $1}'`' \n"

echo -e "add '-f' to the command if you want it to run in the background \n"

echo "Also check out Chisel or vscode remote ssh for better Port Forwarding options \n"

if [ `which socat | grep -o socat` == "socat" ]; then
    socat TCP-LISTEN:"$LPORT",fork,reuseaddr TCP:"$RHOST":"$RPORT"
else
    echo "socat not installed and proxy not set"
fi
