import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ShoppingCartPage.dart';

class BookDetailsPage extends StatelessWidget {
  final String bookName;
  final String bookType;
  final String writerName;
  final String bookDescription;
  final String imagePath;
  final String documentId;

  BookDetailsPage({
    required this.bookName,
    required this.bookType,
    required this.writerName,
    required this.bookDescription,
    required this.imagePath,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.purple[800],
          size: 40,
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 80,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    imagePath,
                    width: 130,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '$bookName',
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'By $writerName',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 19),
                      Text(
                        'Type: $bookType',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 19),
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                          print(documentId);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Center(
                child: Container(
                  width: 400,
                  height: 300,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                  ),
                  child: Text(
                    bookDescription,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 70),
              Center(
                child: Container(
                  width: 130,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () async {
                      // جلب معرف المستخدم الحالي
                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        String uid = user.uid;
                        // إضافة المعلومات إلى Firestore
                        FirebaseFirestore.instance.collection('cart').add({
                          'bookName': bookName,
                          'bookType': bookType,
                          'writerName': writerName,
                          'bookDescription': bookDescription,
                          'imagePath': imagePath,
                          'userId': uid, // استخدام معرف المستخدم
                          'documentId': documentId,
                        }).then((value) {
                          print("Added to cart successfully!");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShoppingCartPage(
                                bookName: bookName,
                                bookType: bookType,
                                writerName: writerName,
                                bookDescription: bookDescription,
                                imagePath: imagePath,
                              ),
                            ),
                          );
                        }).catchError((error) {
                          print("Failed to add to cart: $error");
                        });
                      } else {
                        print('User is not logged in');
                      }
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
                      'Add To Cart',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
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
