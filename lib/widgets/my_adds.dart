// ignore_for_file: avoid_print, duplicate_ignore, sized_box_for_whitespace, unused_element

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imob_expert/widgets/my_adds_list_widget.dart';

class MyAdds extends StatefulWidget {
  const MyAdds({super.key});

  @override
  State<MyAdds> createState() => _MyAddsState();
}

class _MyAddsState extends State<MyAdds> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  String _searchRegion = '';

  Future<Map<String, String>> _getUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('Users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          String name = userDoc.data()?['Name'] ?? 'Nume';
          String surname = userDoc.data()?['Surname'] ?? 'Prenume';
          String phoneNumber = userDoc.data()?['PhoneNumber'] ?? 'PhoneNumber';
          String id = user!.uid;

          print('Name: $name');
          print('Surname: $surname');
          print('Phone Number: $phoneNumber');
          print(id);
          print(user);

          return {'name': name, 'surname': surname};
        } else {
          print('Document does not exist.');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
    return {'name': 'Vizitator', 'surname': ''};
  }

  void _searchProperties() {
    setState(() {
      _searchRegion = _searchController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Anunțurile mele',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: _searchProperties,
                    ),
                    Container(
                      height: 50,
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: TextFormField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            hintText: 'Căutați o locație',
                            border: InputBorder.none,
                          ),
                          onFieldSubmitted: (value) {
                            _searchProperties();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          MyAddsListWidget(searchRegion: _searchRegion, userId: user!.uid),
        ],
      ),
    );
  }
}
