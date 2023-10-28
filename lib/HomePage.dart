// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wasel1/AddBookPage.dart';
import 'EditBookPage.dart';
import 'ProfilePage.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
    ProfilePage(),
  ];
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,  // جعل خلفية AppBar شفافة
        elevation: 0.0,  // إزالة الظل من AppBar
        toolbarHeight: 80.0,  // تحديد ارتفاع AppBar
        title: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Welcome',
                  style: TextStyle(
                    color: Colors.purple[800],
                    fontSize: 40,
                    fontWeight: FontWeight.bold
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
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 50,
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0), // لتحديد التباعد داخل المربع
                    labelText: 'Search',
                    fillColor: Colors.grey[400], // لون الخلفية
                    filled: true, // يجب تحديدها كـ true لتفعيل خاصية fillColor
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0), // لتحديد زوايا المربع
                      borderSide: BorderSide(
                        color: Colors.purple, // لون الحدود
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0), // لتحديد زوايا المربع عند التحديد
                      borderSide: BorderSide(
                        color: Colors.purple, // لون الحدود عند التحديد
                      ),
                    ),
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                height: 55,
                width: 170,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddBookPage()), // استبدل بالصفحة التي تريد الانتقال إليها
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 21, 52, 255),
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    'Add Your Book',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),     
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // يمكنك تعديل هذه القيمة لتحديد مدى تقريب الزوايا
                    child: Image.asset(
                      'assets/book1.jpg',
                      width: 150,
                      height: 150,
                    ),
                  ), // يرجى تحديد مسار الصورة الصحيح
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // يمكنك تعديل هذه القيمة لتحديد مدى تقريب الزوايا
                    child: Image.asset(
                      'assets/book2.png',
                      width: 150,
                      height: 150,
                    ),
                  ), // يرجى تحديد مسار الصورة الصحي // يرجى تحديد مسار الصورة الصحيح
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // يمكنك تعديل هذه القيمة لتحديد مدى تقريب الزوايا
                    child: Image.asset(
                      'assets/book3.jpeg',
                      width: 150,
                      height: 150,
                    ),
                  ), // يرجى تحديد مسار الصورة الصحي // يرجى تحديد مسار الصورة الصحيح
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.0), // يمكنك تعديل هذه القيمة لتحديد مدى تقريب الزوايا
                    child: Image.asset(
                      'assets/book4.png',
                      width: 150,
                      height: 150,
                    ),
                  ), // يرجى تحديد مسار الصورة الصحي // يرجى تحديد مسار الصورة الصحيح
                ],
              ),
              SizedBox(height: 5),
              Container(
                width: 80,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    // الكود الذي تريد تنفيذه عند النقر على الزر
                  },
                  style: ElevatedButton.styleFrom(
                      primary: Colors.black,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  child: Text('Other',style: TextStyle(
                    fontSize: 18,
                  ),),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // هنا تحديد النوع كثابت
        iconSize: 30.0, // هنا تحديد حجم الأيقونة
        backgroundColor: Colors.grey[400],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.black,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.black,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront, color: Colors.black,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black,),
            label: '',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_currentIndex != index) {
            setState(() {
              _currentIndex = index;
            });
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => _pages[_currentIndex]),
            );
          }
        },
      ),
    );
  }
}