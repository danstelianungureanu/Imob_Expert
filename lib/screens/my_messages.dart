// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart';

// import '../widgets/reply_message_widget.dart';
import 'messages_widget.dart';
// import 'reply_message_screen.dart'; // Asigurați-vă că importăm noul widget

class MyMessages extends StatelessWidget {
  const MyMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mesajele Mele'),
      ),
      body: user != null
          ? messagesWidget(user: user)
          : const Center(child: Text('Nu sunteți autentificat.')),
    );
  }
}
