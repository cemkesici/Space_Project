import 'package:flutter/material.dart';
import 'package:space_app/home_page.dart';

import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Space App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(239, 233, 136, 25),
      ),
      home: const Home(),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Positioned(
          child: Center(
            child: Image.asset(
              'assets/logo.png',
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            child: Center(
              child: Image.asset(
                'assets/mainpage_background.jpg',
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text('Giriş Yap'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
