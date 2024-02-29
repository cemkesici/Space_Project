// ignore_for_file: prefer_const_constructors_in_immutables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:space_app/services/auth_service.dart';

class SharePostPage extends StatefulWidget {
  SharePostPage({super.key});

  @override
  State<SharePostPage> createState() => _SharePostPageState();
}

class _SharePostPageState extends State<SharePostPage> {
  final _detailsController = TextEditingController();
  final _titleController = TextEditingController();
  final _authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('myCollection')
          .doc('myDoc')
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(7.5)),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SizedBox(
                width: 450,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(labelText: 'Konu'),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _detailsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Açıklama',
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        var userEmail = FirebaseAuth.instance.currentUser?.email;
                        if (userEmail != null) {
                          _authService.sharePost(
                            context: context,
                            details: _detailsController.text,
                            title: _titleController.text,
                            userName: userEmail,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: "Paylaşım Yapılamadı!",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                          );
                        }
                      },
                      child: const Text('Paylaş'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator(strokeWidth: 3.0);
        }
      },
    );
  }
}
