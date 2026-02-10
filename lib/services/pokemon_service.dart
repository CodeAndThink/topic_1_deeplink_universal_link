import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon.dart';

class PokemonService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  Future<List<Pokemon>> getPokemonList({int limit = 20, int offset = 0}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List results = data['results'];
      return results.map((json) => Pokemon.fromListJson(json)).toList();
    } else {
      throw Exception('Failed to load pokemon list');
    }
  }

  Future<Pokemon> getPokemonDetail(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load pokemon detail');
    }
  }
}
