// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../functions/bottombar_design.dart';

class UserInformationScreen extends StatefulWidget {
  const UserInformationScreen({super.key});

  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  User? _user;
  String? _name;
  String? _surname;

  @override
  void initState() {
    super.initState();
    loadUserInformation();
  }

  Future<void> loadUserInformation() async {
    User? user = FirebaseAuth.instance.currentUser;

    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .where('email', isEqualTo: user!.email)
        .get();

    if (snapshot.docs.isNotEmpty) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = snapshot.docs.first;

      setState(() {
        _name = userDoc.data()?['name'];
        _surname = userDoc.data()?['surname'];
      });
    }

    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kullanıcı Bilgileri'),
      ),
      body: Stack(
        children: [
          Positioned(
            child: Center(
              child: SvgPicture.asset(
                'assets/loginpage_background.svg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Center(
            child: _user != null
                ? Card(
                    elevation: 10,
                    child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Email: ${_user!.email ?? "N/A"}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Name: ${_name ?? "N/A"}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'Surname: ${_surname ?? "N/A"}',
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(
                              'UID: ${_user!.uid}',
                              style: TextStyle(fontSize: 20),
                            ),
                          ],
                        )))
                : CircularProgressIndicator(),
          ),
        ],
      ),
      bottomNavigationBar: bottomarDesign(context),
    );
  }
}
