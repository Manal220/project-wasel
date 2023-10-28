// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'MyPage.dart';
import 'HomePage.dart';
import 'EditBookPage.dart';
import 'dart:async';

class ProfilePage extends StatefulWidget {
  final String? notification;

  const ProfilePage({Key? key, this.notification}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _notification;
  Timer? _notificationTimer;
  int _currentIndex = 4;
  final List<Widget> _pages = [
    HomePage(),
    HomePage(),
    HomePage(),
    HomePage(),
    ProfilePage(),
  ];
  final user = FirebaseAuth.instance.currentUser!;

  Future<String> getUsername(String uid) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot documentSnapshot = await firestore.collection('users').doc(uid).get();
    if (documentSnapshot.exists) {
      return (documentSnapshot.data() as Map<String, dynamic>)['username'] ?? 'No Username';
    } else {
      return 'User not found';
    }
  }

  @override
  void initState() {
    super.initState();
    // قم بتعيين التنبيه هنا باستخدام القيمة المرسلة
    _notification = widget.notification;

    if (_notification != null) {
      // إعداد المؤقت لإخفاء التنبيه بعد 5 ثوانٍ
      _notificationTimer = Timer(Duration(seconds: 5), () {
        setState(() {
          _notification = null;
        });
      });
    }
  }

  @override
  void dispose() {
    _notificationTimer?.cancel();
    super.dispose();
  }
  List<String> bookNames = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(

        automaticallyImplyLeading: false, // هذا يمنع AppBar من إظهار زر الرجوع تلقائيًا
        backgroundColor: Colors.white,  // جعل خلفية AppBar شفافة
        elevation: 0.0,  // إزالة الظل من AppBar
        toolbarHeight: 80.0,  // تحديد ارتفاع AppBar
        title: Container(
          child: Row(
            children: [
              Container(
                width: 320,
                child: Align(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.purple[900],
                      fontSize: 40,
                      fontWeight: FontWeight.bold

                    ),
                  ),  // النص على اليسار
                ),
              ),
              Container(
                child: Align(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyPage()), // استبدل بالصفحة التي تريد الانتقال إليها
                      );
                    },
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.black, // يمكنك تغيير اللون حسب الحاجة
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (_notification != null)
                Container(
                  width: 400,
                  height: 50,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.purple[700],
                      ),
                      SizedBox(width: 10), // المسافة بين الأيقونة والنص
                      Text(
                        _notification!,
                        style: TextStyle(
                          color: Colors.purple[700],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              Container(
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.only(right: 250.0),
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.purple, // أو أي لون آخر تريده للإطار
                  child: CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/wasel.jpeg'), // مسار الصورة الخاصة بك
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 90,
                    child: FutureBuilder<String>(
                      future: getUsername(FirebaseAuth.instance.currentUser?.uid ?? ''),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Text(
                            'Loading...',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          );
                        } else {
                          return Text(
                            snapshot.data ?? 'No Data',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    ),
                  ),

                  SizedBox(width: 10),
                  Container(
                    width: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditProfilePage())
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        'Edit Profile', style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Container(
                width: 350,
                height: 50,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'My Books',
                  style: TextStyle(color: Colors.white,fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 30),
              StreamBuilder(
                stream: FirebaseFirestore.instance.collection('books').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    // استخراج البيانات من الاستجابة
                    var books = snapshot.data!.docs;

                    // تصفية الكتب بناءً على userId
                    var userBooks = books.where((bookDoc) {
                      var bookData = bookDoc.data();
                      var userId = bookData['userId'];
                      return userId == FirebaseAuth.instance.currentUser?.uid;
                    }).toList();

                    if (userBooks.isEmpty) {
                      return Text('No books available for the current user.');
                    }

                    return Container(
                      height: 400, // ارتفاع المربع الذي يحتوي على الكتب
                      child: ListView(
                        shrinkWrap: true, // يضبط الارتفاع تلقائيًا حسب المحتوى
                        children: userBooks.map((bookDoc) {
                          var bookData = bookDoc.data();
                          var bookName = bookData['bookName'];

                          return Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image.asset('assets/book1.jpg', width: 100, height: 100),
                                Container(
                                  width: 250,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Column(
                                    children: [
                                      Text(bookName, style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      )),
                                      Container(
                                        height: 30,
                                        child: IconButton(
                                          icon: Icon(Icons.edit_calendar),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditBookPage(bookData: bookData), // نقل بيانات الكتاب إلى الصفحة الجديدة
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 100,)
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

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfilePage> {
  Timer? _notificationTimer;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  Future<void> updateUserData(String uid, String newUsername, String newPhoneNumber, String newEmail) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'username': newUsername,
        'phone_number': newPhoneNumber,
        'email': newEmail,
      });
    } catch (error) {
      print('Error updating user data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Container(
            width: 15,
            height: 18,
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.purple,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'profile',
          style: TextStyle(
            color: Colors.purple,
            fontSize: 25,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.purple,
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage('assets/wasel.jpeg'),
                ),
              ),
              SizedBox(height: 100,),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: 60.0, bottom: 10.0), // هنا يمكنك ضبط المسافة حسب الحاجة
                child: Text(
                  "New Username",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: usernameController, // هذا لحقل الإدخال الخاص بالاسم
                  decoration: InputDecoration(
                    labelText: 'Enter New Username',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: 60.0, bottom: 10.0), // هنا يمكنك ضبط المسافة حسب الحاجة
                child: Text(
                  "New Phone Number",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: phoneNumberController, // هذا لحقل الإدخال الخاص برقم الهاتف
                  decoration: InputDecoration(
                    labelText: 'Enter New Phone Number',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.bottomLeft,
                padding: EdgeInsets.only(left: 60.0, bottom: 10.0), // هنا يمكنك ضبط المسافة حسب الحاجة
                child: Text(
                  "New Email",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
              Container(
                height: 55,
                width: 300,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: emailController, // هذا لحقل الإدخال الخاص بالبريد الإلكتروني
                  decoration: InputDecoration(
                    labelText: 'Enter New Email',
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 90,),
              Container(
                height: 60,
                width: 300,
                child: ElevatedButton(
                  onPressed: () async {
                    // احصل على معرف المستخدم الحالي
                    String? uid = FirebaseAuth.instance.currentUser?.uid;

                    // احصل على القيم الجديدة من حقول الإدخال
                    String newUsername = usernameController.text; // استخرج القيمة من حقل الإدخال الخاص بالاسم
                    String newPhoneNumber = phoneNumberController.text; // استخرج القيمة من حقل الإدخال الخاص برقم الهاتف
                    String newEmail = emailController.text; // استخرج القيمة من حقل الإدخال الخاص بالبريد الإلكتروني


                    // قم بتحديث البيانات في Firestore
                    await updateUserData(uid!, newUsername, newPhoneNumber, newEmail);

                    // انتقل إلى صفحة ProfilePage وقم بإرسال التنبيه إليها
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(notification: 'Profile updated successfully'),
                      ),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('Save', style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



