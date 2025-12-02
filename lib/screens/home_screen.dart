import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../widgets/country_card.dart';
import '../providers/theme_provider.dart';
import '../screens/favorites_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appBarTitles = ['Country Explorer', 'Mes Favoris'];

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitles[currentIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            tooltip: 'Changer thème',
            onPressed: () =>
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
        ],
      ),

      body: currentIndex == 0 ? _buildCountriesPage(context) : _buildFavoritesPage(context),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: "Countries",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
        ],
      ),
    );
  }

  Widget _buildCountriesPage(BuildContext context) {
    return Consumer<CountryProvider>(
      builder: (context, countryProvider, child) {
        if (countryProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (countryProvider.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${countryProvider.error}'),
                ElevatedButton(
                  onPressed: countryProvider.loadCountries,
                  child: const Text('Try Again'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: countryProvider.setQuery,
                decoration: const InputDecoration(
                  hintText: 'Search by name or capital',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: countryProvider.loadCountries,
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: countryProvider.visibleCountries.length,
                  itemBuilder: (context, index) {
                    final country = countryProvider.visibleCountries[index];
                    return CountryCard(country: country);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFavoritesPage(BuildContext context) {
    return Consumer<CountryProvider>(
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
    );
  }
}
