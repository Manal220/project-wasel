import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'HomePage.dart';
import 'ChatGroupPage.dart';
import 'ProfilePage.dart';
import 'BookDetailsPage.dart';
import 'ShoppingCartPage.dart';
class AllBooksPage extends StatefulWidget {
  const AllBooksPage({Key? key}) : super(key: key);

  @override
  State<AllBooksPage> createState() => _AllBooksPageState();
}

class _AllBooksPageState extends State<AllBooksPage> {
  Future<List<String>> fetchBookNames() async {
    final QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('books').get();
    final List<String> bookNames =
    snapshot.docs.map((doc) => doc['bookName'] as String).toList();
    return bookNames;
  }

  int _currentIndex = 2;
  final List<Widget> _pages = [
    HomePage(),
    ChatGroupPage(),
    AllBooksPage(),
    ShoppingCartPage(
      bookName: '',
      bookType: '',
      writerName: '',
      bookDescription: '',
      imagePath: '',
    ),
    ProfilePage(),
  ];

  String searchQuery = ''; // إضافة متغير لتخزين نص البحث

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        toolbarHeight: 88,
        title: Text(
          "Books",
          style: TextStyle(
            color: Colors.purple[800],
            fontSize: 35,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  height: 50,
                  width: 300,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value; // تحديث قيمة البحث عند تغيير النص
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      labelText: 'Search',
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(
                          color: Colors.purple,
                        ),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
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
                      var filteredBooks = books.where((bookDoc) {
                        var bookData = bookDoc.data();
                        var bookName = bookData['bookName'];
                        return bookName.toLowerCase().contains(searchQuery.toLowerCase());
                      }).toList();

                      return Container(
                        height: 630,
                        child: ListView(
                          children: filteredBooks.map((bookDoc) {
                            var bookData = bookDoc.data();
                            var bookName = bookData['bookName'];
                            var bookType = bookData['bookType'];
                            var writerName = bookData['writerName'];
                            var bookDescription = bookData['bookDescription'];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BookDetailsPage(
                                      bookName: bookName,
                                      bookType: bookType,
                                      writerName: writerName,
                                      bookDescription: bookDescription,
                                      imagePath: 'assets/book1.jpg',
                                      documentId: bookDoc.id, // إضافة Document ID كمعلمة إضافية
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset('assets/book1.jpg', width: 100, height: 200),
                                    Container(
                                      width: 250,
                                      child: Column(
                                        children: [
                                          Text(
                                            bookName,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
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
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30.0,
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
