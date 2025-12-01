class Country {
  final String name;
  final String capital;
  final String flag;
  final String region;
  final int population;
  final String code;

  const Country({
    required this.name,
    required this.capital,
    required this.flag,
    required this.region,
    required this.population,
    required this.code,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final dynamic flags = json['flags'];
    final String flagUrl = flags is Map<String, dynamic>
        ? (flags['png'] ?? flags['svg'] ?? '')
        : (json['flag'] ?? '');
    
    return Country(
      name: json['name'] ?? 'Unknown',
      capital: json['capital'] ?? 'No capital',
      flag: flagUrl,
      region: json['region'] ?? 'Unknown',
      population: json['population'] ?? 0,
      code: json['alpha3Code'] ?? json['alpha2Code'] ?? '',
    );
  }
}
