import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReplyMessageScreen extends StatefulWidget {
  final String recipientId;
  final String docId;
  // final senderPhoneNumber = messageData['senderPhoneNumber'];
  // final String receiverPhoneNumber;
  final Map<String, dynamic> originalMessageData;

  const ReplyMessageScreen({
    super.key,
    required this.recipientId,
    required this.docId,
    required this.originalMessageData,
    String? receiverPhoneNumber,
    // required this.receiverPhoneNumber,
  });

  @override
  State<ReplyMessageScreen> createState() => _ReplyMessageScreenState();
}

class _ReplyMessageScreenState extends State<ReplyMessageScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(user!.uid).get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController replyController = TextEditingController();
    final User? user = FirebaseAuth.instance.currentUser;

    // String sender
    // final senderPhoneNumber = user!.phoneNumber;
    // print(userData!['Name']);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Răspundeți la mesaj'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Scrieți răspunsul aici:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: replyController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Scrieți răspunsul aici...',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final replyMessage = {
                  'senderId': user!.uid,
                  'recipientId': widget.recipientId,
                  'content': replyController.text,
                  'timestamp': Timestamp.now(),
                  'isRead': false,
                  'addTitle': 'Re: ${widget.originalMessageData['addTitle']}',
                  'senderEmail': user.email,
                  'senderName': userData!['Name'] + ' ' + userData!['Surname'],
                  'senderPhoneNumber': userData!['PhoneNumber'],
                  // 'senderName': user.displayName ?? 'Anonim',
                  // 'senderPhoneNumber':
                  //     senderPhoneNumber, // Adăugați numărul de telefon aici
                };

                FirebaseFirestore.instance
                    .collection('Messages')
                    .doc(widget.docId)
                    .update({
                  'messages': FieldValue.arrayUnion([replyMessage]),
                }).then((_) {
                  Navigator.of(context).pop();
                });
              },
              child: const Text('Trimite'),
            ),
          ],
        ),
      ),
    );
  }
}
