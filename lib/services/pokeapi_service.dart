import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/pokemon.dart';

class PokemonNotFoundException implements Exception {
  const PokemonNotFoundException(this.query);

  final String query;
}

/// Responsável apenas por buscar dados na PokéAPI.
class PokeApiService {
  PokeApiService({http.Client? client}) : _client = client ?? http.Client();

  static const _baseUrl = 'https://pokeapi.co/api/v2/pokemon';

  final http.Client _client;

  /// Busca um Pokémon pelo nome (ex.: "pikachu") ou pelo número (ex.: "25").
  Future<Pokemon> fetchPokemon(String nameOrId) async {
    final response = await _client.get(Uri.parse('$_baseUrl/$nameOrId'));

    if (response.statusCode == 404) {
      throw PokemonNotFoundException(nameOrId);
    }
    if (response.statusCode != 200) {
      throw http.ClientException('Erro ${response.statusCode} na PokéAPI');
    }

    return Pokemon.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
