import 'package:flutter/material.dart';
import '../models/country.dart';
import '../screens/country_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
class CountryCard extends StatefulWidget {
  final Country country;

  const CountryCard({required this.country, super.key});

  @override
  State<CountryCard> createState() => _CountryCardState();
}

class _CountryCardState extends State<CountryCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                CountryDetailScreen(country: widget.country),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: _isPressed ? 0.95 : 1.0,
        child: Card(
          elevation: 4,
          child: Column(
            children: [
              Flexible(
                flex: 2,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: widget.country.flag.isNotEmpty
                          ? Hero(
                              tag: 'flag_${widget.country.code}',
                              child: Image.network(
                                widget.country.flag,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.flag, size: 40),
                            ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Consumer<CountryProvider>(
                        builder: (context, provider, _) {
                          final fav = provider.isFavorite(widget.country.code);
                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) =>
                                ScaleTransition(scale: animation, child: child),
                            child: IconButton(
                              key: ValueKey(fav),
                              icon: Icon(
                                fav ? Icons.favorite : Icons.favorite_border,
                                color: fav ? Colors.blue : Colors.white,
                              ),
                              onPressed: () =>
                                  provider.toggleFavorite(widget.country.code),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<CountryProvider>(
                    builder: (context, provider, _) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _highlight(
                            context,
                            widget.country.name,
                            provider.query,
                            const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          _highlight(
                            context,
                            'Capital: ${widget.country.capital}',
                            provider.query,
                            const TextStyle(fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _highlight(
      BuildContext context, String source, String query, TextStyle style) {
    if (query.isEmpty) return Text(source, style: style, textAlign: TextAlign.center);
    final lowerSource = source.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final start = lowerSource.indexOf(lowerQuery);
    if (start == -1) return Text(source, style: style, textAlign: TextAlign.center);
    final end = start + query.length;
    final primary = Theme.of(context).colorScheme.primary;

    return RichText(
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(text: source.substring(0, start), style: style),
          TextSpan(
            text: source.substring(start, end),
            style: style.copyWith(color: primary),
          ),
          TextSpan(text: source.substring(end), style: style),
        ],
      ),
    );
  }
}
