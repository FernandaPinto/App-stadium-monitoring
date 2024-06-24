#include <arduino.h>
#include <WiFi.h>
#include <ESP32Servo.h>
#include <Firebase_ESP_Client.h>
#include "addons/TokenHelper.h"
#include "addons/RTDBHelper.h"

Servo servo;  // create servo object to control a servo

FirebaseData Firebase_dataObject;
FirebaseAuth auth;
FirebaseConfig config;
String uid;

unsigned long sendDataPrevMillis = 0;
int intValue;

const int PIN_RAIN = 34;
const int PIN_BUZZER = 23;
const int PIN_SMOKE = 25;
const int PIN_LIGHT = 35;
const int PIN_SERVO = 32;
const int PIN_LEDS[] = {2,4,5,18};

// Insert Firebase project API Key
#define API_KEY "" 

// Insert Authorized Email and Corresponding Password
#define USER_EMAIL ""
#define USER_PASSWORD ""

// Insert RTDB URLefine the RTDB URL */
#define DATABASE_URL "" 

const char* SSID     = ""; // SSID 
const char* PASSWORD = ""; // password WI-FI 

void initWiFi() {
  WiFi.begin(SSID, PASSWORD);
  Serial.print("Connecting to WiFi ..");
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print('.');
    delay(1000);
  }
  Serial.println(WiFi.localIP());
  Serial.println();
}

void setup() {
  Serial.begin(9600);

  // Initialize WiFi
  initWiFi();

  //initialize inputs and outputs
  pinMode(PIN_RAIN, INPUT);
  pinMode(PIN_BUZZER, OUTPUT);  
  pinMode(PIN_SMOKE, INPUT);
  pinMode(PIN_LIGHT, INPUT);
  servo.attach(PIN_SERVO);  // attaches the servo on ESP32 pin

  //Leds Setup
  for(int i = 0; i < 4; i++){
    pinMode(PIN_LEDS[i], OUTPUT);
  }
  

  //initialize user and database
  config.api_key = API_KEY;
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;
  config.database_url = DATABASE_URL;

  Firebase.reconnectWiFi(true);
  Firebase_dataObject.setResponseSize(4096);
  config.token_status_callback = tokenStatusCallback;
  config.max_token_generation_retry = 5;

  Firebase.begin(&config, &auth);

  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.print(uid);

}

void loop() {

  int valueFireSensor = digitalRead(PIN_SMOKE);
  if (valueFireSensor == 0) {
    Firebase.RTDB.setInt(&Firebase_dataObject,"components/sensorFire", 0); //fire
  } else {
    Firebase.RTDB.setInt(&Firebase_dataObject,"components/sensorFire", 1); //no fire
  }

  int valueLightSensor = analogRead(PIN_LIGHT);
  if (valueLightSensor < 3000) { 
    Firebase.RTDB.setInt(&Firebase_dataObject,"components/sensorLight", valueLightSensor);  //enable light
  } else { 
    Firebase.RTDB.setInt(&Firebase_dataObject,"components/sensorLight", valueLightSensor);  //disable light
  }

  int valueRain = analogRead(PIN_RAIN);
  if (valueRain < 2000) { 
    Firebase.RTDB.setInt(&Firebase_dataObject,"components/sensorRain", valueRain); // is raining 
  } else {
    Firebase.RTDB.setInt(&Firebase_dataObject,"components/sensorRain", valueRain); // is not raining 
  }

  Listener();

  delay(1000);
}

void Listener(){

  bool enable;

  if (Firebase.ready() && (millis() - sendDataPrevMillis > 15000 || sendDataPrevMillis == 0)){
    sendDataPrevMillis = millis();
    
    //actuatorRain -> servo motor
    if (Firebase.RTDB.getInt(&Firebase_dataObject, "components/actuatorRain")){
      intValue = Firebase_dataObject.intData();
      Serial.println(intValue);
      if(intValue == 1){
        enable = true;
        RoofControl(enable, 0);
      }else if(intValue == 0){
        enable = false;
        RoofControl(enable, 0);
      }else{
        enable = false;
        RoofControl(enable, 1);
      }
    }

    //actuatorFire -> buzzer
    if(Firebase.RTDB.getInt(&Firebase_dataObject, "components/actuatorFire")){
      intValue = Firebase_dataObject.intData();
      Serial.println(intValue);
      if(intValue == 1){
        Buzzer(true);
      }
    }

    //actuatorLight -> lights
    if(Firebase.RTDB.getInt(&Firebase_dataObject, "components/actuatorLight")){
      intValue = Firebase_dataObject.intData();
      Serial.println(intValue);
      if(intValue == 1){
        TurnLights(true);
      }else{
        TurnLights(false);
      }
    }
  }
}

void TurnLights(bool enable){
 
  if(enable == true){
   
    for(int i = 0; i < 4; i++){
      digitalWrite(PIN_LEDS[i], 1);  
    }

  }else{

    for(int i = 0; i < 4; i++){
      digitalWrite(PIN_LEDS[i], 0);  
    } 

  }
}

void Buzzer(bool enable){
  int cont = 10;
  if(enable == true){
    while(cont > 0){
      digitalWrite(PIN_BUZZER, HIGH);   
      delay(500);                   
      digitalWrite(PIN_BUZZER, LOW); 
      delay(500);
      Serial.println(cont);  
      cont--;
    }
  }
}

void RoofControl(bool enable, int stop) {
  int cont = 100;

  servo.attach(PIN_SERVO);

  if (enable && stop == 0) {
    while (cont > 0) {
      servo.write(0);
      delay(100);
      cont--;
    }
  } else if (enable==false && stop == 0) {
    while (cont > 0) {
      servo.write(180);
      delay(100);
      cont--;
    }
  } else if (stop == 1) {
    // Desanexa o servo quando stop é 1
    servo.detach();
    return;
  }
}


