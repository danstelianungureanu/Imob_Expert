// ignore_for_file: avoid_print, duplicate_ignore, sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/rent_widget.dart';

class PropertyRentListWidget extends StatefulWidget {
  const PropertyRentListWidget({super.key});

  @override
  State<PropertyRentListWidget> createState() => _PropertyRentListWidgetState();
}

class _PropertyRentListWidgetState extends State<PropertyRentListWidget> {
  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  String _searchRegion = '';

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
          'Anunțuri de închirieri',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          //Pesquisar
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

          const SizedBox(height: 10),

          RentWidget(
            searchRegion: _searchRegion,
          ),
        ],
      ),
    );
  }
}
