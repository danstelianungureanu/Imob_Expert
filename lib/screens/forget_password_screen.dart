// import 'package:flutter/material.dart';
// import 'package:gestao_de_imobiliaria_mobile/screens/signup_screen.dart';

// class ForgetPasswordScreen extends StatefulWidget {
//   const ForgetPasswordScreen({super.key});

//   @override
//   State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
// }

// ignore_for_file: use_build_context_synchronously

// class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Padding(
//         padding: const EdgeInsets.all(50),
//         child: ListView(
//           children: [
//             Image.asset(
//               'assets/images/forgot-password.png',
//             ),
//             const Text(
//               'Reset your password',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   color: Color.fromRGBO(26, 147, 192, 1),
//                   fontWeight: FontWeight.bold,
//                   fontSize: 28),
//             ),
//             const Text(
//               'Enter your email address and a link will be sent to reset your password.',
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.black, fontSize: 16),
//             ),
//             const SizedBox(height: 40),
//             Form(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                   TextFormField(
//                       decoration: InputDecoration(
//                           //filled: true,
//                           //fillColor: Colors.white,
//                           prefixIcon: const Icon(Icons.mail),
//                           hintText: 'Email',
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(10)),
//                           contentPadding: const EdgeInsets.all(20))),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         //Navegar a pagina de registo (sign up)
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => const SignUp()));
//                       },
//                       style: TextButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 25,
//                             horizontal: 40,
//                           ),
//                           backgroundColor:
//                               const Color.fromRGBO(26, 147, 192, 1),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(40))),
//                       child: const Text(
//                         'Send',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 16,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   Align(
//                     alignment: Alignment.center,
//                     child: TextButton(
//                       onPressed: () {},
//                       child: const Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                                 text: 'Don’t have an account yet?',
//                                 style: TextStyle(
//                                     color: Colors.black, fontSize: 16)),
//                             TextSpan(
//                                 text: ' Register',
//                                 style: TextStyle(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold))
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ])),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:imob_expert/screens/login_screen.dart';
import 'package:imob_expert/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'A fost trimis un link de resetare a parolei ${_emailController.text}'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.message}'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: ListView(
          children: [
            Image.asset(
              'assets/images/forgot-password.png',
            ),
            const Text(
              'Resetarea parolei',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(26, 147, 192, 1),
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
            const Text(
              'Introduceți adresa de e-mail și un link va fi trimis pentru a reseta parola.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 40),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.mail),
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vă rugăm să introduceți e-mailul dvs';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Vă rugăm să introduceți o adresă de e-mail validă';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _resetPassword,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 25,
                          horizontal: 40,
                        ),
                        backgroundColor: const Color.fromRGBO(26, 147, 192, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: const Text(
                        'Trimite',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
                        );
                      },
                      child: const Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Nu aveți încă un cont ?',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                            TextSpan(
                              text: ' Înregistrare',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
