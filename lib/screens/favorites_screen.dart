import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../widgets/country_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
      ),
      body: Consumer<CountryProvider>(
        builder: (context, provider, _) {
          final favorites = provider.favoriteCountries;

          if (favorites.isEmpty) {
            return const Center(
              child: Text('Aucun favori pour le moment.'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.75,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final country = favorites[index];
              return CountryCard(country: country);
            },
          );
        },
      ),
    );
  }
}