import json
import ssl
import websocket
import base64

BMC_ADDRESS = "172.31.92.34"
username = 'root'
password = 'sdd@atos'

b64Val = base64.b64encode((username + ":" + password).encode("ascii"))

websocket.enableTrace(True)

ws = websocket.create_connection('wss://' + BMC_ADDRESS + '/subscribe',
                                 sslopt={"cert_reqs": ssl.CERT_NONE},
                                 header=["Authorization: Basic " + b64Val.decode("ascii")])
request = json.dumps({
    "paths": ["/xyz/openbmc_project/logging", "/xyz/openbmc_project/sensors"],
    "interfaces": ["xyz.openbmc_project.Logging.Entry", "xyz.openbmc_project.Sensor.Value"]
})

ws.send(request)
print("Sent")
print("Receiving...")
while True:
    result = ws.recv()
    json_data = json.loads(result)
    print("Received {path} {value}".format(path=json_data.get("path"), value=json_data.get("properties").get("Value")))
ws.close()