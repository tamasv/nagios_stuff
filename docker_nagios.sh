#!/bin/bash
print_nrdp() {
	IFS=$'|'; arrIN=($1); unset IFS;
	IFS=$';'; CHECK_DATA=(${arrIN[0]}); unset IFS;
	for i in "${!CHECK_DATA[@]}"; do
		IFS=$':'; EXIT_STATUS=(${CHECK_DATA[$i]}); unset IFS;
		IFS=$' '; SERVICE_NAME=(${EXIT_STATUS[1]}); unset IFS;
		STATUS="$( echo -e ${EXIT_STATUS[0]} | sed -e 's/^[[:space:]]*//')"
		if [[ $STATUS == "OK" ]];then
			NAG_CODE=0
		elif [[ $STATUS == "WARNING" ]];then
			NAG_CODE=1
		elif [[ $STATUS == "CRITICAL" ]];then
			NAG_CODE=2
		elif [[ $STATUS == "UNKNOWN" ]];then
			NAG_CODE=3
		else
			NAG_CODE=3
		fi
		echo "$HOST;${SERVICE_NAME[@]:0:2};$NAG_CODE;${EXIT_STATUS[1]:1}"
	done

}


while getopts n:c:m:u: option
do
case "${option}"
in
n) NAME=${OPTARG};;
c) CPU=${OPTARG};;
m) MEM=${OPTARG};;
u) UPTIME=${OPTARG};;
esac
done
HOST=$(hostname -f)
print_nrdp "$(/usr/local/bin/check_docker --containers $NAME --present --cpu $CPU --mem $MEM --status running --uptime $UPTIME)"


