import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app_v2/service/secrets.dart';

class ApiService {
  String location = '';
  String weatherIcon = 'heavycloud.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';

  // API CALL
  String searchWeatherAPI =
      "https://api.weatherapi.com/v1/forecast.json?key=$apiKey&days=7&q=";

  Future<void> fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData =
          Map<String, dynamic>.from(jsonDecode(searchResult.body) ?? 'No data');

      // grabbing values from weatehrData MAP
      var locationData = weatherData["location"];

      var currentWeather = weatherData['current'];

      location = getShortLocationName(locationData["name"]);

      var parsedDate =
          DateTime.parse(locationData['localtime'].substring(0, 10));
      var newDate = DateFormat('MMMMEEEEd').format(parsedDate);

      currentDate = newDate;

      // Update weather
      currentWeatherStatus = currentWeather["condition"]["text"];
      weatherIcon =
          "${currentWeatherStatus.replaceAll(' ', '').toLowerCase()}.png";
      temperature = currentWeather["temp_c"].toInt();
      windSpeed = currentWeather["wind_kph"].toInt();
      humidity = currentWeather["humidity"].toInt();
      cloud = currentWeather["cloud"].toInt();

      // Forecast data
      dailyWeatherForecast = weatherData["forecast"]['forecastday'];
      hourlyWeatherForecast = dailyWeatherForecast[0]['hour'];
    } catch (e) {
      throw Exception('Failed to fetch weather data: $e');
    }
  }

  //function to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return "${wordList[0]} ${wordList[1]}";
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }
}
