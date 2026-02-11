import '../entities/pokemon_entity.dart';

abstract class PokemonRepository {
  Future<List<PokemonEntity>> getPokemonList({
    required int offset,
    int limit = 20,
  });
  Future<PokemonEntity> getPokemonDetail(int id);
}
