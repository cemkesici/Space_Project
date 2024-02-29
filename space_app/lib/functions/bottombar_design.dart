import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/login_page.dart';
import '../screens/sharepost_page.dart';
import '../screens/userdetails_page.dart';

void main(context) {
  bottomarDesign(context);
}

BottomAppBar bottomarDesign(BuildContext context) {
  context = context;
  return BottomAppBar(
    color: const Color.fromARGB(255, 255, 147, 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    'Çıkmak istediğiniz emin misiniz?',
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Hayır'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: const Text('Evet'),
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.add_box),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => SharePostPage(),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UserInformationScreen(),
              ),
            );
          },
        ),
      ],
    ),
  );
}
