// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class SharePostPage extends StatefulWidget {
  SharePostPage({super.key});

  @override
  State<SharePostPage> createState() => _SharePostPageState();
}

class _SharePostPageState extends State<SharePostPage> {
  final _detailsController = TextEditingController();
  final _titleController = TextEditingController();

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
                controller: _detailsController,
                decoration: const InputDecoration(labelText: 'Konu'),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: _titleController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Açıklama',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Giriş Yap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
