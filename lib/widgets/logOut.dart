// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imob_expert/screens/login_screen.dart';

// ignore: camel_case_types
class logOut extends StatelessWidget {
  const logOut({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, bottom: 25.0),
      child: TextButton(
        onPressed: () {
          FirebaseAuth.instance.signOut();

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(
              EdgeInsets.zero), // pentru a elimina orice padding implicit
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.logout,
              color: Colors.white,
            ),
            SizedBox(width: 8.0), // distanță mică între iconiță și text
            Text(
              "Ieși",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
