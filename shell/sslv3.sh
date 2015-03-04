#!/bin/bash

#files=( "lbre.stanford.edu" "emergencycontactinfo.stanford.edu" )
#files=($(cat /Users/melvinw/Troubleshoot/confluence/temp3))
files=($(cat /Users/melvinw/Google\ Drive/Scripts/lbre.txt))
limits=($(seq -s $'\t' 1 1 150))

SSLv3()
{
	cd /usr/local/openssl/bin
	on=`echo -e 'Q'| gtimeout 2 ./openssl s_client -connect ${files[i]}:443 -ssl3 2>/dev/null | grep 'Protocol  : SSLv3'`
	if [ -z "$on" ]
	then
		unset sslv3
		sslv3=N
	else
		unset sslv3
		sslv3=Y
	fi
}
#
TLS()
{
	cd /usr/local/openssl/bin
	version=`echo -e 'Q' | gtimeout 2 ./openssl s_client -connect ${files[i]}:443 -tlsextdebug 2>/dev/null | grep 'Protocol  : TLSv1'`
	if [ -z "$version" ]
	then	
		tls=N
	else
		tls=`echo $version | sed s/'Protocol : '//g`
	fi
}
#
Algorithm()
{
	cd /usr/local/openssl/bin
	unset sha
	sha=`echo -e 'Q' | gtimeout 2 ./openssl s_client -connect ${files[i]}:443 2>/dev/null | ./openssl x509 -text -in /dev/stdin 2>/dev/null |grep "Signature Algorithm"`
	if [ -z "$sha" ]
	then
		unset signature
		signature=NA
	else
		declare -a algorithm=($sha)
		unset signature
		signature=`echo ${algorithm[2]}`
	fi
}
#
Heartbeat()
{
	cd /usr/local/openssl/bin
	beat=`echo -e 'Q' | gtimeout 2 ./openssl s_client -connect ${files[i]}:443 -tlsextdebug 2>/dev/null | grep 'server extension "heartbeat" (id=15)'`
	if [ -z "$beat" ]
	then
		heartbeat=NA
	else
		heartbeat='Detected'
	fi
}
#
for i in ${!files[*]}
do
 SSLv3 $i
 TLS $i
 Algorithm $i
 Heartbeat $i
 printf '%s,%s,%s,%s,%s,%s\n' ${limits[i]} ${files[i]} $sslv3 $tls $signature $heartbeat
done
