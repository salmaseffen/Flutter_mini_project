import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortOption { nameAsc, nameDesc, populationAsc, populationDesc }

class CountryProvider with ChangeNotifier {
  List<Country> _countries = [];
  bool _isLoading = false;
  String _error = '';
  String _query = '';
  Set<String> _favorites = {};
  SortOption _sort = SortOption.nameAsc;

  List<Country> get countries => _countries;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  List<Country> get visibleCountries {
    List<Country> list = _countries.where((c) {
      final q = _query.toLowerCase();
      return q.isEmpty ||
          c.name.toLowerCase().contains(q) ||
          c.capital.toLowerCase().contains(q);
    }).toList();

    switch (_sort) {
      case SortOption.nameAsc:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case SortOption.populationAsc:
        list.sort((a, b) => a.population.compareTo(b.population));
        break;
      case SortOption.populationDesc:
        list.sort((a, b) => b.population.compareTo(a.population));
        break;
    }
    return list;
  }

  String get query => _query;

  CountryProvider() {
    loadCountries();
    _loadFavorites();
  }

  Future<void> loadCountries() async {
    _isLoading = true;
    notifyListeners();

    try {
      _countries = await CountryService().getAllCountries();
      _error = '';
    } catch (e) {
      _error = 'Failed to load countries: $e';
      _countries = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setQuery(String query) {
    _query = query;
    notifyListeners();
  }

  void setSort(SortOption option) {
    _sort = option;
    notifyListeners();
  }

  List<Country> get favoriteCountries =>
      _countries.where((c) => _favorites.contains(c.code)).toList();

  bool isFavorite(String code) => _favorites.contains(code);

  Future<void> toggleFavorite(String code) async {
    if (_favorites.contains(code)) {
      _favorites.remove(code);
    } else {
      _favorites.add(code);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites.toList());
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('favorites') ?? [];
    _favorites = list.toSet();
    notifyListeners();
  }
}