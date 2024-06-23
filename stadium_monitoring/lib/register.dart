import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'customVisuals.dart';
import 'dataBase.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

List<String> companies = [];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const RegisterMenu()));
}

class RegisterMenu extends StatelessWidget {
  @override
  const RegisterMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: Register(),
    );
  }
}

class Register extends StatelessWidget{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget build(BuildContext context){
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.primaryColor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(7),
          child: AppBar(
            backgroundColor: AppColors.appBarColor,
            elevation: 2,
          ),
        ),
        body: SafeArea(
          top: true,
          child:Column(
            children: [
              const SizedBox(height: 100),
              _image(),
              const SizedBox(height: 80),
              _Register('Empresa'),
            ]
          ),

        ),

    );
  }
}
Widget _image(){
  return Center(
    child: ClipRect(
      child: Image.asset(
        'assets/images/Logo_Space.png',
        width: 60,
        height: 50,
        fit: BoxFit.contain,
      ),
    ),

  );
}

Widget _Register(String label, {bool obscureText = false}){
  return Center(
    child: Container(
        width: 315,
        height: 181,
        decoration: const BoxDecoration(color: AppColors.appfontWhite,  border: null),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 315,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.appYellowColor,
                border: null,
                borderRadius: BorderRadius.circular(0),
              ),
              child: const Center(
                child: Text(
                  'Cadastro',
                  style: TextStyle(
                    color: AppColors.appfontPurple,
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 13),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              child:  SizedBox(
                height: 40,
                child: TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    fillColor: const Color(0xFFE9E9E9),
                    labelText: 'E-mail',
                    labelStyle: CustomTextFieldStyle.labelStyleDefault(color: const Color(
                        0xFF7E7E7E),fontsize: 12),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                  enabled: true,
                  obscureText: obscureText,
                ),
              ),
            ),
            const SizedBox(height: 13),
           Padding(
             padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
             child: SizedBox(
               height: 40,
               child: TextField(
                 controller: _passwordController,
                 keyboardType: TextInputType.number,
                 decoration: InputDecoration(
                   floatingLabelBehavior: FloatingLabelBehavior.never,
                   filled: true,
                   fillColor: const Color(0xFFE9E9E9),
                   labelText: 'Senha',
                   labelStyle: CustomTextFieldStyle.labelStyleDefault(color: const Color(
                       0xFF7E7E7E),fontsize: 12),
                   border: OutlineInputBorder(
                     borderSide: BorderSide.none,
                     borderRadius: BorderRadius.circular(2.0),
                   ),
                 ),
                 enabled: true,
                 obscureText: obscureText,
               ),
             ),
           ),
           // const SizedBox(height: 13),
            const SizedBox(height: 16),
            const EnterButton(),
          ],
        ),
    ),
  );
}

//[Dynamic] Button
class EnterButton extends StatefulWidget {
  const EnterButton({super.key});

  @override
  _EnterButtonState createState() => _EnterButtonState();
}

class _EnterButtonState extends State<EnterButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child:SizedBox(
            width: 315,
            height: 37,
            child: ElevatedButton(
              onPressed: (){
                registerUser(context, _emailController.text, _passwordController.text);
              },
              style: CustomButtonStyle.elevatedButtonStyle(),
              child: Text("Finalizar", style: CustomTextFieldStyle.labelStyleDefault(color: AppColors.appfontWhite)),
            )
        )
    );
  }
}
