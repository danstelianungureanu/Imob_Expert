import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:imob_expert/database/firebase_options.dart';
import 'package:imob_expert/screens/login_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51PSfNKP4bUyQSoutxuI2yc333fa7IqrB6IQVUFW9cUGeDBmNkZ2bKZ0XjMmJAuRtMhmYEB25LyPQ5KU2VXDxZdql00yZUup7PO'; // Înlocuiește cu cheia ta publică

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Imob Expert',
        debugShowCheckedModeBanner: false,
        home: LoginScreen());
  }
}
