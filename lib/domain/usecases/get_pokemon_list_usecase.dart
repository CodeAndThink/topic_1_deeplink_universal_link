import '../entities/pokemon_entity.dart';
import '../repositories/pokemon_repository.dart';

class GetPokemonListUseCase {
  final PokemonRepository repository;

  GetPokemonListUseCase(this.repository);

  Future<List<PokemonEntity>> call({required int offset, int limit = 20}) {
    return repository.getPokemonList(offset: offset, limit: limit);
  }
}
