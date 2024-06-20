import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:imob_expert/firebase_options.dart';
import 'package:imob_expert/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
