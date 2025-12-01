import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  Future<List<Country>> getAllCountries() async {
    try {
      final response = await http
          .get(
            Uri.parse('https://www.apicountries.com/countries'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(response.body);
        if (decoded is List) {
          final List<dynamic> countriesData = decoded;
          final List<Country> countries = [];
          for (final countryData in countriesData) {
            countries.add(Country.fromJson(countryData as Map<String, dynamic>));
          }
          return countries;
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }
}
