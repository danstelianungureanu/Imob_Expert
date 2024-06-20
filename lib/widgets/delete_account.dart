// ignore_for_file: file_names, use_build_context_synchronously, camel_case_types

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imob_expert/screens/login_screen.dart';
import 'package:imob_expert/widgets/logOut.dart';

class deleteAccount extends StatelessWidget {
  const deleteAccount({super.key});

  Future<void> _deleteAccount(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    try {
      // Delete user from Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .delete();

      // Delete user from Firebase Auth
      await user.delete();
      // Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    } catch (e) {
      String errorMessage;

      if (e is FirebaseAuthException && e.code == 'requires-recent-login') {
        errorMessage = 'Vă rugăm să vă reconectați și să încercați din nou.';
      } else {
        errorMessage =
            'A apărut o eroare. Vă rugăm să încercați din nou mai târziu.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
      child: TextButton(
        onPressed: () => _showConfirmationDialog(context),
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.delete_forever_rounded,
              color: Colors.white,
            ),
            SizedBox(width: 8.0),
            Text(
              "Șterge contul",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmare'),
          content: const Text(
              'Sigur doriți să ștergeți contul? Această acțiune este ireversibilă.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Anulează'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Șterge'),
              onPressed: () {
                const logOut();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
                _deleteAccount(context);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
