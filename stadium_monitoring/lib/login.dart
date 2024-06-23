import 'menu.dart';
import 'register.dart';
import 'customVisuals.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

FirebaseAuth auth = FirebaseAuth.instance;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const LoginApp()));
}

class LoginApp extends StatelessWidget {
  const LoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Column( //Main Content
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            _image(),
            const SizedBox(height: 120),
            _buildLoginLabelWithSignUp(context),
            const SizedBox(height: 5),
            _buildLoginLabel(),
            _buildTextField(_emailController, 'E-mail'),
            const SizedBox(height: 5),
            _buildTextField(_passwordController, 'Senha', obscureText: true),
            const LoginButton(),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
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

  Widget _buildLoginLabelWithSignUp(BuildContext context) {
    return GestureDetector(
            onTap: () {
              // Code for navigation to the registration page can be added here
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
            child: RichText(
              text: const TextSpan(
                text: 'Não tem cadastro? ', // Regular text
                style: TextStyle(color: Colors.white),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Cadastre-se', // Styled text for action
                    style: TextStyle(
                      color: Colors.yellow, // Color of the action text
                      decoration: TextDecoration.underline, // Underline for emphasis
                    ),
                  ),
                ],
              ),
            ),
      );
  }

  //[Visual]Login Container
  Widget _buildLoginLabel() {
    return Center(
      child: Container(
        width: 315,
        height: 20,
        decoration: const BoxDecoration(color: AppColors.appYellowColor,  border: null),
        child: Center(
          child: Text(
            'Login',
            style: CustomTextFieldStyle.labelStyleDefault(),
          ),
        ),
      ),
    );
  }

  //[Visual]Input Text Container
  Widget _buildTextField(TextEditingController _local, String labelText, {bool obscureText = false}) {
    return Center(
      child: Container(
        width: 315,
        height: 90,
        decoration: const BoxDecoration(color: AppColors.appfontWhite,  border: null),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
          child: TextField(
            controller: _local,
            decoration: InputDecoration(
              labelText: labelText,
              labelStyle: CustomTextFieldStyle.labelStyleInputText,
            ),
            enabled: true,
            obscureText: obscureText,
          ),
        ),
      ),
    );
  }
}

//[Dynamic] Button
class LoginButton extends StatefulWidget {
  const LoginButton({super.key});

  @override
  _LoginButtonState createState() => _LoginButtonState();
}

class _LoginButtonState extends State<LoginButton> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child:SizedBox(
            width: 315,
            height: 20,
            child: ElevatedButton(
              onPressed: () async{
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AppSideMenu())
                  );
                } on FirebaseAuthException catch (e) {
                  QuickAlert.show(
                    context: context,
                    borderRadius: 2,
                    type: QuickAlertType.error,
                    title: 'Oops...',
                    text: 'Dados incorretos',
                  );
                }
              },
              style: CustomButtonStyle.elevatedButtonStyle(),
              child: Text("Entrar", style: CustomTextFieldStyle.labelStyleDefault(color: AppColors.appfontWhite)),
            )
        )
    );
  }
}



