# Overview
Project focused on monitoring environments with sensors and actuators (C) controlled by an application developed for Flutter(.dart) and the backend was made in **firebase**.

# Hardware
I made an intelligent stadium integrating sensors and actuators with ESP32 to provide automated functionality. The project used three sensors (Light Sensor, Fire Sensor and Rain Sensor), each associated with a specific actuator. 
 - The Light Sensor triggers LEDs for illumination when it detects low light, providing adequate lighting in the stadium.
 - The Fire Sensor, when it detects smoke or fire, activates a Buzzer to alert users, also displaying notifications in the app.
 - The Rain Sensor controls a Servo Motor that closes the stadium roof when it detects rain. Users can manually open or close the roof using the app.
   
   ![Img_0](https://github.com/FernandaPinto/App-stadium-monitoring/assets/83588044/eaacd2fa-3f3e-4920-a500-f3f883ab0984) 

# Application 
I made the application screens in figma to serve as a guide when developing in Android Studio, using the Flutter framework to achieve quick visual results. Below are the screenshots on the device.

   ![Img_1](https://github.com/FernandaPinto/App-stadium-monitoring/assets/83588044/db3dfb4c-e7a9-4daa-b862-edcde5ffa218)

# Backend
To connect the ESP32 to the application, I used Firebase as a platform with a real-time database of sensor and actuator values, along with email and password authentication. 
