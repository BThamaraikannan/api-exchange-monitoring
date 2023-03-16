#!/bin/bash

concat="/"
compartment=$1
logGroupOcid=$2
logOcid=$3
stime=$4
etime=$5
envi=$6
oci_in=$compartment$concat$logGroupOcid$concat$logOcid
echo $logOcid
echo $logGroupOcid
echo $compartment
#echo $oci_in

echo "stime" $4 "etime" $5 > $HOME/API-logScUAT/parseout.log
echo "Running in Environment:" $6 >> $HOME/API-logScUAT/parseout.log
#echo "taking the inputA"
#read var

logName=`date '+%Y%m%d%m%s'`

#oci logging-search search-logs --search-query \'$search\' --time-start 2022-08-11T00:30:00Z --time-end 2022-08-12T07:30:00Z
#oci logging-search search-logs --search-query 'search "ocid1.compartment.oc1..aaaaaaaadm5akrfnwtimkk4ntup74unwvmujq3lpds6ibk7hztaetfwnuvva/ocid1.loggroup.oc1.phx.amaaaaaajuw5zsia63vpxqacec2k7bw2ttlsocfprn36ygpia3m735goqumq/ocid1.log.oc1.phx.amaaaaaajuw5zsiag7my2aiifya7357o5ucg5s2nvcqbj2thj374wmdic4ra"' --time-start $stime --time-end "$etime" > Scripts/log$logName.log 2>&1

echo "Aggregating the log as JSON data"

if [[ $envi = "uat" ]] || [[ $envi = "UAT" ]]; then
	#oci logging-search search-logs --search-query 'search "ocid1.compartment.oc1..aaaaaaaacho6pbfwjt75migt5fw2swvz43bx2lfofr2mk2jglpxwdag5suuq/ocid1.loggroup.oc1.phx.amaaaaaajuw5zsiagvon7jwsajoeo2yvjqzohrowlcnntvj2e37tbdmrhjea/ocid1.log.oc1.phx.amaaaaaajuw5zsiaxgtb5hikasprkxqy5jkdmdsbl7anlzmh5s22iljmku6a"' --time-start "$stime" --time-end "$etime" --limit "1000" > $HOME/API-logScUAT/json-data.json 2>&1
        oci logging-search search-logs --search-query 'search "ocid1.compartment.oc1..aaaaaaaacho6pbfwjt75migt5fw2swvz43bx2lfofr2mk2jglpxwdag5suuq/ocid1.loggroup.oc1.phx.amaaaaaajuw5zsiagvon7jwsajoeo2yvjqzohrowlcnntvj2e37tbdmrhjea/ocid1.log.oc1.phx.amaaaaaajuw5zsiaap3s6uy7qokubqufxng7xukdfcd5f3v3voaecjbbpiha"' --time-start "$stime" --time-end "$etime" --limit "1000" > $HOME/API-logScUAT/json-data.json 2>&1

elif [ $envi = "stage" ] || [[ $envi = "STAGE" ]]; then
	#oci logging-search search-logs --search-query 'search "ocid1.compartment.oc1..aaaaaaaacho6pbfwjt75migt5fw2swvz43bx2lfofr2mk2jglpxwdag5suuq/ocid1.loggroup.oc1.phx.amaaaaaajuw5zsiagvon7jwsajoeo2yvjqzohrowlcnntvj2e37tbdmrhjea/ocid1.log.oc1.phx.amaaaaaajuw5zsiaxgtb5hikasprkxqy5jkdmdsbl7anlzmh5s22iljmku6a"' --time-start "$stime" --time-end "$etime" --limit "1000" > $HOME/API-logScripts/json-data.json 2>&1
        oci logging-search search-logs --search-query 'search "ocid1.compartment.oc1..aaaaaaaacho6pbfwjt75migt5fw2swvz43bx2lfofr2mk2jglpxwdag5suuq/ocid1.loggroup.oc1.phx.amaaaaaajuw5zsiagvon7jwsajoeo2yvjqzohrowlcnntvj2e37tbdmrhjea/ocid1.log.oc1.phx.amaaaaaajuw5zsiacawykv3l7zn7itpetrtctyvyg2dwg32vcvsig3tizcaa"' --time-start "$stime" --time-end "$etime" --limit "1000" > $HOME/API-logScripts/json-data.json 2>&1

elif [ $envi = "prod" ] || [[ $envi = "PROD" ]]; then
        oci logging-search search-logs --search-query 'search "ocid1.compartment.oc1..aaaaaaaacho6pbfwjt75migt5fw2swvz43bx2lfofr2mk2jglpxwdag5suuq/ocid1.loggroup.oc1.phx.amaaaaaajuw5zsiagvon7jwsajoeo2yvjqzohrowlcnntvj2e37tbdmrhjea/ocid1.log.oc1.phx.amaaaaaajuw5zsiadz6k2rwqsrjaaspj4d5zyrssok35nf6nky5nwosfjtsq"' --time-start "$stime" --time-end "$etime"  --limit "1000" > $HOME/API-logScripts/json-data.json 2>&1
else
        echo "no active env"
fi

#oci logging-search search-logs --search-query 'search "ocid1.compartment.oc1..aaaaaaaacho6pbfwjt75migt5fw2swvz43bx2lfofr2mk2jglpxwdag5suuq/ocid1.loggroup.oc1.phx.amaaaaaajuw5zsiagvon7jwsajoeo2yvjqzohrowlcnntvj2e37tbdmrhjea/ocid1.log.oc1.phx.amaaaaaajuw5zsiadz6k2rwqsrjaaspj4d5zyrssok35nf6nky5nwosfjtsq"' --time-start "$stime" --time-end "$etime"  --limit "1000" > $HOME/API-logScUAT/json-data.json 2>&1

#### Log writing to the Database ####
python3 $HOME/API-logScUAT/parsejson.py >> $HOME/API-logScUAT/parseout.log 2>&1
