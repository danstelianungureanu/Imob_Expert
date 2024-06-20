// ignore_for_file: camel_case_types

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imob_expert/widgets/reply_message_widget.dart';
import 'package:intl/intl.dart';

class messagesWidget extends StatelessWidget {
  const messagesWidget({
    super.key,
    required this.user,
  });

  final User user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Nu aveți mesaje.'));
        }

        final messages = snapshot.data!.docs
            .expand((doc) => (doc.data() as Map<String, dynamic>)['messages'])
            .where((message) =>
                message['recipientId'] == user.uid &&
                message['isRead'] == false)
            .toList();

        if (messages.isEmpty) {
          return const Center(child: Text('Nu aveți mesaje necitite.'));
        }

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final messageData = messages[index] as Map<String, dynamic>;
            final senderId = messageData['senderId'];
            final messageContent = messageData['content'];
            final timestamp = (messageData['timestamp'] as Timestamp).toDate();
            final subject = messageData['addTitle'] ?? 'Fără subiect';
            final senderEmail =
                messageData['senderEmail'] ?? 'Email necunoscut';
            final senderName = messageData['senderName'] ?? 'Nume necunoscut';
            final senderPhoneNumber =
                messageData['senderPhoneNumber'] ?? 'Telefon necunoscut';

            // Formatarea timestamp-ului
            final formattedDate =
                DateFormat('yyyy-MM-dd HH:mm:ss').format(timestamp);
            final formattedTime = formattedDate.split(' ')[1].substring(0, 5);
            final displayDate = '${formattedDate.split(' ')[0]} $formattedTime';

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.0),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                isThreeLine: true, // Permite mai multe linii
                title: Text(
                  subject,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decoration: TextDecoration.underline,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'A scris:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                    Text(senderName),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(messageContent),
                    ),
                    Text('Telefon $senderPhoneNumber'),
                    Text(senderEmail),
                  ],
                ),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(displayDate),
                    const SizedBox(height: 12), // Spațiu între text și iconițe
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            FirebaseFirestore.instance
                                .collection('Messages')
                                .doc(snapshot.data!.docs[index].id)
                                .update({
                              'messages': FieldValue.arrayRemove([messageData])
                            }).then((_) {
                              messageData['isRead'] = true;
                              FirebaseFirestore.instance
                                  .collection('Messages')
                                  .doc(snapshot.data!.docs[index].id)
                                  .update({
                                'messages':
                                    FieldValue.arrayUnion([messageData]),
                              });
                            });
                          },
                          child: Icon(Icons.markunread, color: Colors.red[700]),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReplyMessageScreen(
                                  recipientId: senderId,
                                  docId: snapshot.data!.docs[index].id,
                                  originalMessageData: messageData,
                                ),
                              ),
                            );
                            FirebaseFirestore.instance
                                .collection('Messages')
                                .doc(snapshot.data!.docs[index].id)
                                .update({
                              'messages': FieldValue.arrayRemove([messageData])
                            }).then((_) {
                              messageData['isRead'] = true;
                              FirebaseFirestore.instance
                                  .collection('Messages')
                                  .doc(snapshot.data!.docs[index].id)
                                  .update({
                                'messages':
                                    FieldValue.arrayUnion([messageData]),
                              });
                            });
                          },
                          child: Icon(
                            Icons.forward_to_inbox_rounded,
                            color: Colors.green[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
