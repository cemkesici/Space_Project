import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:space_app/screens/signin_page.dart';
import 'package:space_app/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Positioned(
              child: Center(
                child: SvgPicture.asset(
                  'assets/loginpage_background.svg',
                ),
              ),
            ),
            Center(
              child: Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 75,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Şifre',
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          _authService.signIn(
                              context: context,
                              email: _emailController.text,
                              password: _passwordController.text);
                        },
                        child: const Text('Giriş Yap'),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.1,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SigninPage(),
                    ));
                  },
                  child: const Text('Kayıt Ol'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
