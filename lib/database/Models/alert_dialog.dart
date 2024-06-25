import 'package:flutter/material.dart';
import 'package:imob_expert/screens/signup_screen.dart';

Future<dynamic> alertDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Eroare"),
        content:
            const Text("Trebuie să te înregistrezi pentru a vedea detalii."),
        actions: <Widget>[
          TextButton(
            child: const Text("Am înțeles"),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SignUp(),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}
