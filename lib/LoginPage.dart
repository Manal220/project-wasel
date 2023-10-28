// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'SignUpPage.dart';
import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hasError = false;
  String _errorMessage = '';

  Future<void> signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Error Username Or password';
      });
    }
  }



  @override
  DiagnosticsNode toDiagnosticsNode({String? name, DiagnosticsTreeStyle? style}) {
    _usernameController.dispose();
    _passwordController.dispose();
    return super.toDiagnosticsNode(name: name, style: style);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 1.0),  // يحدد المسافة من الجزء العلوي
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/wasel.jpeg',
                      fit: BoxFit.fill,
                      height: 150,
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Container(
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: _hasError ? Colors.red[100] : Colors.grey[200],
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Colors.purple,),
                      errorText: _hasError ? _errorMessage : null,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container( 
                  width: 380,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: _hasError ? Colors.red[100] : Colors.grey[200],
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'password',
                      prefixIcon: Icon(Icons.lock, color: Colors.purple,),
                      errorText: _hasError ? _errorMessage : null,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // هنا يمكنك وضع الكود الذي يجب تنفيذه عند النقر على الزر
                  },
                  child: Text(
                    'Forget Password?',  // هنا تحدد نص الزر
                    style: TextStyle(
                      fontSize: 16,  // هنا تحدد حجم الخط
                      color: Colors.black,  // هنا تحدد لون النص
                    ),
                  ),
                ),
                SizedBox(height: 80,),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () => signIn(context),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 60,),
                TextButton(
                  onPressed: () {},
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(text: "Don't have an Account? "),
                        TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: Colors.purple,
                                fontWeight: FontWeight.bold, 
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUpPage()),
                                );
                              },
                            ),
                      ],
                    ),
                  ),
                ),

                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => SignUpPage()),
                //     );
                //   },
                //   child: Text('إنشاء حساب جديد'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}