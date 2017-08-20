#!/bin/bash
#set tv hostname or ip here
tvname="bravia.loc"
#set tv item name in oh here
tvitemname="Bravia_Power"
DEBUG=0
while true
do
while ping "$tvname" -c 1 > /dev/null
do
	oldstatus=$status
	status=$(curl --silent -i -X POST -H "X-HTTP-Method-Override: PUT" -H "Accept: application/json" --header "Content-Type: text/plain" --header "Accept: application/json" -d '{"id":4,"method":"getPowerStatus","version":"1.0","params":["1.0"]}' "http://bravia.loc/sony/system" 2>&1 |tail -1 |jq ".result[0] .status")
	[[ DEBUG -eq 1 ]] && echo Status=$status
	if [ x$status != x$oldstatus ]; then
	if [ $status = \"active\" ]; then
		[[ DEBUG -eq 1 ]] && echo Sending ON to openhab
		curl -X PUT --header "Content-Type: text/plain" --header "Accept: application/json" -d ON "http://localhost:8080/rest/items/$tvitemname/state"
	else
		[[ DEBUG -eq 1 ]] && echo Sending OFF to openhab
		curl -X PUT --header "Content-Type: text/plain" --header "Accept: application/json" -d OFF "http://localhost:8080/rest/items/$tvitemname/state"
	fi
	fi
	sleep 5
done
sleep 10
done
