import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBookPage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  EditBookPage({required this.bookData});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  final TextEditingController _bookNameController = TextEditingController();
  final TextEditingController _authorNameController = TextEditingController();
  final TextEditingController _bookDescriptionController = TextEditingController();
  final TextEditingController _bookTypeController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _bookNameController.text = widget.bookData['bookName'];
    _bookTypeController.text = widget.bookData['bookType'];
    _authorNameController.text = widget.bookData['writerName'];
    _bookDescriptionController.text = widget.bookData['bookDescription'];
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          size: 30,
          color: Colors.purple[900], // قم بتغيير اللون إلى اللون الذي تفضله
        ),
        backgroundColor: Colors.white,  // جعل خلفية AppBar شفافة
        elevation: 0.0,  // إزالة الظل من AppBar
        toolbarHeight: 130.0,  // تحديد ارتفاع AppBar
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(50),
              child: Text(
                'Edit Book\nDescription',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[800],
                ),
              ),  // الصورة على اليمين
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 30,),
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
                  controller: _authorNameController, // هذا لحقل الإدخال الخاص بالاسم
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
                    final updatedData = {
                      'bookName': _bookNameController.text,
                      'bookType': _bookTypeController.text,
                      'writerName': _authorNameController.text,
                      'bookDescription': _bookDescriptionController.text,
                    };

                    await FirebaseFirestore.instance
                        .collection('books')
                        .doc(widget.bookData['documentId']) // استخدم معرف الوثيقة لتحديث الوثيقة الصحيحة
                        .update(updatedData)
                        .then((_) {
                      // تم التحديث بنجاح
                      print('تم التحديث بنجاح');
                      Navigator.pop(context);
                    })
                        .catchError((error) {
                      // حدث خطأ أثناء التحديث
                      print('حدث خطأ أثناء التحديث: $error');
                    });

// قم بإعادة الانتقال إلى صفحة التفاصيل أو أي صفحة أخرى بعد تحديث البيانات
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
