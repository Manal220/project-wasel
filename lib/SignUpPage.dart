// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/gestures.dart';
import 'package:wasel1/HomePage.dart';


// ignore: must_be_immutable
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  bool isPasswordConfirmed = true; // متغير لتحديد ما إذا كانت كلمة المرور مؤكدة
  Color? confirmPasswordBorderColor = Colors.grey[200]; // متغير لتحديد لون الحدود
  
  Future<void> SignUp(BuildContext context) async {
    try {
      // إنشاء حساب جديد
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(), 
        password: passwordController.text.trim()
      );

      // الحصول على uid
      String uid = userCredential.user!.uid;

      // إنشاء مثيل من FirebaseFirestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // حفظ الاسم ورقم الجوال في Firestore
      await firestore.collection('users').doc(uid).set({
        'username': usernameController.text.trim(),
        'phonenumber': phonenumberController.text.trim(),
      });

      // التنقل إلى الصفحة الرئيسية
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      // إذا حدث خطأ، يمكنك التعامل معه هنا
      print(e);
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,  // جعل خلفية AppBar شفافة
        elevation: 0.0,  // إزالة الظل من AppBar
        toolbarHeight: 150.0,  // تحديد ارتفاع AppBar
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'User\nRegistration',
                  style: TextStyle(
                    color: Colors.purple,
                    fontSize: 30,
                  ),
                ),  // النص على اليسار
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topRight,
                child: Image.asset(
                  'assets/wasel.jpeg',  // مسار الصورة التي تريد إضافتها
                  width: 200,  // يمكنك التحكم في العرض
                  height: 200,  // يمكنك التحكم في الارتفاع
                ),  // الصورة على اليمين
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: usernameController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                    errorStyle: TextStyle(color: Colors.red),
                    prefixIcon: Icon(Icons.account_circle, color: Colors.purple,),
                  ),
                ),
              ),
              SizedBox(height: 18,),
              Container(
                width: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: emailController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                    errorStyle: TextStyle(color: Colors.red),
                    prefixIcon: Icon(Icons.email, color: Colors.purple,),
                  ),
                ),
              ),
              SizedBox(height: 18,),
              Container(
                width: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: phonenumberController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                    errorStyle: TextStyle(color: Colors.red),
                    prefixIcon: Icon(Icons.phone_android_outlined, color: Colors.purple,),
                  ),
                ),
              ),
              SizedBox(height: 18,),
              Container(
                width: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                    errorStyle: TextStyle(color: Colors.red),
                    prefixIcon: Icon(Icons.privacy_tip_outlined,color: Colors.purple,),
                  ),
                ),
              ),
              SizedBox(height: 18,),
              Container(
                width: 380,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: confirmPasswordBorderColor, // استخدام المتغير لتحديد لون الحدود
                ),
                child: TextField(
                  controller: confirmpasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                    errorStyle: TextStyle(color: Colors.red),
                    prefixIcon: Icon(Icons.privacy_tip, color: Colors.purple,),
                  ),
                  onChanged: (value) {
                    setState(() {
                      isPasswordConfirmed = passwordController.text == confirmpasswordController.text;
                      confirmPasswordBorderColor = (isPasswordConfirmed ? Colors.grey[200] : Colors.red)!;
                    });
                  },
                ),
              ),
              SizedBox(height: 80,),
              Container(
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black,  // تغيير لون الخلفية إلى الأسود
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
                  onPressed: () => SignUp(context),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,  // تغيير لون الزر إلى الأسود
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}