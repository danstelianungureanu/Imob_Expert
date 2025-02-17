// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:imob_expert/screens/home_screen.dart';
import 'package:imob_expert/database/Models/my_buttons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  String amount = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  Map<String, dynamic>? userData;

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
      });
    }
  }

  double _convertToDouble(String value) {
    try {
      String sanitizedValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.parse(sanitizedValue);
    } catch (e) {
      print("Conversion error: $e");
      return 0.0;
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmare'),
          content: Text(
            'Acest cont va fi suplinit cu $amount MDL.',
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Anulează'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmă'),
              onPressed: () {
                makeStripePayment(amount); // Apelează metoda Stripe
                updateCredit();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void updateCredit() async {
    double amountToAdd = _convertToDouble(amount);
    if (amountToAdd == 0.0) {
      return;
    }

    DocumentReference userRef =
        FirebaseFirestore.instance.collection('Users').doc(user!.uid);

    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(userRef);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      double currentCredit = _convertToDouble(snapshot['Credit']);
      double newCredit = currentCredit + amountToAdd;

      transaction.update(userRef, {'Credit': newCredit.toString()});
    }).then((value) {
      setState(() {
        userData!['Credit'] =
            (double.parse(userData!['Credit']) + amountToAdd).toString();
      });
    }).catchError((error) {
      print("Failed to update credit: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Alimentează contul'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreditCardWidget(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                onCreditCardWidgetChange: (p0) {},
              ),
              CreditCardForm(
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                onCreditCardModelChange: (data) {
                  setState(() {
                    cardNumber = data.cardNumber;
                    expiryDate = data.expiryDate;
                    cardHolderName = data.cardHolderName;
                    cvvCode = data.cvvCode;
                  });

                  // Afișare date card în consolă
                  print('Card Number: $cardNumber');
                  print('Expiry Date: $expiryDate');
                  print('Card Holder Name: $cardHolderName');
                  print('CVV Code: $cvvCode');
                },
                formKey: formKey,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Suma de plată',
                  border: OutlineInputBorder(),
                  prefixText: 'MDL ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduceți suma de plată';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    amount = value;
                  });
                  print('Suma introdusă: $amount MDL');
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MyButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        // Afișare date completate
                        print('=== Date introduse de utilizator ===');
                        print('Card Number: $cardNumber');
                        print('Expiry Date: $expiryDate');
                        print('Card Holder Name: $cardHolderName');
                        print('CVV Code: $cvvCode');
                        print('Suma de plată: $amount MDL');

                        _showConfirmationDialog(context);
                      }
                    },
                    text: 'Plătește',
                  ),
                  MyButton(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ),
                      );
                    },
                    text: 'Anulează',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> makeStripePayment(String amount) async {
  try {
    // 1. Creează un PaymentIntent pe server (aici simulăm cu un request simplu)
    final response = await http.post(
      Uri.parse(
          'https://your-server.com/create-payment-intent'), // Serverul tău
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'amount': int.parse(amount) * 100, 'currency': 'mdl'}),
    );

    final paymentIntentData = jsonDecode(response.body);

    // 2. Inițiază plata cu Stripe
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentData[
            'sk_test_51PSfNKP4bUyQSoutcUSXX8FRfUAUys3M4URkCCNuWXgCM2V17m05KX6cQBc4ZRklzYB9Y5SbmUBTEVsOgmwaMS5t00msUVVAyE'],
        merchantDisplayName: 'ImobExpert',
        style: ThemeMode.light,
      ),
    );

    // 3. Afișează sheet-ul pentru finalizarea plății
    await Stripe.instance.presentPaymentSheet();

    print('Plata a fost efectuată cu succes!');
  } catch (e) {
    print('Eroare la plată: $e');
  }
}
