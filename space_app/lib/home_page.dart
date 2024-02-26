import 'package:flutter/material.dart';
import 'package:space_app/api_services.dart';
import 'package:space_app/data_model.dart';

void main() => runApp(const Home());

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //api Key
  final _weatherService = WeatherService();
  // ignore: unused_field
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
        primaryColor: Colors.white,
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
                height: 66,
              ),
              const SizedBox(
                height: 36,
                child: VerticalDivider(
                  color: Color.fromARGB(255, 70, 69, 69),
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
        body: const Column(
          children: [],
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
