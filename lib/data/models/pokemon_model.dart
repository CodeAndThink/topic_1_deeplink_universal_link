import '../../domain/entities/pokemon_entity.dart';

class PokemonModel extends PokemonEntity {
  const PokemonModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.types,
    super.height,
    super.weight,
    required super.stats,
    super.description,
  });

  factory PokemonModel.fromJson(
    Map<String, dynamic> json, {
    String description = '',
  }) {
    return PokemonModel(
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
      stats:
          (json['stats'] as List?)
              ?.map((s) => PokemonStatModel.fromJson(s))
              .toList() ??
          [],
      description: description,
    );
  }

  // Factory for list items (if needed, but we typically fetch details now)
  factory PokemonModel.fromListJson(Map<String, dynamic> json) {
    // Extract ID from URL for list items
    final urlParts = (json['url'] as String).split('/');
    final id = int.parse(urlParts[urlParts.length - 2]);

    return PokemonModel(
      id: id,
      name: json['name'],
      imageUrl:
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
      types: [],
      stats: [],
    );
  }
}

class PokemonStatModel extends PokemonStatEntity {
  const PokemonStatModel({required super.name, required super.baseStat});

  factory PokemonStatModel.fromJson(Map<String, dynamic> json) {
    return PokemonStatModel(
      name: json['stat']['name'],
      baseStat: json['base_stat'],
    );
  }
}
