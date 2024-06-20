// ignore_for_file: use_build_context_synchronously, unused_field, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'forget_password_screen.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var _email = '';
  var _password = '';
  bool _passwordVisivel = false;
  final bool _passwordConfirmVisivel = false;

  final _formKey = GlobalKey<FormState>();

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmare'),
          content:
              const Text('Acest cont nu exista. Vreți să creați un cont ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Anulează'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Crează'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SignUp(),
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

  void _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      _formKey.currentState!.save();
      try {
        // Execute login
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _email, password: _password);

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } on FirebaseAuthException catch (error) {
        if (error.code == 'user-not-found') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SignUp(),
            ),
          );
        } else if (error.code == 'invalid-credential') {
          _showConfirmationDialog(context);
        } else {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(error.message ?? "Autentificarea a eșuat.")));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/cover_imob_expert.jpg'),
                  fit: BoxFit.fill)),
          child: SizedBox.expand(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),
                  const Text(
                    'Bine ați venit, conectați-vă pentru ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                  ),
                  const Text(
                    'a crea anunț.',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 34,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Introduceți o adresa de e-mail validă";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(Icons.person),
                                  hintText: 'Email',
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 204, 204, 204)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 204, 204, 204)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color.fromRGBO(26, 147, 192, 1)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.red),
                                      borderRadius: BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.all(20)),
                              onSaved: (value) {
                                _email = value ?? '';
                              }),
                          const SizedBox(height: 10),
                          TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Introduceți adresa de e-mail validă";
                                }
                                return null;
                              },
                              obscureText: !_passwordVisivel,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.lock_rounded),
                                hintText: 'Parola',
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 204, 204, 204)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color:
                                          Color.fromARGB(255, 204, 204, 204)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color.fromRGBO(26, 147, 192, 1)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                errorBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.all(20),
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisivel = !_passwordVisivel;
                                      });
                                    },
                                    icon: Icon(
                                        _passwordVisivel
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: _passwordVisivel
                                            ? Colors.black
                                            : Colors.grey)),
                              ),
                              onSaved: (value) {
                                _password = value ?? '';
                              }),
                          const SizedBox(height: 15),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgetPasswordScreen(),
                                ));
                              },
                              child: const Text('V-ați uitat parola?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      decorationColor: Colors.white)),
                            ),
                          ),
                          //botao login
                          const SizedBox(height: 30),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  onPressed: _submit,
                                  style: TextButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      backgroundColor:
                                          const Color.fromRGBO(26, 147, 192, 1),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(40))),
                                  child: const Text('Log in',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16)))),
                          const SizedBox(height: 40),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                //Navegar a pagina de registo (sign up)
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignUp(),
                                  ),
                                );
                              },
                              child: const Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'Nu aveți încă un cont?',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 16)),
                                    TextSpan(
                                        text: ' Înregistreză',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              },
                              child: const Text('Înregistrează-te mai târziu',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      decoration: TextDecoration.underline,
                                      decorationThickness: 2,
                                      decorationColor: Colors.white)),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
