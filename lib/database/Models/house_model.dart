import 'package:cloud_firestore/cloud_firestore.dart';

class HouseModel {
  String? id;
  // String propertyType;
  String type;
  String title;
  String region;
  String address;
  String description;
  int rooms;
  int bathroom;
  int squareMeters;
  int floor;
  int price;
  int monthsLease;
  List<String> facilities;
  List<String> vicinity;
  List<String> images;
  Timestamp? dataCriacao;
  String phoneNumber;
  // String collection;

  HouseModel({
    this.id,
    // required this.propertyType,
    required this.type,
    required this.title,
    required this.region,
    required this.address,
    required this.description,
    required this.rooms,
    required this.bathroom,
    required this.squareMeters,
    required this.floor,
    required this.price,
    required this.monthsLease,
    required this.facilities,
    required this.vicinity,
    required this.images,
    required this.phoneNumber,
    // required this.collection,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // 'create': propertyType,
      'type': type,
      'title': title,
      'region': region,
      'address': address,
      'description': description,
      'rooms': rooms,
      'bathroom': bathroom,
      'squareMeters': squareMeters,
      'floor': floor,
      'price': price,
      'monthsLease': monthsLease,
      'facilities': facilities,
      'vicinity': vicinity,
      'images': images,
      'dataCriacao': Timestamp.now(),
      // 'phoneNumber': phoneNumber,
      // 'collection': collection,
    };
  }

  factory HouseModel.fromJson(Map<String, dynamic> map) {
    return HouseModel(
      id: map['id'],
      // propertyType: map['propertyType'],
      type: map['type'],
      title: map['title'],
      region: map['region'],
      address: map['address'],
      description: map['description'],
      rooms: map['rooms'],
      bathroom: map['bathroom'],
      squareMeters: map['squareMeters'],
      floor: map['floor'],
      price: map['price'],
      monthsLease: map['monthsLease'],
      facilities: List<String>.from(map['facilities']),
      vicinity: List<String>.from(map['vicinity']),
      images: List<String>.from(map['images']),
      phoneNumber: '',
      //  collection: '',
    );
  }
}
