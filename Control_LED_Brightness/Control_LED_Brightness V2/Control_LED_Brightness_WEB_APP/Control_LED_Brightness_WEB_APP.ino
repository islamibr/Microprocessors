#define BLYNK_TEMPLATE_ID "TMPL2S92jb0E0"
#define BLYNK_TEMPLATE_NAME "LED Brightness"
#define BLYNK_AUTH_TOKEN "9w3etaZwhXmhpTZ73iHtNh-cvVrcXDaS"

#include <WiFiClient.h>
#include <BlynkSimpleEsp32.h>
#include <WiFi.h>
// #include <AsyncTCP.h>
#include <ESPAsyncWebServer.h>

char auth[] = BLYNK_AUTH_TOKEN;
const char* ssid = "realme 6";
const char* password = "12345678";
BlynkTimer timer;

const int ledPin = 4;

String pwmSliderValue = "0";

const int frequencyHz = 5000;
const int pwmChannel = 0;
const int resolution = 8;

const char* INPUT_PARAMETER = "value";

AsyncWebServer webServer(80);

const char htmlCode[] PROGMEM = R"rawliteral(
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>LED Brightness Control</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      text-align: center;
      background-color: #f0f0f0;
    }
    #brightnessContainer {
      max-width: 300px;
      margin: 40px auto;
      background-color: #fff;
      padding: 20px;
      border: 1px solid #ddd;
      border-radius: 10px;
      box-shadow: 0 0 10px rgba(0,0,0,0.1);
    }
    .slider {
      -webkit-appearance: none;
      margin: 0px;
      width: 300px;
      height: 10px;
      border-radius: 5px;
      background: #a739de;
      outline: none;
    }
    .slider::-webkit-slider-thumb {
      appearance: none;
      width: 20px;
      height: 20px;
      border-radius: 10px;
      background: #f74ac0;
      cursor: pointer;
    }
    #brightnessSlider, #brightnessInput {
      width: 100%;
      margin-bottom: 20px;
    }
    #brightnessValue {
      font-size: 24px;
      font-weight: bold;
      margin-bottom: 20px;
    }
    @media only screen and (max-width: 600px) {
      #brightnessContainer {
        width: 80%;
      }
    }
  </style>
</head>
<body>
  <div id="brightnessContainer">
    <h1>LED Brightness Control</h1>
    <label for="brightnessSlider" >Select brightness percentage (0-100):</label>
    <input type="range" onchange="updateSliderPWM(this)" id="brightnessValue" min="0" max="100" value="%SLIDERVALUE%" step="1" class="slider">
    <p>OR</p>
    <label for="brightnessInput" display: block><span>Enter the percentage directly:</span></label>
    <input type="number" onchange="updateInputPWM(this)" id="brightnessInput" min="0" max="100" value="%SLIDERVALUE%" step="1">
    <p><span id="textSliderValue">%SLIDERVALUE%</span> &#37</p>
  </div>
  <script>
    function updateSliderPWM(element) {
      var pwmSliderValue = document.getElementById("brightnessValue").value;
      document.getElementById("textSliderValue").innerHTML = pwmSliderValue;
      document.getElementById("brightnessInput").value = pwmSliderValue;
      console.log(pwmSliderValue);
      var httpRequest = new XMLHttpRequest();
      httpRequest.open("GET", "/slider?value="+pwmSliderValue, true);
      httpRequest.send();
    }
    function updateInputPWM(element) {
      var pwmSliderValue = document.getElementById("brightnessInput").value;
      document.getElementById("textSliderValue").innerHTML = pwmSliderValue;
      document.getElementById("brightnessValue").value = pwmSliderValue;
      console.log(pwmSliderValue);
      var httpRequest = new XMLHttpRequest();
      httpRequest.open("GET", "/slider?value="+pwmSliderValue, true);
      httpRequest.send();
    }
  </script>
</body>
</html>


)rawliteral";

String updateButton(const String& var){
  if (var == "SLIDERVALUE"){
    return pwmSliderValue;
  }
  return String();
}

void setup(){
  Serial.begin(115200);
  
  ledcSetup(pwmChannel, frequencyHz, resolution);
  ledcAttachPin(ledPin, pwmChannel);
  
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi..");
  }

  Serial.println(WiFi.localIP());

  webServer.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
    request->send_P(200, "text/html", htmlCode, updateButton);
  });

  webServer.on("/slider", HTTP_GET, [] (AsyncWebServerRequest *request) {
    String inputMessage;
    if (request->hasParam(INPUT_PARAMETER)) {
      inputMessage = request->getParam(INPUT_PARAMETER)->value();
      pwmSliderValue = inputMessage;
      ledcWrite(pwmChannel, map(pwmSliderValue.toInt(), 0, 100, 0, 255));
    }
    else {
      inputMessage = "No message sent";
    }
    Serial.println(inputMessage);
    request->send(200, "text/plain", "OK");
  });

  webServer.on("/setBrightness", HTTP_GET, [] (AsyncWebServerRequest *request) {
    String inputMessage;
    if (request->hasParam(INPUT_PARAMETER)) {
      inputMessage = request->getParam(INPUT_PARAMETER)->value();
      pwmSliderValue = inputMessage;
      ledcWrite(pwmChannel, map(pwmSliderValue.toInt(), 0, 100, 0, 255));
    }
    else {
      inputMessage = "No message sent";
    }
    Serial.println(inputMessage);
    request->send(200, "text/plain", "OK");
  });
  
  webServer.begin();
  Blynk.begin(auth, ssid, password);
  }
 
void loop(){
 Blynk.run();
  timer.run();
}


BLYNK_WRITE(V0) {
  int data = param.asInt();
  ledcWrite(pwmChannel, map(data, 0, 100, 0, 255));
}
