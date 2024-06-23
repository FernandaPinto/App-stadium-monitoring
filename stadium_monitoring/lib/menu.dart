import 'package:flutter/material.dart';
import 'customVisuals.dart';
import 'sideMenu.dart';
import 'mainScreen.dart';
import 'package:flutter/services.dart';

List<String> units = ["Maquete", "Default0", "Default1"];

void main()  {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const AppSideMenu());
}

class AppSideMenu extends StatelessWidget {
  @override
  const AppSideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Menu(),
    );
  }
}

class Menu extends StatelessWidget{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 2,
          leading: IconButton(
                icon: Container(
                  width: 30.0,
                  height: 30.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.appButtonPurple,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54,
                        spreadRadius: 0.5,
                        blurRadius: 1,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'i',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
              ),
        ),
      ),
      drawer: Drawer(
        width:270,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(1),
            bottomRight: Radius.circular(1),
          ),
        ),
        child: contentDrawer(context),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 15),
            _image(imagePath: 'assets/images/Logo_Space.png'),
            const SizedBox(height: 8),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                    itemCount: units.length,
                    itemBuilder: (context, index){
                      final unitName = units[index];
                      return ListTile(
                        title: GestureDetector(
                          onTap: () async {
                            currentUnit = unitName;
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const MainApp())
                            );
                          },
                          child: _imageBG(
                            imagePath: 'assets/images/Button.png',
                            nameStyle: CustomTextFieldStyle.labelStyleDefault(bold: false, fontsize: 12),
                            name: unitName,
                            width: 400,
                            height: 143,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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

Widget _imageBG({
  String imagePath = 'assets/images/Stadium.png',
  String name = 'Test Name',
  required TextStyle nameStyle ,
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
        top: 109,
        child: Text(
          name,
          textAlign: aling,
          style: nameStyle,
        ),
      ),
      Positioned(
        right: 160,
        top: 109,
        child:  _image(imagePath: path, width: 16, height: 16),
      ),
    ],
  );
}


