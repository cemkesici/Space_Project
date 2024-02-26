// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:space_app/models/data_model.dart';
import 'package:space_app/screens/sharepost_page.dart';
import 'package:space_app/services/api_services.dart';

void main() => runApp(Home());

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _weatherService = WeatherService();
  Weather? _weather;

  //fetch Weather
  _fetchWeather() async {
    //get the current city
    var temp = (await _weatherService.getCurrentCity());
    double lat = temp.item1;
    double lon = temp.item2;
    //get weather for city
    try {
      final weather = await _weatherService.getWeather(lat, lon);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

//init State
  @override
  void initState() {
    super.initState();
    //fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 151, 151, 151),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                'assets/logo.png',
                fit: BoxFit.contain,
                height: 64,
              ),
              SizedBox(
                height: 36,
                child: VerticalDivider(
                  color: Color.fromARGB(255, 61, 57, 57),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${_weather?.cityName}: ${_weather?.temprature} °C",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${_weather?.mainCondition}",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          // We must specify the correct type here
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            // Check for errors
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            // Check for connection state
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final docs = snapshot.data!.docs;
              return ListView.builder(
                padding: const EdgeInsets.only(top: 20.0),
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  // DocumentSnapshot doc = docs[index];
                  final data = docs[index].data() as Map<String, dynamic>;
                  DateTime createdAt =
                      (data['createdAt'] as Timestamp).toDate();

                  // Make sure to use the actual field names in your document
                  return Card(
                    margin: EdgeInsets.only(bottom: 20.0, right: 15, left: 15),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  data['title'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy').format(createdAt),
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w200),
                              ),
                            ],
                          ),
                          LimitedBox(
                            maxHeight: 150,
                            child: SingleChildScrollView(
                              child: Text(data['details'],
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color.fromARGB(255, 255, 147, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(icon: Icon(Icons.exit_to_app), onPressed: null),
              IconButton(
                icon: Icon(Icons.add_box),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => SharePostPage(),
                  );
                },
              ),
              IconButton(icon: Icon(Icons.settings), onPressed: null),
            ],
          ),
        ),
      ),
    );
  }
}
