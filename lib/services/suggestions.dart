import 'package:flutter/services.dart';
import 'dart:convert';

class Cities {
  String city;
  String country;

  Cities({this.city, this.country});

  factory Cities.fromJson(Map<String, dynamic> parsedJson) {
    return Cities(city: parsedJson['name'] as String,
    country: parsedJson['country'] as String
    );
  }

}

class CityModel {
  static List<Cities> cities;

  static Future loadCities() async {
    try {
      cities = List<Cities>();
      String jsonString = await rootBundle.loadString('assets/city_list.json');
      Map  parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson['cities'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        cities.add(Cities.fromJson(categoryJson[i]));
      }
    }
    catch (e) {
      print(e);
    }
  }
}