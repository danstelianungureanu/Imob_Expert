// import 'dart:io';

// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unnecessary_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imob_expert/database/Models/house_model.dart';
import 'package:imob_expert/screens/home_screen.dart';
import 'package:imob_expert/widgets/custom_input_decoration.dart';
import 'package:imob_expert/widgets/custom_input_icon_decoration.dart';
import 'package:imob_expert/widgets/dropdown_button_widget.dart';
import 'package:imob_expert/widgets/multi_select_dialog_field_widget.dart';

class RegisterBuyPropertyScreen extends StatefulWidget {
  final String propertyType;

  const RegisterBuyPropertyScreen({super.key, required this.propertyType});

  @override
  _RegisterBuyPropertyScreenState createState() =>
      _RegisterBuyPropertyScreenState();
}

class _RegisterBuyPropertyScreenState extends State<RegisterBuyPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  // List<XFile>? _imageFileList = [];

  final HouseModel _imobil = HouseModel(
    type: '',
    title: '',
    address: '',
    region: '',
    description: '',
    rooms: 0,
    bathroom: 0,
    squareMeters: 0,
    floor: 0,
    price: 0,
    monthsLease: 0,
    facilities: [],
    vicinity: [],
    images: [],
    phoneNumber: '',
  );

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _monthsLeaseController = TextEditingController();
  final TextEditingController _bathroomController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _squareMetersController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<String> _imobilType = [
    'Apartament',
    'Apartament in Casă',
    'Casă pe pamânt',
    'Fermă'
  ];
  final List<String> _provincias = [
    'Anenii Noi',
    'Basarabeasca',
    'Bălți',
    'Briceni',
    'Cahul',
    'Cantemir',
    'Călărași',
    'Căușeni',
    'Chișinău',
    'Cimișlia',
    'Comrat',
    'Criuleni',
    'Dondușeni',
    'Drochia',
    'Dubăsari',
    'Edineț',
    'Fălești',
    'Florești',
    'Glodeni',
    'Hîncești',
    'Ialoveni',
    'Leova',
    'Nisporeni',
    'Ocnița',
    'Orhei',
    'Rezina',
    'Rîșcani',
    'Sîngerei',
    'Soroca',
    'Strășeni',
    'Șoldănești',
    'Ștefan Vodă',
    'Taraclia',
    'Telenești',
    'Tichina',
    'Tiraspol',
    'Ungheni',
  ];
  final List<String> _facilities = [
    'Wi-Fi',
    'Piscină',
    'Parcare',
    'Camere de supraveghere',
    'Lift',
    'Pază',
    'Incălzire centralizată'
  ];
  final List<String> _vicinity = [
    'Biserica',
    'Școli de stat',
    'Școli private',
    'Secție de poliție',
    'Gym',
    'Gradina proprie',
    'Spital în zonă',
    'Restuarante și Baruri',
    'Mijloc de transport',
    'Supermarket',
    'Piață',
  ];

  @override
  void initState() {
    super.initState();
    _imobil.type = widget.propertyType; // Setează tipul de proprietate selectat
  }

  String replaceSpecialRomanianCharacters(String input) {
    final Map<String, String> replacements = {
      'ș': 's',
      'Ş': 'S',
      'ț': 't',
      'Ț': 'T',
      'ă': 'a',
      'Ă': 'A',
      'î': 'i',
      'Î': 'I',
      'â': 'a',
      'Â': 'A'
    };

    return input.split('').map((char) => replacements[char] ?? char).join('');
  }

  Future<void> _registerProperty() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;

      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        _imobil.id = user!.uid;
        _imobil.title = _titleController.text;
        _imobil.address = _addressController.text;
        _imobil.price = int.tryParse(_priceController.text) ?? 0;
        _imobil.monthsLease = int.tryParse(_monthsLeaseController.text) ?? 0;
        _imobil.bathroom = int.tryParse(_bathroomController.text) ?? 0;
        _imobil.rooms = int.tryParse(_roomsController.text) ?? 0;
        _imobil.squareMeters = int.tryParse(_squareMetersController.text) ?? 0;
        _imobil.floor = int.tryParse(_floorController.text) ?? 0;
        _imobil.description = _descriptionController.text;
        _imobil.region = replaceSpecialRomanianCharacters(_imobil.region);

        // List<String> imageUrls = await _uploadImagesToStorage();
        // _imobil.images = imageUrls;

        await FirebaseFirestore.instance
            .collection('Cumparari')
            .add(_imobil.toJson());

        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registered with success!'),
          backgroundColor: Colors.green,
        ));

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
        backgroundColor: Colors.red,
      ));
    }
  }

  // Future<List<String>> _uploadImagesToStorage() async {
  // List<String> imageUrls = [];

  //   for (XFile imageFile in _imageFileList!) {
  //     String imageUrl = await _uploadImageToStorage(imageFile);
  //     imageUrls.add(imageUrl);
  //   }
  //   return imageUrls;
  // }

  // Future<String> _uploadImageToStorage(XFile imageFile) async {
  //   File file = File(imageFile.path);
  //   String generateImageName = const Uuid().v4();
  //   final storageRef = FirebaseStorage.instance
  //       .ref()
  //       .child('user_imobil_images')
  //       .child('$generateImageName.jpg');
  //   await storageRef.putFile(file);

  //   final imageUrl = await storageRef.getDownloadURL();
  //   return imageUrl;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaugă anunț de cumpărare'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonCombBox(
                typeValue: 'Tipul proprietății',
                values: _imobilType,
                selectedValue: _imobil.type,
                onChanged: (value) => setState(() {
                  _imobil.type = value!;
                }),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                validator: (value) =>
                    value!.isEmpty ? 'Câmp obligatoriu.' : null,
                decoration: customInputDecoration(hintText: 'Denumire'),
              ),
              const SizedBox(height: 10),
              DropdownButtonCombBox(
                typeValue: 'Regiunea',
                values: _provincias,
                selectedValue: _imobil.region,
                onChanged: (value) => setState(() {
                  _imobil.region = value!;
                }),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _addressController,
                validator: (value) =>
                    value!.isEmpty ? 'Câmp obligatoriu.' : null,
                decoration:
                    customInputDecoration(hintText: 'Locație si adresă'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _priceController,
                validator: (value) =>
                    value!.isEmpty ? 'Câmp obligatoriu.' : null,
                keyboardType: TextInputType.number,
                decoration: customInputDecoration(hintText: "Preț"),
              ),
              const SizedBox(height: 10),
              // TextFormField(
              //   controller: _monthsLeaseController,
              //   validator: (value) =>
              //       value!.isEmpty ? 'Câmp obligatoriu.' : null,
              //   keyboardType: TextInputType.number,
              //   decoration:
              //       customInputDecoration(hintText: 'Numărul de luni de avans'),
              // ),
              // const SizedBox(height: 20),
              const Text(
                'Informații de bază',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // ImageUploadWidget(
              //   imageFileList: _imageFileList,
              //   onImagesSelected: (images) {
              //     setState(() {
              //       _imageFileList = images;
              //     });
              //   },
              // ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _bathroomController,
                validator: (value) =>
                    value!.isEmpty ? 'Câmp obligatoriu.' : null,
                keyboardType: TextInputType.number,
                decoration: customInputIconDecoration(
                    hintText: 'Băi', prefixIcon: Icons.bathtub),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _roomsController,
                validator: (value) =>
                    value!.isEmpty ? 'Câmp obligatoriu.' : null,
                keyboardType: TextInputType.number,
                decoration: customInputIconDecoration(
                    hintText: 'Dormitoare', prefixIcon: Icons.bed_outlined),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _squareMetersController,
                validator: (value) =>
                    value!.isEmpty ? 'Câmp obligatoriu.' : null,
                keyboardType: TextInputType.number,
                decoration: customInputIconDecoration(
                    hintText: 'Metri pătrați',
                    prefixIcon: Icons.square_foot_outlined),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _floorController,
                validator: (value) =>
                    value!.isEmpty ? 'Câmp obligatoriu.' : null,
                keyboardType: TextInputType.number,
                decoration: customInputIconDecoration(
                    hintText: 'Etaj', prefixIcon: Icons.stairs_outlined),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descriptionController,
                validator: (value) =>
                    value!.isEmpty ? 'Câmp obligatoriu.' : null,
                keyboardType: TextInputType.text,
                decoration: customInputDecoration(hintText: 'Descriere'),
              ),
              const SizedBox(height: 10),
              const Text(
                'Facilitați și dotări',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              MultiSelectDialogFieldWidget(
                items: _facilities,
                title: 'Facilitați și dotări',
                onConfirm: (values) {
                  setState(() {
                    _imobil.facilities = values;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'În apropiere',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              MultiSelectDialogFieldWidget(
                items: _vicinity,
                title: 'În apropiere',
                onConfirm: (values) {
                  setState(() {
                    _imobil.vicinity = values;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _registerProperty,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  backgroundColor: const Color.fromRGBO(26, 147, 192, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: const Text(
                  'Înregistrează anunțul',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
