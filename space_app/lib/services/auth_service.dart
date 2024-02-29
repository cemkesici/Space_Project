// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:space_app/screens/home_page.dart';

import '../screens/login_page.dart';

class AuthService {
  final userCollection = FirebaseFirestore.instance.collection("users");
  final postCollection = FirebaseFirestore.instance.collection("posts");
  final firebaseAuth = FirebaseAuth.instance;

  Future<bool> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2));
    return false;
  }

  Future<void> signUp(
      {required BuildContext context,
      required String name,
      required String surname,
      required String email,
      required String password}) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email.toString().trim(),
        password: password.toString().trim(),
      );
      if (userCredential.user != null) {
        registerUser(
            context: context,
            name: name,
            surname: surname,
            email: email,
            password: password);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(
          msg: 'Parola Yetersiz!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
          msg: 'Email adresi kullanılıyor!',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
  }

  Future<void> signIn(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      final UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
              email: email.toString().trim(),
              password: password.toString().trim());
      if (userCredential.user != null) {
        Fluttertoast.showToast(
            msg: "Giriş başarılı", toastLength: Toast.LENGTH_LONG);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const Home(),
        ));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        Fluttertoast.showToast(
          msg: "Email yada Parola Hatalı!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
      }
    }
  }

  Future<void> sharePost(
      {required BuildContext context,
      required String details,
      required String userName,
      required String title}) async {
    try {
      await postCollection.doc().set({
        "details": details,
        "userName": userName,
        "title": title,
        'createdAt': FieldValue.serverTimestamp()
      });
      Fluttertoast.showToast(
        msg: "Paylaşım Yapıldı!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
  }

  Future<void> registerUser(
      {required BuildContext context,
      required String name,
      required String surname,
      required String email,
      required String password}) async {
    try {
      await userCollection.doc().set({
        "email": email.toString().trim(),
        "name": name.toString().trim(),
        "surname": surname.toString().trim(),
        "password": password.toString().trim()
      });
      Fluttertoast.showToast(
        msg: "Kayıt Başarılı!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginPage(),
      ));
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
        msg: e.message!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
      );
    }
  }
}
