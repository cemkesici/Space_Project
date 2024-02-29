import 'dart:convert';

import 'package:geolocator/Geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:space_app/models/data_model.dart';
import 'package:tuple/tuple.dart';

class WeatherService {
  static const baseUrl = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey = "3dc691ae0c4678908fbc53c4dd033e0b";

  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(
        Uri.parse('$baseUrl?lat=$lat&lon=$lon&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Hava durumu verileri yüklenemedi');
    }
  }

  Future<void> saveLocation(double lat, double lon) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', lat);
    await prefs.setDouble('longitude', lon);
  }

  Future<Tuple2<double, double>> getSavedLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble('latitude');
    double? lon = prefs.getDouble('longitude');

    if (lat != null && lon != null) {
      return Tuple2(lat, lon);
    } else {
      throw Exception('Enlem ve boylam değerleri saklanmamış');
    }
  }

  Future<Tuple2<double, double>> getCurrentCity() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low);

      double lat = position.latitude;
      double lon = position.longitude;

      await saveLocation(lat, lon);
      return Tuple2(lat, lon);
    } catch (e) {
      throw Exception(e);
    }
  }
}
