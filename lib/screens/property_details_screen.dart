// ignore_for_file: sized_box_for_whitespace, use_build_context_synchronously, avoid_print, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imob_expert/database/Models/house_model.dart';
import 'package:imob_expert/widgets/make_call.dart';

class PropertyDetailScreen extends StatefulWidget {
  final HouseModel imovel;

  const PropertyDetailScreen({
    super.key,
    required this.imovel,
  });

  @override
  _PropertyDetailScreenState createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _previousImage() {
    if (_pageController.page! > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextImage() {
    if (_pageController.page! < (widget.imovel.images.length - 1)) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String messageContent) async {
    try {
      // Obțineți ID-urile utilizatorilor asociate conversației
      String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
      String? ownerId = widget.imovel.id; // ID-ul proprietarului anunțului
      String? addTitle = widget.imovel.title; // Add Title
      String? senderEmail = FirebaseAuth.instance.currentUser?.email;
      // String? senderPhoneNumber =
      //     FirebaseAuth.instance.currentUser?.phoneNumber;
      bool isRead = false;

      // Obțineți documentul utilizatorului curent

      DocumentSnapshot<Map<String, dynamic>> currentUserDoc =
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUserId)
              .get();

      if (!currentUserDoc.exists) {
        throw 'User document not found';
      }

      String senderName =
          '${currentUserDoc.data()?['Name'] ?? ''} ${currentUserDoc.data()?['Surname'] ?? ''}';
      String senderPhoneNumber =
          '${currentUserDoc.data()?['PhoneNumber'] ?? ''}';

      // Verificăm dacă există deja o conversație între acești doi utilizatori
      DocumentReference<Map<String, dynamic>> conversationDocRef =
          FirebaseFirestore.instance.collection('Messages').doc();

      // Adăugați mesajul în colecția "Messages"
      await conversationDocRef.set({
        'users': [currentUserId, ownerId],
        'messages': [
          {
            'recipientId': ownerId,
            'senderId': currentUserId,
            'timestamp': Timestamp.now(),
            'content': messageContent,
            'addTitle': addTitle,
            'senderEmail': senderEmail,
            'senderName': senderName,
            'senderPhoneNumber': senderPhoneNumber,
            'isRead': isRead,
          },
        ],
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Mesajul a fost trimis cu succes!'),
        backgroundColor: Colors.green,
      ));
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Eroare la trimiterea mesajului: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _showSendMessageDialog() async {
    String messageContent = '';

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Trimite mesaj'),
          content: TextField(
            onChanged: (value) {
              messageContent = value;
            },
            decoration: const InputDecoration(
              hintText: 'Introdu mesajul tău...',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Trimite'),
              onPressed: () {
                if (messageContent.isNotEmpty) {
                  _sendMessage(messageContent);
                  Navigator.of(context).pop();
                }
              },
            ),
            TextButton(
              child: const Text('Anulează'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _callOwner() async {
    try {
      // Obțineți ID-ul utilizatorului asociat anunțului
      String? ownerId = widget.imovel.id;

      // Obțineți numărul de telefon al utilizatorului din colecția "Users"
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('Users')
          .doc(ownerId)
          .get();

      if (userDoc.exists) {
        String phoneNumber = userDoc.data()?['PhoneNumber'] ?? '';
        print(phoneNumber);

        makePhoneCall(phoneNumber);
      } else {
        throw 'User document not found';
      }
    } catch (e) {
      // Tratați erorile legate de inițierea apelului
      print('Error calling owner: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error calling owner: $e'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.imovel.title),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  child: widget.imovel.images.isNotEmpty
                      ? PageView.builder(
                          controller: _pageController,
                          itemCount: widget.imovel.images.length,
                          itemBuilder: (context, index) {
                            return Image.network(
                              widget.imovel.images[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            );
                          },
                        )
                      : Image.asset(
                          'assets/images/placeholder.png', // Provide a placeholder image in case there are no images
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                ),
                Positioned(
                  left: 10,
                  top: 80,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: _previousImage,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 80,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onPressed: _nextImage,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          widget.imovel.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Flexible(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${widget.imovel.price} EURO',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color.fromRGBO(26, 147, 192, 1),
                      ),
                      Text(
                        '${widget.imovel.address} - ${widget.imovel.region}',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                        maxLines: null,
                        softWrap: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.bathtub,
                              color: Color.fromRGBO(26, 147, 192, 1)),
                          const SizedBox(width: 5),
                          if (widget.imovel.bathroom == 1)
                            Text(
                              '${widget.imovel.bathroom.toString()} Baie',
                              style: const TextStyle(color: Colors.grey),
                            )
                          else
                            Text(
                              '${widget.imovel.bathroom.toString()} Băi',
                              style: const TextStyle(color: Colors.grey),
                            )
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.bed,
                              color: Color.fromRGBO(26, 147, 192, 1)),
                          const SizedBox(width: 5),
                          if (widget.imovel.rooms == 1)
                            Text(
                              '${widget.imovel.rooms.toString()} Cameră',
                              style: const TextStyle(color: Colors.grey),
                            )
                          else
                            Text('${widget.imovel.rooms.toString()} Camere',
                                style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                      Row(children: [
                        const Icon(Icons.square_foot,
                            color: Color.fromRGBO(26, 147, 192, 1)),
                        const SizedBox(width: 5),
                        Text(
                          '${widget.imovel.squareMeters.toString()} m²',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ])
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Descriere',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    widget.imovel.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                    maxLines: null,
                    softWrap: true,
                  ),
                  const SizedBox(height: 20),
                  const Text('Facilități',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: widget.imovel.facilities.map((item) {
                      return Chip(
                        label: Text(item),
                        shape: const StadiumBorder(
                            side: BorderSide(
                                color: Color.fromRGBO(26, 147, 192, 1))),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text('În apropriere',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: widget.imovel.vicinity.map((item) {
                      return Chip(
                          label: Text(item),
                          shape: const StadiumBorder(
                              side: BorderSide(
                                  color: Color.fromRGBO(26, 147, 192, 1))));
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                      height: 2,
                      thickness: 2,
                      color: Color.fromARGB(255, 167, 167, 167)),
                  const SizedBox(height: 10),
                  Text.rich(
                    TextSpan(
                      children: [
                        if (widget.imovel.price < 1000)
                          TextSpan(
                            text: '${widget.imovel.price} Euro',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else
                          TextSpan(
                            text:
                                '${widget.imovel.price / widget.imovel.squareMeters} Euro',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (widget.imovel.price < 1000)
                          const TextSpan(
                            text: '/lună',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                        else
                          const TextSpan(
                            text: ' /m2',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                      'Avansul de plată este ${widget.imovel.monthsLease.toString()} la începerea contractului.'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      children: [
                        if (widget.imovel.id != user!.uid)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _showSendMessageDialog,
                              icon: const Icon(Icons.message_rounded,
                                  color: Colors.black),
                              label: const Text('Scrie mesaj',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Colors.black)),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                side: const BorderSide(
                                    color: Colors.black, width: 2),
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        if (widget.imovel.id != user!.uid)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                _callOwner();
                              },
                              icon: const Icon(Icons.call, color: Colors.white),
                              label: const Text(' Sună',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16)),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 38, 220, 59),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
