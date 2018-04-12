#!/bin/bash

PATH="/usr/bin:/usr/sbin:/bin:/sbin"

#SERVICE_NAME=check_service
SERVICE_NAME=$0
STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
STATE_DEPENDENT=4


print_usage() {
                echo "Usage: $PROGNAME -s <service> -c <crash>"
                echo "Usage: $PROGNAME --help"
                echo "Usage: $PROGNAME --version"
}

if [ $# -lt 1 ]; then
        print_usage
        exit $STATE_UNKNOWN
fi

while test -n "$1"; do
                case "$1" in
                                --help)
                                print_usage
                                exit $STATE_OK
                                ;;
                                -h)
                                print_usage
                                exit $STATE_OK
                                ;;
                                --version)
                                print_revision $PROGNAME $VERSION
                                exit $STATE_OK
                                ;;
                                -V)
                                print_revision $PROGNAME $VERSION
                                exit $STATE_OK
                                ;;
                                --servername)
                                servername=$2
                                shift
                                ;;
                                -s)
                                servername=$2
                                shift
                                ;;
                                --ok)
                                server_ok=$2
                                shift
                                ;;
                                -o)
                                server_ok=$2
                                shift
                                ;;
                                --crash)
                                server_crash=$2
                                shift
                                ;;
                                -c)
                                server_crash=$2
                                shift
                                ;;
                                *)
                                echo "Unknown argument: $1"
                                print_usage
                                exit $STATE_UNKNOWN
                                ;;
                esac
                shift
done
#echo "Programming Name:"$0
#echo "Server Name: "$servername "Crash Level "$server_crash
check_processes_yellow()
{
                server_crash=0 
                WARNING_PROCS=""
                PROCESS=`ps -ef | grep -w $servername | grep -v grep |grep -v $SERVICE_NAME|wc -l`
#               echo "No.of Process:" $PROCESS
                exitstatus=$STATE_CRITICAL
                result=critical
                if [ $PROCESS -ge $server_crash ]; then
                                result=ok
                                exitstatus=$STATE_OK
                fi
}

check_processes_yellow

echo "$PROCESS Processes - $result"

exit $exitstatus
