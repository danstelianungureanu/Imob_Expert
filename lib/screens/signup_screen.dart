// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_typing_uninitialized_variables, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:imob_expert/database/Models/create_user.dart';
import 'package:imob_expert/screens/home_screen.dart';
import 'package:imob_expert/screens/login_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

final _firebase = FirebaseAuth.instance;
final _firebaseFirestore = FirebaseFirestore.instance;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var _name = '';
  var _surname = '';
  var _dateOfBirt = '';
  var _phoneNumber = '';
  var _email = '';
  var _password = '';
  var _confirmPassword = '';
  final _credit = '';

  final _formKey = GlobalKey<FormState>();
  bool _passwordVisivel = false;
  bool _passwordConfirmVisivel = false;
  bool agree = false;

  // Funcția pentru a lansa URL-ul
  void _launchURL() async {
    final url = Uri.parse(
        'https://math-web-rust.vercel.app/README.md'); // Înlocuiește cu link-ul dorit
    if (await canLaunchUrl(url)) {
      await canLaunchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _submit() async {
    if (agree) {
      // Formularul este valid, execută acțiunile necesare
      final isValid = _formKey.currentState!.validate();

      if (isValid) {
        _formKey.currentState!.save();
        try {
          //Guardar o email e o password no Firebase auth
          final userCredentials =
              await _firebase.createUserWithEmailAndPassword(
                  email: _email, password: _password);

          final user = newUser(
            id: userCredentials.user!.uid,
            name: _name,
            surname: _surname,
            dateOfBirt: _dateOfBirt,
            phoneNumber: _phoneNumber,
            email: _email,
            credit: _credit,
          );

          //Salvați datele rămase Firebase firestore
          // _firebaseFirestore.collection('Users').add(user.toJson());
          _firebaseFirestore
              .collection('Users')
              .doc(userCredentials.user!.uid)
              .set(user.toJson());

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } on FirebaseAuthException catch (error) {
          if (error.code == 'email-already-in-use') {}
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.red,
              content: Text(error.message ?? "Authentication failed.")));
        }
      }
      print('Formular trimis');
    } else {
      // Afișează mesajul de alertă
      // _showAlertDialog();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Eroare"),
            content: const Text(
                "Trebuie să fii de acord cu Termenii și Condițiile și Politica de confidențialitate."),
            actions: <Widget>[
              TextButton(
                child: const Text("Am înțeles"),
                onPressed: () {
                  Navigator.of(context).pop();
                  agree = false;
                },
              ),
            ],
          );
        },
      );
    }

    // final isValid = _formKey.currentState!.validate();

    // if (isValid) {
    //   _formKey.currentState!.save();
    //   try {
    //     //Guardar o email e o password no Firebase auth
    //     final userCredentials = await _firebase.createUserWithEmailAndPassword(
    //         email: _email, password: _password);

    //     final user = newUser(
    //       id: userCredentials.user!.uid,
    //       name: _name,
    //       surname: _surname,
    //       dateOfBirt: _dateOfBirt,
    //       phoneNumber: _phoneNumber,
    //       email: _email,
    //     );

    //     //Salvați datele rămase Firebase firestore
    //     // _firebaseFirestore.collection('Users').add(user.toJson());
    //     _firebaseFirestore
    //         .collection('Users')
    //         .doc(userCredentials.user!.uid)
    //         .set(user.toJson());

    //     Navigator.of(context).push(
    //       MaterialPageRoute(
    //         builder: (context) => const HomeScreen(),
    //       ),
    //     );
    //   } on FirebaseAuthException catch (error) {
    //     if (error.code == 'email-already-in-use') {}
    //     ScaffoldMessenger.of(context).clearSnackBars();
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         backgroundColor: Colors.red,
    //         content: Text(error.message ?? "Authentication failed.")));
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    _passwordVisivel = false;
    _passwordConfirmVisivel = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Crează cont",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 36),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Completați câmpurile de mai jos pentru a crea anunțuri în aplicație.",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    //
                    //campo do nome
                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Introducem numele";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Nume',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 204, 204, 204)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 204, 204, 204)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(26, 147, 192, 1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        onSaved: (value) {
                          _name = value!;
                        }),
                    const SizedBox(height: 10),
                    //
                    //campo do apelido
                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Introducem numele de familie";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Nume de familie',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(26, 147, 192, 1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.all(20)),
                        onSaved: (value) {
                          _surname = value!;
                        }),
                    const SizedBox(height: 10),
                    //
                    //campo da data de nascimento
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Te rugăm introdu data corectă !";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Ziua Luna Anul Nașterii',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 204, 204, 204)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 204, 204, 204)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(26, 147, 192, 1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.all(20),
                          suffixIcon: const Icon(Icons.calendar_today,
                              color: Colors.grey)),
                      controller: TextEditingController(text: _dateOfBirt),
                      onTap: () async {
                        // Prevents the keyboard from showing up
                        FocusScope.of(context).requestFocus(FocusNode());
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1960),
                          lastDate: DateTime.now(),
                        );
                        var _selectedDate;
                        // if (pickedDate != null && pickedDate != _selectedDate) {
                        //   setState(() {
                        //     _selectedDate = pickedDate;
                        //     _dateOfBirt =
                        //         DateFormat('dd/MM/yyyy').format(_selectedDate);
                        //   });
                        // }
                        if (pickedDate != null && pickedDate != _selectedDate) {
                          final DateTime today = DateTime.now();
                          final DateTime eighteenYearsAgo =
                              DateTime(today.year - 18, today.month, today.day);

                          if (pickedDate.isBefore(eighteenYearsAgo)) {
                            setState(() {
                              _selectedDate = pickedDate;
                              _dateOfBirt = DateFormat('dd/MM/yyyy')
                                  .format(_selectedDate);
                            });
                          } else {
                            // Afișează un mesaj de eroare cu un AlertDialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Eroare"),
                                  content: const Text(
                                      "Trebuie să ai cel puțin 18 ani."),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("Am înțeles"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    //
                    //campo do Contacto
                    TextFormField(
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return "Insert valid contact";
                      //   }
                      //   return null;
                      // },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Numărul de Telefon',
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 204, 204, 204),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(255, 204, 204, 204),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(26, 147, 192, 1),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: const Icon(
                          Icons.phone_android_sharp,
                          color: Colors.grey,
                        ),
                        //   contentPadding: const EdgeInsets.all(20),
                        // ),
                        contentPadding: const EdgeInsets.all(20),
                        // prefixText: '+373 ',
                        // prefixStyle: const TextStyle(color: Colors.black),
                      ),
                      onSaved: (value) {
                        _phoneNumber = value!;
                      },
                      validator: (value) {
                        if (value == null || value.length != 9) {
                          return 'Numărul de telefon trebuie să conțină 9 cifre .';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    //
                    //campo do email
                    TextFormField(
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty ||
                              !value.contains('@')) {
                            return "Enter valid email address";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(26, 147, 192, 1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: const Icon(Icons.email_outlined,
                                color: Colors.grey),
                            contentPadding: const EdgeInsets.all(20)),
                        onSaved: (value) {
                          _email = value!;
                        }),

                    const SizedBox(height: 10),
                    //
                    //campo do password
                    TextFormField(
                        validator: (value) {
                          if (value == null || value.trim().length < 8) {
                            return "Enter Valid Password";
                          }
                          return null;
                        },
                        obscureText: !_passwordVisivel,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Creare Parolă',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(26, 147, 192, 1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
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
                                        : Colors.grey))),
                        onSaved: (value) {
                          _password = value!;
                        }),
                    const SizedBox(height: 10),
                    //
                    //campo para confirmar a palavra passe
                    TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Confirmă parola introdusă mai sus";
                          } else if (_password != _confirmPassword) {
                            return "Password is not matching.";
                          }
                          return null;
                        },
                        obscureText: !_passwordConfirmVisivel,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Confirmă parola introdusă mai sus',
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(26, 147, 192, 1)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.circular(10)),
                            contentPadding: const EdgeInsets.all(20),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordConfirmVisivel =
                                        !_passwordConfirmVisivel;
                                  });
                                },
                                icon: Icon(
                                    _passwordConfirmVisivel
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: _passwordConfirmVisivel
                                        ? Colors.black
                                        : Colors.grey))),
                        onSaved: (value) {
                          _confirmPassword = value!;
                        }),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      activeColor: const Color.fromRGBO(26, 147, 192, 1),
                      controlAffinity: ListTileControlAffinity.leading,
                      value:
                          agree, // Variabila booleană pentru a controla starea checkbox-ului
                      onChanged: (bool? newValue) {
                        setState(() {
                          agree = newValue!;
                          print('Checkbox apasat : $agree');
                        });
                      },
                      title: TextButton(
                        onPressed: () {
                          _launchURL; // Apelăm funcția pentru a lansa URL-ul
                          print('Butonul a fost apasat');
                        },
                        child: const Text(
                          'Sunt de acord cu Termenii și Condițiile și Politica de confidențialitate',
                          style: TextStyle(color: Colors.black),
                        ),
                        // activeColor: const Color.fromRGBO(26, 147, 192, 1),
                        // controlAffinity: ListTileControlAffinity.leading,
                        // value: agree,
                      ),
                    ),

                    //
                    //botao
                    const SizedBox(height: 20),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            //Subtmeter
                            onPressed: _submit,
                            style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15,
                                ),
                                backgroundColor:
                                    const Color.fromRGBO(26, 147, 192, 1),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            child: const Text('Înregistrează',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)))),

                    ///
                    //botao para registar
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.center,
                      child: TextButton(
                        onPressed: () {
                          //Navegar a pagina de login (login_screen)
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Aveți deja un cont ?',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                              TextSpan(
                                  text: ' Login',
                                  style: TextStyle(
                                      color: Color.fromRGBO(26, 147, 192, 1),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}
