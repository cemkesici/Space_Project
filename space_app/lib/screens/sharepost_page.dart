// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.5)),
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
                  var userEmail = await getUserEmail();
                  if (userEmail != null) {
                    _authService.sharePost(
                        // ignore: use_build_context_synchronously
                        context: context,
                        details: _detailsController.text,
                        title: _titleController.text,
                        userName: userEmail);
                  } else {
                    // Handle case when user email is null
                    Fluttertoast.showToast(
                      msg: "Email Null",
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
  }
}
