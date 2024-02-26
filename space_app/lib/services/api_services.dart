// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:geolocator/Geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:space_app/models/data_model.dart';
import 'package:tuple/tuple.dart';

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey = "3dc691ae0c4678908fbc53c4dd033e0b";
  WeatherService();

  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(Uri.parse(
        '$BASE_URL?lat=${lat}&lon=${lon}&appid=${apiKey}&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<Tuple2<double, double>> getCurrentCity() async {
    //İMPORT GEOLOCATOR
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // Test if location services are enabled.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      //fetch the current location İMPORT GEOLOCATOR
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      double lat = double.parse(position.latitude.toStringAsFixed(2));
      double long = double.parse(position.longitude.toStringAsFixed(2));

      return Tuple2(lat, long);
    } catch (e) {
      throw Exception(e);
    }
  }
}
