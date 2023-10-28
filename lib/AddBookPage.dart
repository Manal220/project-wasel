import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBookPage extends StatefulWidget {
  const AddBookPage({super.key});

  @override
  State<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends State<AddBookPage> {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _bookTypeController = TextEditingController();
  final TextEditingController _writerNameController = TextEditingController();
  final TextEditingController _bookDescriptionController = TextEditingController();


  Future<String?> getFirebaseUserUUID(String uid) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String? uuid = user.uid;
      return uuid;
    } else {
      return null;
    }
  }

  void _addBookToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userUuid = user.uid;

      await FirebaseFirestore.instance.collection('books').add({
        'userId': userUuid,
        'bookName': _bookNameController.text,
        'bookType': _bookTypeController.text,
        'writerName': _writerNameController.text,
        'bookDescription': _bookDescriptionController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          size: 30,
          color: Colors.black, // قم بتغيير اللون إلى اللون الذي تفضله
        ),
        backgroundColor: Colors.white,  // جعل خلفية AppBar شفافة
        elevation: 0.0,  // إزالة الظل من AppBar
        toolbarHeight: 80.0,  // تحديد ارتفاع AppBar
        title: Row(
          children: [
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
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(9),
              child: Text(
                'Add Your Book.',
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.purple[900],
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 60.0, bottom: 10.0), // هنا يمكنك ضبط المسافة حسب الحاجة
              child: Text(
                "Book Name",
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _bookNameController, // هذا لحقل الإدخال الخاص بالاسم
                decoration: InputDecoration(
                  labelText: 'Enter Book Name',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 60.0, bottom: 10.0), // هنا يمكنك ضبط المسافة حسب الحاجة
              child: Text(
                  "Book Type",
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _bookTypeController, // هذا لحقل الإدخال الخاص بالاسم
                decoration: InputDecoration(
                  labelText: 'Enter Book Type',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 60.0, bottom: 10.0), // هنا يمكنك ضبط المسافة حسب الحاجة
              child: Text(
                "Writer Name",
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _writerNameController, // هذا لحقل الإدخال الخاص بالاسم
                decoration: InputDecoration(
                  labelText: 'Enter Writer Name',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.bottomLeft,
              padding: EdgeInsets.only(left: 60.0, bottom: 10.0), // هنا يمكنك ضبط المسافة حسب الحاجة
              child: Text(
                "Book Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.end,
              ),
            ),
            Container(
              height: 140,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _bookDescriptionController, // هذا لحقل الإدخال الخاص بالاسم
                decoration: InputDecoration(
                  labelText: 'Enter Book Description',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              width: 100,
              height: 55,
              child: ElevatedButton(
                onPressed: () async {
                  _addBookToFirestore(); // انتظر حتى انتهاء إضافة الكتاب
                  // عرض تشيكبوكس والانتقال إلى الصفحة الرئيسية هنا
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Book Added Successfully'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // إغلاق التشيكبوكس
                              Navigator.of(context).pop();
                              // عد إلى الصفحة الرئيسية
                              Navigator.of(context).pop();
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
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
                  'Confirm',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
