class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int? height;
  final int? weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    this.height,
    this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default'] ??
          json['sprites']['front_default'] ??
          '',
      types: (json['types'] as List)
          .map((t) => t['type']['name'] as String)
          .toList(),
      height: json['height'],
      weight: json['weight'],
    );
  }

  factory Pokemon.fromListJson(Map<String, dynamic> json) {
    // Extract ID from URL for list items
    final urlParts = (json['url'] as String).split('/');
    final id = int.parse(urlParts[urlParts.length - 2]);

    return Pokemon(
      id: id,
      name: json['name'],
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      types: [], // List view might not have types initially
    );
  }
}
