import 'package:equatable/equatable.dart';

/// Representa um Pokémon retornado pela PokéAPI.
///
/// Estende [Equatable] para que dois objetos com os mesmos dados sejam
/// considerados iguais (comparação por valor, e não por referência).
class Pokemon extends Equatable {
  const Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final sprites = json['sprites'] as Map<String, dynamic>;
    final artwork = sprites['other']?['official-artwork']?['front_default'];

    return Pokemon(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: (artwork ?? sprites['front_default'] ?? '') as String,
      types: [
        for (final slot in json['types'] as List)
          slot['type']['name'] as String,
      ],
      // A API retorna altura em decímetros e peso em hectogramas.
      height: (json['height'] as int) / 10,
      weight: (json['weight'] as int) / 10,
    );
  }

  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;

  /// Altura em metros.
  final double height;

  /// Peso em quilos.
  final double weight;

  /// Número no formato da Pokédex, ex.: #025.
  String get number => '#${id.toString().padLeft(3, '0')}';

  String get displayName => name[0].toUpperCase() + name.substring(1);

  @override
  List<Object?> get props => [id, name, imageUrl, types, height, weight];
}
