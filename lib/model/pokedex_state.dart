import 'package:equatable/equatable.dart';

import 'pokemon.dart';

/// Estados possíveis da tela da Pokédex.
///
/// Como todos estendem [Equatable], o Cubit só notifica a tela quando o
/// novo estado é realmente diferente do atual.
sealed class PokedexState extends Equatable {
  const PokedexState();

  @override
  List<Object?> get props => [];
}

/// Nenhuma busca foi feita ainda.
final class PokedexInitial extends PokedexState {
  const PokedexInitial();
}

/// Aguardando a resposta da PokéAPI.
final class PokedexLoading extends PokedexState {
  const PokedexLoading();
}

/// Pokémon encontrado com sucesso.
final class PokedexLoaded extends PokedexState {
  const PokedexLoaded(this.pokemon);

  final Pokemon pokemon;

  @override
  List<Object?> get props => [pokemon];
}

/// Algo deu errado (Pokémon inexistente ou falha de rede).
final class PokedexError extends PokedexState {
  const PokedexError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
