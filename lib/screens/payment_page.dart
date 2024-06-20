// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imob_expert/screens/home_screen.dart';
import 'package:imob_expert/screens/login_screen.dart';
// import 'package:imob_expert/screens/my_details.dart';
import 'package:imob_expert/widgets/my_buttons.dart';

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
  String amount = ''; // Adăugăm un câmp pentru suma de plată
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? user;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // _showConfirmationDialog(context);
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
            'Acest cont v-a fi suplinit cu $amount MDL.\nDacă confirmi, te rugam să te loghezi din nou.',
            style: TextStyle(
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
                updateCredit();
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
                // const SignUp();
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
      print("Amount to add is zero or invalid, skipping update.");
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
      print("Current Credit: $currentCredit");
      print("Amount: $amount");
      print("New Credit: $newCredit");

      transaction.update(userRef, {'Credit': newCredit.toString()});
    }).then((value) {
      print("Credit updated successfully!");

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
        title: const Text('Plată'),
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
                },
                formKey: formKey,
              ),
              const SizedBox(height: 20),
              // Adăugăm câmpul pentru suma de plată cu prefixul MDL
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
                    print("Amount onChanged: $amount");
                  });
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
                        print(
                            "Amount before update: $amount"); // Debugging print statement
                        _showConfirmationDialog(context);
                        // updateCredit();
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const HomeScreen(),
                        //   ),
                        //   (route) => false, // remove all other routes
                        //   // );
                        // );
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
                      // }
                    },
                    text: 'Anulează',
                  ),
                ],
              ),
              // const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
