import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'LoginPage.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false, // هذا يمنع AppBar من إظهار زر الرجوع تلقائيًا
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios, // هنا يمكنك استخدام أي أيقونة تريدها
            color: Colors.black, // هنا يمكنك تحديد اللون الذي تريده
          ),
          onPressed: () {
            Navigator.pop(context); // هذا الكود يقوم بتنفيذ عملية الرجوع عند النقر على الزر
          },
        ),
        backgroundColor: Colors.white,  // جعل خلفية AppBar شفافة
        elevation: 0.0,  // إزالة الظل من AppBar
        toolbarHeight: 80.0,  // تحديد ارتفاع AppBar
        title: Container(
          width: 250,
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'My Page',
                    style: TextStyle(
                      color: Colors.purple[900],
                      fontSize: 40,
                      fontWeight: FontWeight.bold
                      
                    ),
                  ),  // النص على اليسار
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 80,),
              Container(
                height: 55,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    // الكود الذي تريد تنفيذه عند النقر على الزر
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[400],
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('Favroite', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                height: 55,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    // الكود الذي تريد تنفيذه عند النقر على الزر
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[400],
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Contact Us',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                height: 55,
                width: 300,
                child: ElevatedButton(
                  onPressed: () {
                    // الكود الذي تريد تنفيذه عند النقر على الزر
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[400],
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('About WASEL', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),),
                ),
              ),
              SizedBox(height: 130,),
              Container(
                height: 60,
                width: 500,
                child: ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                      context, 
                      MaterialPageRoute(builder: (context) => LoginPage()), 
                      (Route<dynamic> route) => false
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey[400],
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  child: Text('LOG OUT', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red
                  ),),
                ),
              ),
            ],
          ),
      )),
    );
  }
}