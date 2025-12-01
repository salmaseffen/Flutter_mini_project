import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryDetailScreen extends StatefulWidget {
  final Country country;

  const CountryDetailScreen({required this.country, super.key});

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[300],
              ),
              child: widget.country.flag.isNotEmpty
                  ? Hero(
                      tag: 'flag_${widget.country.code}',
                      child: Image.network(widget.country.flag, fit: BoxFit.contain),
                    )
                  : const Icon(Icons.flag, size: 80),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow('Country Name', widget.country.name),
                    _buildInfoRow('Capital', widget.country.capital),
                    _buildInfoRow('Region', widget.country.region),
                    _buildInfoRow('Population', widget.country.population.toString()),
                    _buildInfoRow('Country Code', widget.country.code),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}