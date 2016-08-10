import subprocess
import json
from sseclient import SSEClient

def getEvents():
    while True:
        messages = SSEClient("https://api.particle.io/v1/devices/470020001451343334363036/events?access_token=9e61d1cf7b89fb5f3e54c6f76a2bdac46cf569eb")
        for msg in messages:
            # import pdb; pdb.set_trace()
            print (msg.data)
            if "BOX DISTURBED BY LIGHT" in msg.data:
                jsonData = json.loads(msg.data)
                print ("Data: %s Core: %s" % (jsonData["data"], jsonData["coreid"]))
                subprocess.call("/Users/echan/Documents/Github/Ethereum/boxFun.sh disturbed", shell=True)
            elif "BOX FIXED FROM LIGHT" in msg.data:
                jsonData = json.loads(msg.data)
                print ("Data: %s Core: %s" % (jsonData["data"], jsonData["coreid"]))
                subprocess.call("/Users/echan/Documents/Github/Ethereum/boxFun.sh fixed", shell=True)

getEvents()