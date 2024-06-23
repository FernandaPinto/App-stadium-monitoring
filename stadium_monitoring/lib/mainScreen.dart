import 'package:flutter/material.dart';
import 'package:stadium_monitoring/dataBase.dart';
import 'customVisuals.dart';
import 'menu.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';

String currentUnit = "";
List<String> sensorsInfo = [];
int currentIndex = 0;
String path="";

List<String> paths = [
  'assets/images/Alarm_0.png',
  'assets/images/Alarm_1.png',
  'assets/images/Alarm_2.png',
];

List<String> sensorsName = [
  'sensorLight',
  'sensorFire',
  'sensorRain',
];

class Path {
  static int generateRandomNumber(int min, int max) {
    Random random = Random();
    return min + random.nextInt(max - min + 1);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const MainPage(),
    );
  }
}


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<String> sensorData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
    setupRealtimeUpdates();
  }

  Future<void> fetchData() async {
    List<String> data = [];
    for (String sensorName in sensorsName) {
      String sensorInfo = await readData(sensorName);
      data.add(sensorInfo);
    }
    setState(() {
      sensorData = data;
      isLoading = false;  // define isLoading como false após carregar os dados
    });
  }

  void setupRealtimeUpdates() {
    DatabaseReference sensorsRef = FirebaseDatabase.instance.ref().child('components');
    sensorsRef.onValue.listen((event) {
      final Map<dynamic, dynamic>? sensorUpdates = event.snapshot.value as Map<dynamic, dynamic>?;
      if (sensorUpdates != null) {
        List<String> updatedData = [];
        for (String sensorName in sensorsName) {
          updatedData.add(sensorUpdates[sensorName].toString());
        }
        setState(() {
          sensorData = updatedData;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(7),
        child: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 2,
        ),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 15),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryColor, elevation: 0, padding: EdgeInsets.zero),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AppSideMenu()));
                  },
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 22),
                ),
                const SizedBox(width: 90),
                _image(imagePath: 'assets/images/Logo_Space.png'), // logo image
              ],
            ),
            const SizedBox(height: 15),
            _imageBG(
              nameStyle: CustomTextFieldStyle.labelStyleDefault(bold: true, fontsize: 12),
              name: currentUnit,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Expanded(
              child: GridView.count(
                mainAxisSpacing: 10,
                crossAxisSpacing: 0,
                crossAxisCount: 2,
                children: List.generate(
                  sensorData.length,
                      (index) {
                    if (int.parse(sensorData[index]) >= 0) {
                      currentIndex = index;
                      if (index == 0) {
                        // Light sensor
                        path = int.parse(sensorData[0]) < 3000 ? paths[2] : paths[1];
                      } else if (index == 1) {
                        // Fire sensor
                        path = int.parse(sensorData[1]) == 0 ? paths[2] : paths[1];
                      } else if (index == 2) {
                        // Rain sensor
                        path = int.parse(sensorData[2]) < 2000 ? paths[2] : paths[1];
                      } else {
                        path = paths[0]; //disable
                      };
                      return SizedBox(
                        height: 5, // Set your desired height here
                        child: Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: AppColors.backSensorWidget,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                spreadRadius: 0.5,
                                blurRadius: 1,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _buildSensorLabel(text: sensorsName[index].toString(), path: path),

                              const SizedBox(height: 4),
                              _sensorInformation(sensorInfo: sensorData[index]),
                              if (index == 0) ...[
                                const SizedBox(height: 4),
                                ActionButton(index, 1, "Ligar", 28, 0), // Light -> activate lights
                                const SizedBox(height: 2),
                                ActionButton(index, 0, "Desligar", 28, 15.0),
                              ],
                              if (index == 1) ...[
                                const SizedBox(height: 33),
                                ActionButton(index, 1, "Ligar", 29, 15.0), // Fire -> activate buzzer
                              ],
                              if (index == 2) ...[
                                ActionButton(index, 1, "Abrir", 20, 0),  // Rain -> rotate end stop the servo
                                const SizedBox(height: 1),
                                ActionButton(index, 0, "Fechar", 20, 0),
                                const SizedBox(height: 1),
                                ActionButton(index, 2, "Desligar", 20, 15.0),
                              ],
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}

//[Dynamic] Button
class ActionButton extends StatefulWidget {
  final int index;
  final int action;
  final String textField;
  final double heightButton;
  final double border;

  const ActionButton(this.index, this.action,this.textField, this.heightButton, this.border,  {super.key});

  @override
  _ActionButtonState createState() => _ActionButtonState();
}

class _ActionButtonState extends State<ActionButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 315,
        height: widget.heightButton,
        child: ElevatedButton(
          onPressed: () {
            handleAction(widget.index, widget.action);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.appButtonPurple,
            shape:  RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.border),
                bottomRight: Radius.circular(widget.border),
              ),
            ),
          ),
          child: Text(widget.textField, style: CustomTextFieldStyle.labelStyleDefault(color: AppColors.appfontWhite, fontsize: 11)),
        ),
      ),
    );
  }
}

void handleAction(int sensorIndex, int action) {
  switch (sensorIndex) {
    case 0:
      sendData("actuatorLight", action);
      break;
    case 1:
      sendData("actuatorFire", action);
      break;
    case 2:
      sendData("actuatorRain", action);
      break;
  }
}

Widget _sensorInformation({
  required String sensorInfo,
}) {
  return Center(
    child: Container(
      width: 138,
      height: 80,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A424E), Color(0xFF322D31)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          sensorInfo,
          style: CustomTextFieldStyle.labelStyleDefault(color: AppColors.appfontWhite, fontsize: 11),
        ),
      ),
    ),
  );
}

Widget _buildSensorLabel({
  String text = 'default',
  String path = '',
}) {
  return Align(
    alignment: Alignment.topCenter,
    child: Container(
      width: 315,
      height: 28,
      decoration: const BoxDecoration(
        color: AppColors.appYellowColor,
        border: null,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            spreadRadius: 0.3,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image(imagePath: path, width: 20, height: 20),
            const SizedBox(width: 5),
            Text(
              text,
              style: CustomTextFieldStyle.labelStyleDefault(color: AppColors.appfontPurple, fontsize: 11),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _imageBG({
  String imagePath = 'assets/images/Stadium.png',
  String name = 'Test Name',
  required TextStyle nameStyle,
  TextAlign aling = TextAlign.left,
  double width = double.infinity,
  double height = 80,
  BoxFit fit = BoxFit.cover,
}) {
  return Stack(
    alignment: Alignment.centerLeft,
    children: [
      ClipRect(
        child: Image.asset(
          imagePath,
          width: width,
          height: height,
          fit: fit,
        ),
      ),
      Positioned(
        left: 11,
        top: 57,
        child: Text(
          name,
          textAlign: aling,
          style: nameStyle,
        ),
      ),
    ],
  );
}

Widget _image({
  required String imagePath,
  double width = 50,
  double height = 40,
  BoxFit fit = BoxFit.contain,
}) {
  return Center(
    child: ClipRect(
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
      ),
    ),
  );
}