// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imob_expert/database/Models/house_model.dart';
import 'package:imob_expert/screens/property_details_screen.dart';
import 'property_card_widget.dart';

class MyAddsListWidget extends StatelessWidget {
  final String searchRegion;
  final String userId;

  const MyAddsListWidget({
    super.key,
    required this.searchRegion,
    required this.userId,
  });

  Future<List<HouseModel>> _fetchUserProperties() async {
    QuerySnapshot vanzariSnapshot;
    QuerySnapshot inchirieriSnapshot;
    QuerySnapshot cumparariSnapshot;

    if (searchRegion.isEmpty) {
      vanzariSnapshot = await FirebaseFirestore.instance
          .collection('Vanzari')
          .where('id', isEqualTo: userId)
          .get();
      inchirieriSnapshot = await FirebaseFirestore.instance
          .collection('Inchirieri')
          .where('id', isEqualTo: userId)
          .get();
      cumparariSnapshot = await FirebaseFirestore.instance
          .collection('Cumparari')
          .where('id', isEqualTo: userId)
          .get();
    } else {
      vanzariSnapshot = await FirebaseFirestore.instance
          .collection('Vanzari')
          .where('region', isEqualTo: searchRegion)
          .get();
      inchirieriSnapshot = await FirebaseFirestore.instance
          .collection('Inchirieri')
          .where('region', isEqualTo: searchRegion)
          .get();
      cumparariSnapshot = await FirebaseFirestore.instance
          .collection('Cumparari')
          .where('region', isEqualTo: searchRegion)
          .get();
    }

    final vanzariImoveis = vanzariSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return HouseModel.fromJson(data);
    }).toList();

    final inchirieriImoveis = inchirieriSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return HouseModel.fromJson(data);
    }).toList();

    final cumparariImoveis = cumparariSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return HouseModel.fromJson(data);
    }).toList();

    return [
      ...vanzariImoveis,
      ...inchirieriImoveis,
      ...cumparariImoveis,
    ];
  }

  Future<void> _deleteSellProperty(String docId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Vanzari')
          .where('id', isEqualTo: userId) // Verificăm id-ul userului
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('Vanzari')
            .doc(documentId)
            .delete();
      } else {
        throw 'Document not found or user does not have permission to delete';
      }
    } catch (e) {
      print('Error deleting property: $e');
    }
  }

  Future<void> _deleteBuyProperty(String docId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Cumparari')
          .where('id', isEqualTo: userId) // Verificăm id-ul userului
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('Cumparari')
            .doc(documentId)
            .delete();
      } else {
        throw 'Document not found or user does not have permission to delete';
      }
    } catch (e) {
      print('Error deleting property: $e');
    }
  }

  Future<void> _deleteRentProperty(String docId) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Inchirieri')
          .where('id', isEqualTo: userId) // Verificăm id-ul userului
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final String documentId = querySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('Inchirieri')
            .doc(documentId)
            .delete();
      } else {
        throw 'Document not found or user does not have permission to delete';
      }
    } catch (e) {
      print('Error deleting property: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HouseModel>>(
      future: _fetchUserProperties(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final imoveis = snapshot.data!;

        if (imoveis.isEmpty) {
          return const Center(child: Text('Nu sunt anunțuri'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: imoveis.length,
          itemBuilder: (context, index) {
            final imovel = imoveis[index];

            return Dismissible(
              key: Key(imovel.id!),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) async {
                try {
                  await _deleteSellProperty(imovel.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anunț șters')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Anunțul nu a fost sters șters'),
                    ),
                  );
                }
                try {
                  await _deleteBuyProperty(imovel.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anunț șters')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Anunțul nu a fost sters șters'),
                    ),
                  );
                }
                try {
                  await _deleteRentProperty(imovel.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anunț șters')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Anunțul nu a fost sters șters'),
                    ),
                  );
                }
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: PropertyCard(
                key: ValueKey(imovel.id!),
                imagesUrl: imovel.images.isNotEmpty ? imovel.images[0] : '',
                title: imovel.title,
                region: imovel.region,
                address: imovel.address,
                price: imovel.price,
                rooms: imovel.rooms,
                bathroom: imovel.bathroom,
                squareMeters: imovel.squareMeters,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PropertyDetailScreen(
                        imovel: imovel,
                      ),
                    ),
                  );
                },
                onDelete: () async {
                  await _deleteSellProperty(imovel.id!);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Anunț șters')),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
