// ignore_for_file: avoid_print, duplicate_ignore, sized_box_for_whitespace, unnecessary_cast

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:imob_expert/screens/login_screen.dart';
import 'package:imob_expert/database/Models/my_details.dart';
import 'package:imob_expert/database/Models/my_messages.dart';
import 'package:imob_expert/screens/payment_page.dart';
import 'package:imob_expert/screens/register_buy_property_screen.dart';
import 'package:imob_expert/screens/register_rent_property_screen.dart';
import 'package:imob_expert/screens/register_sell_property_screen.dart';
import 'package:imob_expert/screens/signup_screen.dart';
import 'package:imob_expert/widgets/category_widget.dart';
import 'package:imob_expert/widgets/delete_account.dart';
import 'package:imob_expert/widgets/logOut.dart';
import 'package:imob_expert/widgets/my_adds.dart';
import 'package:imob_expert/widgets/property_list_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// @override
// void initState() {;
//   super.initState();
//   // _loadUserData();
// }

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _getUserData();
    _checkMessages();
    // _refresh();
  }

  final User? user = FirebaseAuth.instance.currentUser;
  final TextEditingController _searchController = TextEditingController();
  String _searchRegion = '';
  double credit = 0.0;

  Future<Map<String, String>> _getUserData() async {
    if (user != null) {
      try {
        DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
            .instance
            .collection('Users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          String name = userDoc.data()?['Name'] ?? 'Nume';
          String surname = userDoc.data()?['Surname'] ?? 'Prenume';
          String credit = userDoc.data()?['Credit'] ?? 'Credit';

          return {'name': name, 'surname': surname, 'credit': credit};
        } else {
          print('Document does not exist.');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
    return {'name': 'Vizitator', 'surname': ''};
  }

  Future<bool> _checkMessages() async {
    if (user != null) {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('Messages').get();

      for (var doc in querySnapshot.docs) {
        final messages =
            (doc.data() as Map<String, dynamic>)['messages'] as List<dynamic>;
        for (var message in messages) {
          if (message['recipientId'] == user!.uid && !message['isRead']) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _navigateToRegisterProperty(BuildContext context, String result) {
    if (user != null) {
      if (result == 'Vânzare') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterSellPropertyScreen(
              propertyType: result,
              phoneNumber: '',
            ),
          ),
        );
      } else if (result == 'Închirieri') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterRentPropertyScreen(
              propertyType: result,
            ),
          ),
        );
      } else if (result == 'Cumpăr') {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterBuyPropertyScreen(
              propertyType: result,
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login to add imobil.'),
        ),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  // Functie de refresh
  Future<void> _refresh() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // _items = List.generate(20, (index) => 'Item refăcut $index');
      _checkMessages();
      _getUserData();
    });
  }

  void _searchProperties() {
    setState(() {
      _searchRegion = _searchController.text.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Padding(
              padding: EdgeInsets.only(left: 12.0),
              child: Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: <Widget>[
          if (user != null)
            FutureBuilder<bool>(
              future: _checkMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications,
                      color: Colors.black,
                    ),
                  );
                } else {
                  bool messagesExist = snapshot.data ?? false;
                  return IconButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyMessages(),
                      ),
                    ),
                    icon: Icon(
                      messagesExist
                          ? Icons.notifications_active_rounded
                          : Icons.notifications,
                      color: messagesExist ? Colors.red[400] : Colors.black,
                    ),
                  );
                }
              },
            ),
          FutureBuilder<Map<String, String>>(
            future: _getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text(
                  'Eroare la încărcarea datelor',
                  style: TextStyle(color: Colors.black),
                );
              } else {
                final userData = snapshot.data!;
                if (user != null) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PaymentPage(),
                          ),
                        );
                      },
                      child: Text(
                        '${userData['credit']} \n MDL',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: Text(
                      '',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(26, 147, 192, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 25.0,
                    top: 50.0,
                    bottom: 25.0,
                  ),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          "Imob Expert",
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: FutureBuilder<Map<String, String>>(
                    future: _getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const ListTile(
                          leading: Icon(
                            Icons.error,
                            color: Colors.white,
                          ),
                          title: Text(
                            'Eroare la încărcarea datelor',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        final userData = snapshot.data!;
                        credit == userData['credit'];

                        return GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => user != null
                                  ? const MyDetailsPage()
                                  // user not loged in
                                  : const LoginScreen(),
                            ),
                          ),
                          child: ListTile(
                            leading: const Icon(
                              Icons.home,
                              color: Colors.white,
                            ),
                            title: Text(
                              '${userData['name']} ${userData['surname']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                if (user != null)
                  // final userData = snapshot.data!;
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 25.0,
                      // top: 10,
                    ),
                    child: ListTile(
                      leading: const Icon(
                        Icons.my_library_add_rounded,
                        color: Colors.white,
                      ),
                      title: PopupMenuButton<String>(
                        onSelected: (String result) {
                          print('Selected: $result'); // Log selected value
                          _navigateToRegisterProperty(context, result);
                        },
                        itemBuilder: (BuildContext context) => credit > 9.99
                            ? <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const PaymentPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Eroare , \nNu aveți suficiente resurse. Vă rugam sa supliniți contul.',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ]
                            : <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Vânzare',
                                  child: Text('Vânzare'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Închirieri',
                                  child: Text('Închiriez'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Cumpăr',
                                  child: Text('Cumpăr'),
                                ),
                              ],
                        child: const Text(
                          "Adaugă anunț",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 43.0,
                        // top: 15,
                      ),
                      child: Row(children: [
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Înregistrează-te',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ]),
                    ),
                  ),
                if (user != null)
                  //
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyAdds(),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 43.0,
                        top: 15,
                      ),
                      child: Row(children: [
                        Icon(
                          Icons.note_add_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Anunțurile mele',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ]),
                    ),
                  )
                else
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 43.0,
                        top: 15,
                      ),
                      child: Row(children: [
                        Icon(
                          Icons.arrow_right_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Intră',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ]),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (user != null)
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PaymentPage(),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(left: 43.0, top: 15),
                      child: Row(children: [
                        Icon(
                          Icons.add_card_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Suplinește cont',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ]),
                    ),
                  ),
                const SizedBox(
                  height: 10,
                ),
                if (user != null)
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyMessages(),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                        left: 43.0,
                        top: 15,
                      ),
                      child: Row(children: [
                        Icon(
                          Icons.message_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          'Mesaje',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ]),
                    ),
                  ),
                if (user != null)
                  const Padding(
                    padding: EdgeInsets.only(top: 400.0),
                    child: Row(
                      children: [
                        logOut(),
                        SizedBox(
                          width: 30,
                        ),
                        deleteAccount(),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.black),
                        onPressed: _searchProperties,
                      ),
                      Container(
                        height: 50,
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextFormField(
                            controller: _searchController,
                            decoration: const InputDecoration(
                              hintText: 'Căutați o locație',
                              border: InputBorder.none,
                            ),
                            onFieldSubmitted: (value) {
                              _searchProperties();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            //Categoria
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 20),
              child: Text(
                'Categorii',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const CategoryWidget(),
            PropertyListWidget(searchRegion: _searchRegion),
          ],
        ),
      ),
    );
  }
}
