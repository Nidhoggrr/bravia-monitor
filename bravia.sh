#!/bin/bash
#set tv hostname or ip here
tvname="bravia.loc"
#set tv item name in oh here
tvitemname="Bravia_Power"
#set tv item name in oh here
tvmuteitemname="Bravia_AudioMute"
DEBUG=1
while true
do
while ping "$tvname" -c 1 > /dev/null
do
echo *SEPOWR################|netcat "$tvname" 20060 | while IFS=, read -a s
do 
	p=${s#\*S} 
	cmd=${s:22}
	[ $cmd == "1" ] && cmd="ON"
	[ $cmd == "0" ] && cmd="OFF"
	case $p in
	?"POWR000000000000000"?)
		[[ DEBUG -eq 1 ]] && echo $cmd
		curl -X PUT --header "Content-Type: text/plain" --header "Accept: application/json" -d $cmd "http://localhost:8080/rest/items/$tvitemname/state"
		;;
	"NAMUT000000000000000"?)
		[[ DEBUG -eq 1 ]] && echo $cmd
		curl -X PUT --header "Content-Type: text/plain" --header "Accept: application/json" -d $cmd "http://localhost:8080/rest/items/$tvmuteitemname/state"
		;;
	*)
		echo $p unhandled
		;;
esac
done
done
curl -X PUT --header "Content-Type: text/plain" --header "Accept: application/json" -d "OFF" "http://localhost:8080/rest/items/$tvitemname/state"
sleep 10
done
