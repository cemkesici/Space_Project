import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_app/functions/bottombar_design.dart';
import 'package:space_app/models/data_model.dart';
import 'package:space_app/services/api_services.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _weatherService = WeatherService();
  DateTime? createdAt;
  Weather? _weather;

  _fetchWeather() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double? lat = prefs.getDouble('latitude');
    double? lon = prefs.getDouble('longitude');

    if (lat != null && lon != null) {
      try {
        final weather = await _weatherService.getWeather(lat, lon);
        setState(() {
          _weather = weather;
        });
      } catch (e) {
        throw Exception(e);
      }
    } else {
      try {
        var temp = await _weatherService.getCurrentCity();
        setState(() {
          lat = temp.item1;
          lon = temp.item2;
        });

        final weather = await _weatherService.getWeather(lat!, lon!);
        setState(() {
          _weather = weather;
        });
      } catch (e) {
        throw Exception(e);
      }
    }
  }

  String getTimeElapsed(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return "şuan";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} dakika önce";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} saat ${difference.inMinutes.remainder(60)} dakika önce";
    } else {
      return "${difference.inDays} gün ${difference.inHours.remainder(24)} saat önce";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 151, 151, 151),
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
              const SizedBox(
                height: 36,
                child: VerticalDivider(
                  color: Color.fromARGB(255, 61, 57, 57),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "${_weather?.cityName}: ${_weather?.temprature} °C",
                      style: const TextStyle(fontSize: 12),
                    ),
                    Text(
                      "${_weather?.mainCondition}",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        body: Stack(children: [
          Positioned(
            child: Center(
              child: SvgPicture.asset(
                'assets/loginpage_background.svg',
                fit: BoxFit.fill,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 20.0),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    DateTime createdAt;
                    Object? potentialTimestamp = data['createdAt'];
                    if (potentialTimestamp is Timestamp) {
                      createdAt = potentialTimestamp.toDate();
                    } else {
                      createdAt = DateTime.now();
                    }
                    return Card(
                      margin:
                          const EdgeInsets.only(bottom: 20.0, right: 15, left: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data['title'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Divider(),
                            LimitedBox(
                              maxHeight: 150,
                              child: SingleChildScrollView(
                                child: Text(data['details'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal)),
                              ),
                            ),
                            const Divider(),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    data['userName'],
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                Text(
                                  getTimeElapsed(createdAt),
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
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
        ]),
        bottomNavigationBar: bottomarDesign(context),
      ),
    );
  }
}
