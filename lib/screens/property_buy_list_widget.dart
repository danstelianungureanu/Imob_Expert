// ignore_for_file: sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imob_expert/widgets/buy_widget.dart';

class PropertyBuyListWidget extends StatefulWidget {
  const PropertyBuyListWidget({super.key});

  @override
  State<PropertyBuyListWidget> createState() => _PropertyBuyListWidgetState();
}

class _PropertyBuyListWidgetState extends State<PropertyBuyListWidget> {
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
          'Anunțuri de cumpărare',
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
          const SizedBox(height: 10),
          BuyWidget(
            searchRegion: _searchRegion,
          ),
        ],
      ),
    );
  }
}
