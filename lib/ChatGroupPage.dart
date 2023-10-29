import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'HomePage.dart';
import 'ProfilePage.dart';
import 'AllBooksPage.dart';
import 'ShoppingCartPage.dart';

class ChatGroupPage extends StatefulWidget {
  const ChatGroupPage({Key? key}) : super(key: key);

  @override
  State<ChatGroupPage> createState() => _ChatGroupPageState();
}

class _ChatGroupPageState extends State<ChatGroupPage> {


  int _currentIndex = 1;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "قروبات الكتب",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          textAlign: TextAlign.center,
        ),
      ),

      body: GroupListWidget(),

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

class GroupListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('groups').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('حدث خطأ: ${snapshot.error}'),
          );
        }

        final groups = snapshot.data?.docs ?? [];

        if (groups.isEmpty) {
          return Center(
            child: Text('لا توجد قروبات.'),
          );
        }

        return ListView.builder(
          itemCount: groups.length,
          itemBuilder: (context, index) {
            final groupData = groups[index].data() as Map<String, dynamic>;
            final groupName = groupData['name'] as String;
            final groupId = groups[index].id;

            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(groupId: groupId),
                  ),
                );
              },

              child: Container(

                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(15),
                ),

                child: Center(
                  child: Text(
                    groupName,
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String groupId;

  ChatScreen({required this.groupId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Stream<QuerySnapshot>? _messagesStream;
  ScrollController _scrollController = ScrollController(); // متحكم التمرير

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }


  void _loadMessages() {
    _messagesStream = _firestore
        .collection('messages')
        .where('groupId', isEqualTo: widget.groupId)
        .orderBy('timestamp')
        .snapshots();

    setState(() {
      _isLoading = false;
    });
  }

  void _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isNotEmpty) {
      await _firestore.collection('messages').add({
        'groupId': widget.groupId,
        'text': messageText,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text('شات القروب',style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('لا توجد رسائل.'));
                }

                final messages = snapshot.data!.docs;

                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  final messageText = message['text'];

                  final messageContainer = Container(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      messageText,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );

                  messageWidgets.add(messageContainer);
                }

                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messageWidgets.length,
                  itemBuilder: (context, index) {
                    return messageWidgets[index];
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'اكتب رسالتك هنا',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}