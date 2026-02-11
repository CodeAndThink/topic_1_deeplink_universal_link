import '../../domain/entities/pokemon_entity.dart';
import '../../domain/repositories/pokemon_repository.dart';
import '../datasources/pokemon_remote_data_source.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PokemonEntity>> getPokemonList({
    required int offset,
    int limit = 20,
  }) async {
    return await remoteDataSource.getPokemonList(offset: offset, limit: limit);
  }

  @override
  Future<PokemonEntity> getPokemonDetail(int id) async {
    return await remoteDataSource.getPokemonDetail(id);
  }
}
