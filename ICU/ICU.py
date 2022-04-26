
from flask import Flask, jsonify, request
from flask_cors import CORS
TemperatureData=[]
HumidityData=[]
ToggleHumidity=1
ToggleTemperature=1
app = Flask(__name__)
CORS(app)
@app.route('/SensorsData', methods=['POST'])
def Data():
    request_data = request.get_json()
    print(request_data)
    global Temperature , Humidity
    Temperature=(request_data['Temperature'])
    Temperature = (float(Temperature))
    Humidity=(request_data['Humidity'])
    Humidity = (float(Humidity))
    SensorTemp = {"Temperature": Temperature} 
    SensorHum={"Humidity": Humidity}
    if ToggleTemperature == 1 :  
        TemperatureData.append(SensorTemp)
    if ToggleHumidity == 1 :  
        HumidityData.append(SensorHum)    
    print(len(TemperatureData))    
    print(len(HumidityData))    
    print("temperature")
    print(Temperature)
    print("humidity")
    print(Humidity)
    return jsonify(Temperature , Humidity)

@app.route('/Temperature', methods=['GET'])
def GetTemp():
    return (jsonify(TemperatureData))

@app.route('/Humidity', methods=['GET'])
def GetHum():
    return (jsonify(HumidityData))

@app.route('/ToggleTemperature', methods=['POST'])
def ToggleTemperatur():
    global ToggleTemperature
    ToggleTemperature=1-ToggleTemperature
    print (ToggleTemperature)
    return ('Toggle Temperature Done')
@app.route('/ToggleHumidity', methods=['POST'])
def ToggleHumidit():
    global ToggleHumidity
    ToggleHumidity=1-ToggleHumidity
    print (ToggleHumidity)
    return ('Toggle Humidity Done')    
if __name__ == "__main__":
    app.run(host="192.168.1.9", port=3000, debug=True)