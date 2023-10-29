import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'ChatGroupPage.dart';
import 'AllBooksPage.dart';
import 'ProfilePage.dart';

class ShoppingCartPage extends StatefulWidget {
  final String bookName;
  final String bookType;
  final String writerName;
  final String bookDescription;
  final String imagePath;

  const ShoppingCartPage({
    Key? key,
    required this.bookName,
    required this.bookType,
    required this.writerName,
    required this.bookDescription,
    required this.imagePath,
  }) : super(key: key);

  @override
  State<ShoppingCartPage> createState() => _ShoppingCartPageState();
}

class _ShoppingCartPageState extends State<ShoppingCartPage> {
  int _currentIndex = 3;
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

  late String userId;
  List<ShoppingCartItem> shoppingCartItems = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });
      getShoppingCartItems(userId);
    } else {
      print('User is not logged in');
    }
  }

  void getShoppingCartItems(String userId) {
    FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          shoppingCartItems.add(ShoppingCartItem(
            bookName: doc['bookName'],
            bookType: doc['bookType'],
            writerName: doc['writerName'],
            bookDescription: doc['bookDescription'],
            imagePath: doc['imagePath'],
          ));
        });
      });
    });
  }


  void deleteCartItem(ShoppingCartItem item) {
    FirebaseFirestore.instance
        .collection('cart')
        .where('userId', isEqualTo: userId) // تأكد من استبدال 'userId' بالحقل المناسب
        .where('bookName', isEqualTo: item.bookName) // تأكد من استبدال 'bookName' بالحقل المناسب
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete(); // حذف الوثيقة
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        title: Text(
          'Shopping Cart',
          style: TextStyle(
            fontSize: 40,
            color: Colors.purple[800],
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: shoppingCartItems.length,
        itemBuilder: (context, index) {
          final item = shoppingCartItems[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            leading: Image.asset(
              item.imagePath,
              width: 80,
              height: 120,
              fit: BoxFit.cover,
            ),
            title: Text(item.bookName),
            subtitle: Text(item.bookType),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  deleteCartItem(shoppingCartItems[index]);
                  shoppingCartItems.removeAt(index);
                });
              },
            ),
            tileColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 30.0,
        backgroundColor: Colors.grey[400],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront, color: Colors.black),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black),
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

class ShoppingCartItem {
  final String bookName;
  final String bookType;
  final String writerName;
  final String bookDescription;
  final String imagePath;

  ShoppingCartItem({
    required this.bookName,
    required this.bookType,
    required this.writerName,
    required this.bookDescription,
    required this.imagePath,
  });
}
