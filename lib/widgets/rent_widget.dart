import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imob_expert/database/Models/house_model.dart';
import 'package:imob_expert/screens/property_details_screen.dart';
import 'package:imob_expert/widgets/alert_dialog.dart';
import 'property_card_widget.dart';

class RentWidget extends StatelessWidget {
  final String searchRegion;
  final User? user = FirebaseAuth.instance.currentUser;
  RentWidget({super.key, required this.searchRegion});

  Future<List<HouseModel>> _fetchAllProperties() async {
    // QuerySnapshot vanzariSnapshot;
    QuerySnapshot inchirieriSnapshot;
    // QuerySnapshot cumparariSnapshot;

    if (searchRegion.isEmpty) {
      // vanzariSnapshot =
      //     await FirebaseFirestore.instance.collection('Vanzari').get();
      inchirieriSnapshot =
          await FirebaseFirestore.instance.collection('Inchirieri').get();
      // cumparariSnapshot =
      //     await FirebaseFirestore.instance.collection('Cumparari').get();
    } else {
      // vanzariSnapshot = await FirebaseFirestore.instance
      //     .collection('Vanzari')
      //     .where('region', isEqualTo: searchRegion)
      //     .get();
      inchirieriSnapshot = await FirebaseFirestore.instance
          .collection('Inchirieri')
          .where('region', isEqualTo: searchRegion)
          .get();
      // cumparariSnapshot = await FirebaseFirestore.instance
      //     .collection('Cumparari')
      //     .where('region', isEqualTo: searchRegion)
      //     .get();
    }

    // final vanzariImoveis = vanzariSnapshot.docs.map((doc) {
    //   final data = doc.data() as Map<String, dynamic>;
    //   log('Vanzari document data: $data');
    //   return Imovel.fromJson(data);
    // }).toList();

    final inchirieriImoveis = inchirieriSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      log('Inchirieri document data: $data');
      return HouseModel.fromJson(data);
    }).toList();

    // final cumparariImoveis = cumparariSnapshot.docs.map((doc) {
    //   final data = doc.data() as Map<String, dynamic>;
    //   log('Cumparari document data: $data');
    //   return Imovel.fromJson(data);
    // }).toList();

    return [
      // ...vanzariImoveis,
      ...inchirieriImoveis,
      // ...cumparariImoveis,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HouseModel>>(
      future: _fetchAllProperties(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final imoveis = snapshot.data!;

        if (imoveis.isEmpty) {
          return const Center(child: Text('Nu sunt anunțuri '));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: imoveis.length,
          itemBuilder: (context, index) {
            final imovel = imoveis[index];
            return PropertyCard(
              imagesUrl: imovel.images.isNotEmpty ? imovel.images[0] : '',
              title: imovel.title,
              region: imovel.region,
              address: imovel.address,
              price: imovel.price,
              rooms: imovel.rooms,
              bathroom: imovel.bathroom,
              squareMeters: imovel.squareMeters,
              onTap: () {
                if (user == null) {
                  alertDialog(context);
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailScreen(
                        imovel: imovel,
                        // phoneNumber: '',
                      ),
                    ),
                  );
                }
              },
              onDelete: null,
              // onDelete: () async {},
            );
          },
        );
      },
    );
  }
}
