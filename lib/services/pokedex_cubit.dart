import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/pokedex_state.dart';
import 'pokeapi_service.dart';

/// Controla a lógica da Pokédex e emite um [PokedexState] a cada mudança.
///
/// A tela nunca fala com a API diretamente: ela só chama os métodos do
/// Cubit e reage aos estados emitidos.
class PokedexCubit extends Cubit<PokedexState> {
  PokedexCubit(this._service) : super(const PokedexInitial());

  final PokeApiService _service;

  Future<void> search(String query) async {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return;

    emit(const PokedexLoading());

    try {
      final pokemon = await _service.fetchPokemon(term);
      emit(PokedexLoaded(pokemon));
    } on PokemonNotFoundException {
      emit(PokedexError('Pokémon "${query.trim()}" não encontrado.'));
    } catch (_) {
      emit(const PokedexError('Não foi possível conectar à PokéAPI.'));
    }
  }

  Future<void> next() => _moveBy(1);

  Future<void> previous() => _moveBy(-1);

  Future<void> _moveBy(int offset) async {
    final current = state;
    if (current is! PokedexLoaded) return;

    final id = current.pokemon.id + offset;
    if (id < 1) return;

    await search('$id');
  }
}
