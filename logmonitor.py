import argparse
import subprocess
import sys
import os
from datetime import datetime, timedelta
import datetime
import time
import pytz
UTC = pytz.utc


##### checking for the ocicli command #####

command = "oci -v"
process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE)
process.wait()
ver=process.returncode
if (ver!=0):
	print ("oci cli command is not exist, please install oci cli to run this command")
else:
	print (ver)

###### command to get the console logs #####

compartment="ocid1.compartment.oc1..aaaaaaaacho6pbfwjt75migt5fw2swvz43bx2lfofr2mk2jglpxwdag5suuq"
print ("Compartment OCID:", compartment) 


logGroupOcid="ocid1.loggroup.oc1.phx.amaaaaaajuw5zsiagvon7jwsajoeo2yvjqzohrowlcnntvj2e37tbdmrhjea"
print ("Log group OCID:", logGroupOcid)
logOcid="ocid1.log.oc1.phx.amaaaaaajuw5zsiadz6k2rwqsrjaaspj4d5zyrssok35nf6nky5nwosfjtsq"
print("Log OCID:", logOcid)

environ=sys.argv[1]
print("Environment:", environ)

nowtime = datetime.datetime.now(UTC)
start_time = nowtime - datetime.timedelta(minutes = 7)
startTime=start_time.strftime('%Y-%m-%d %H:%M')
print("startTime for log:", startTime)

current_hour = nowtime - datetime.timedelta(minutes = 5)
endTime=current_hour.strftime('%Y-%m-%d %H:%M')
print("endTime for log:", endTime)


subprocess.call(["/home/oracle/API-logScUAT/helpscript.sh",compartment,logGroupOcid,logOcid,startTime,endTime,environ])
#print(proc.stdout)
