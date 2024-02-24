// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/Geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:space_app/data_model.dart';

class WeatherService {
  // ignore: constant_identifier_names
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey = "3dc691ae0c4678908fbc53c4dd033e0b";

  WeatherService();

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=${cityName}&appid=${apiKey}&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
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

      //Convert the location into a list of placemark objects İMPORT GEOCODİNG
      List<Placemark> placemark =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      //extract the city name from the first placemark
      if (placemark[0].locality != null) {
        String? city = placemark[0].locality;
        return city ?? "";
      } else {
        return Future.error('Location is not find');
      }
    } catch (e) {
      throw Exception(e);
    } finally {
      return "İstanbul";
    }
  }
}
