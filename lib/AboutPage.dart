import 'package:flutter/material.dart';


class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("About wasel",
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.purple[800],
          ),
        ),
        centerTitle: true,
        toolbarHeight: 80,
        iconTheme: IconThemeData(
          color: Colors.purple[800],
          size: 40
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: 350,
                height: 860,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Text(
                '\nAn application that facilitates reading in the simplest way by exchanging or borrowing books. It provides you with the advantage of talking with communities that suit your interest in books.\n\n'

                'Answers to some frequently asked questions:\n\n'

                '1. What does the Wasel application offer?\n'
                    'The service of borrowing books or exchanging them between people at nominal prices.\n\n'

                '2. How can we contact customer service?  by the email\n'
                'waselsupport@hotmail.com\n\n'

                '3. How can I borrow a book I like?\n'
                'Add the book to the shopping cart, then see the times when the book is available, and then determine the appropriate day for you and he/she will communicates with you.\n\n'

                '4. How can I exchange a book with someone else in the application?\n'
                    'Communicate with the author of the book through conversations.\n\n'

                 '5. Can I modify the book information I entered in the application?\n'
                      'Yes, through the icon next to the book.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 20,)
            ],
          ),
        ),
      ),
    );
  }
}
