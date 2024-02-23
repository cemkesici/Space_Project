import 'package:flutter/material.dart';

import 'api_services.dart';
import 'user_model.dart';

void main() => runApp(const Home());

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<UserModel>? _userModel = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _userModel = (await ApiService().getUsers())!;
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Positioned(
            child: Center(
              child: Image.asset(
                'assets/logo.png',
              ),
            ),
          ),
        ),
        body: _userModel == null || _userModel!.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _userModel!.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Number: ${_userModel![index].id}"),
                            Text("User Name: ${_userModel![index].username}"),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Email: ${_userModel![index].email}"),
                            Text("Phone: ${_userModel![index].phone}"),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        )
                      ],
                    ),
                  );
                },
              ),
        bottomNavigationBar: const BottomAppBar(
          color: Color.fromARGB(255, 255, 147, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(icon: Icon(Icons.exit_to_app), onPressed: null),
              IconButton(icon: Icon(Icons.add_box), onPressed: null),
              IconButton(icon: Icon(Icons.settings), onPressed: null),
            ],
          ),
        ),
      ),
    );
  }
}
