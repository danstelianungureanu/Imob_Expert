// ignore_for_file: avoid_print, duplicate_ignore, unused_element, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imob_expert/screens/register_buy_property_screen.dart';
import 'package:imob_expert/screens/register_rent_property_screen.dart';
import 'package:imob_expert/screens/register_sell_property_screen.dart';
import 'package:imob_expert/screens/login_screen.dart';
import 'package:imob_expert/widgets/sales_widget.dart';

class PropertySalesListWidget extends StatefulWidget {
  const PropertySalesListWidget({super.key});

  @override
  State<PropertySalesListWidget> createState() =>
      _PropertySalesListWidgetState();
}

class _PropertySalesListWidgetState extends State<PropertySalesListWidget> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  String _searchRegion = '';

  Future<Map<String, String>> _getUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc =
            await FirebaseFirestore.instance
                .collection('Users') // verifică numele colecției
                .doc(user!.uid) // verifică UID-ul utilizatorului curent
                .get();

        if (userDoc.exists) {
          String name = userDoc.data()?['Name'] ?? 'Nume';
          String surname = userDoc.data()?['Surname'] ?? 'Prenume';
          String phoneNumber = userDoc.data()?['PhoneNumber'] ?? 'PhoneNumber';

          // Adăugăm print pentru a vedea valorile returnate
          // ignore: avoid_print
          print('Name: $name');
          print('Surname: $surname');
          print('Phone Number: $phoneNumber');

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

  void _navigateToRegisterProperty(BuildContext context, String result) {
    if (user != null) {
      if (result == 'Vânzare') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterSellPropertyScreen(
              propertyType: result,
              phoneNumber: '',
            ),
          ),
        );
      } else if (result == 'Închirieri') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterRentPropertyScreen(
              propertyType: result,
              //  phoneNumber: userData['phoneNumber'],
            ),
          ),
        );
      } else if (result == 'Cumpăr') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterBuyPropertyScreen(
              propertyType: result,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login to add imobil.'),
        ),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
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
          'Anunțuri de vânzare',
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
                    // const Icon(Icons.search, color: Colors.black),
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
          //Categoria
          // const Padding(
          //   padding: EdgeInsets.only(top: 10, left: 20),
          //   child: Text(
          //     'Categorii',
          //     textAlign: TextAlign.center,
          //     style: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 20,
          //     ),
          //   ),
          // ),
          const SizedBox(height: 10),
          // const CategoryWidget(),
          // const ImovelItemWidget(),
          //const ImovelItemWidget(),

          SalesWidget(
            searchRegion: _searchRegion,
            // collectionName: '',
          ),
        ],
      ),
    );
  }
}
