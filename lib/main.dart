
import 'package:wasel1/HomePage.dart';

import 'EditBookPage.dart';
// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'Auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyLoginApp());
}

class MyLoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      routes: {
        '/editBook': (context) => HomePage(),
        '/shoppingCart': (context) => HomePage(),
        '/home':(context) => HomePage(),
      },

      debugShowCheckedModeBanner: false,
      home: const Auth(),
    );
  }
}


