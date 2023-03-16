import json
import cx_Oracle

f = open('/home/oracle/API-logScUAT/json-data.json')
field = json.load(f)
field.update({"fields": "\"null\""})
rowlist = []

j = field['data']['results']
#print(j)
resultslistdata = [ i['data']['logContent']['data'] for i in field['data']['results']]
#print(resultslist)
resultslistid = [ i['data']['logContent']['id'] for i in field['data']['results']]
indexcount = len(resultslistid)
#for i in resultslistid:
 #print(i)
newlist =   [ (resultslistdata[j]['backendAddr'].split(',', 2)[0], \
resultslistdata[j]['backendConnectTime'].split(',', 2)[0] , \
resultslistdata[j]['backendProcessingTime'].split(',', 2)[0] , \
min(resultslistdata[j]['backendStatusCode'].split(',', 2)), \
resultslistdata[j]['clientAddr'].split(',', 2)[0], \
resultslistdata[j]['request'], \
resultslistdata[j]['requestProcessingTime'].split(',', 2)[0] , \
resultslistdata[j]['timestamp'], \
resultslistid[j] ) for j in range(0,indexcount)]

newlist = [i for i in newlist if "apiGW" in i[5]]
#newlist = [i for i in newlist if i[0] != ""]
#rowlist.append(tuple(newlist))

connection = cx_Oracle.connect(
    user="dwuser",
    password="<UAT DB Password>",
    dsn="140.87.124.235:1521/PCAP13")

print("success")

cursor = connection.cursor()

cursor.executemany("insert into WC_BIA_APIEXCH_LOG_F (BACKENDADDR, BACKENDCONNECTTIME, BACKENDPROCESSINGTIME, BACKENDSTATUSCODE, CLIENTADDR, REQUEST, REQUESTPROCESSINGTIME, TIMESTAMP, ID) values(:1, :2, :3, :4, :5, :6, :7, TO_TIMESTAMP_TZ(:8, 'yyyy-mm-dd\"T\"hh24:mi:ss.fftzh:tzm')+0, :9)", newlist, batcherrors=True)

print(cursor.rowcount, "Rows Inserted")

connection.commit()

connection.close()
f.close()
