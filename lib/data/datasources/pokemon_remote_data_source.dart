import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

abstract class PokemonRemoteDataSource {
  Future<List<PokemonModel>> getPokemonList({
    required int offset,
    int limit = 20,
  });
  Future<PokemonModel> getPokemonDetail(int id);
}

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final String baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  @override
  Future<List<PokemonModel>> getPokemonList({
    required int offset,
    int limit = 20,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl?offset=$offset&limit=$limit'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];

      // Fetch details for each pokemon to get stats/types/image
      // We start with basic info from list
      List<PokemonModel> pokemonList = [];

      // Parallelize requests for performance
      final futures = results.map((json) async {
        // Create a temporary model to get the ID
        final temp = PokemonModel.fromListJson(json);
        return await getPokemonDetail(temp.id);
      });

      pokemonList = await Future.wait(futures);
      return pokemonList;
    } else {
      throw Exception('Failed to load pokemon list');
    }
  }

  @override
  Future<PokemonModel> getPokemonDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));

    if (response.statusCode == 200) {
      return PokemonModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load pokemon detail');
    }
  }
}
