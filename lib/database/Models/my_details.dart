// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, camel_case_types

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:imob_expert/widgets/my_details_build_container.dart';

class MyDetailsPage extends StatefulWidget {
  const MyDetailsPage({super.key});

  @override
  _MyDetailsPageState createState() => _MyDetailsPageState();
}

class _MyDetailsPageState extends State<MyDetailsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  Map<String, dynamic>? userData;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

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
        if (userData != null) {
          _nameController.text = userData!['Name'] ?? '';
          _surnameController.text = userData!['Surname'] ?? '';
          _phoneNumberController.text = userData!['PhoneNumber'] ?? '';
        }
      });
    }
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _firestore.collection('Users').doc(user!.uid).update({
          'Name': _nameController.text,
          'Surname': _surnameController.text,
          'PhoneNumber': _phoneNumberController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Informațiile au fost actualizate cu succes')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Eroare la actualizarea informațiilor: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detaliile Mele',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    myDetailsBuildContainer(
                        child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nume'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Câmp obligatoriu.';
                        }
                        return null;
                      },
                    )),
                    myDetailsBuildContainer(
                        child: TextFormField(
                      controller: _surnameController,
                      decoration: const InputDecoration(labelText: 'Prenume'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Câmp obligatoriu.';
                        }
                        return null;
                      },
                    )),
                    myDetailsBuildContainer(
                        child: TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(labelText: 'Telefon'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Câmp obligatoriu.';
                        }
                        return null;
                      },
                    )),
                    myDetailsBuildContainer(
                        child: Text(
                      'Email: ${userData!['Email'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 18),
                    )),
                    myDetailsBuildContainer(
                        child: Text(
                      'Data nașterii: ${userData!['DateOfBirt'] ?? 'N/A'}',
                      style: const TextStyle(fontSize: 18),
                    )),
                    myDetailsBuildContainer(
                        child: Text(
                      'Depozitul actual: ${userData!['Credit']?.isEmpty == true ? '0' : userData!['Credit']}/MDL',
                      style: const TextStyle(fontSize: 18),
                    )),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveUserData,
                      child: const Text('Salvează'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
