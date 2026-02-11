import 'package:flutter/foundation.dart';

@immutable
class PokemonStatEntity {
  final String name;
  final int baseStat;

  const PokemonStatEntity({required this.name, required this.baseStat});
}

@immutable
class PokemonEntity {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int? height;
  final int? weight;
  final List<PokemonStatEntity> stats;

  const PokemonEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    this.height,
    this.weight,
    required this.stats,
  });
}
