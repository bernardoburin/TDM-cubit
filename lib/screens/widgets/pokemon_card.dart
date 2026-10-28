import 'package:flutter/material.dart';

import '../../model/pokemon.dart';

const _typeColors = <String, Color>{
  'normal': Color(0xFFA8A77A),
  'fire': Color(0xFFEE8130),
  'water': Color(0xFF6390F0),
  'electric': Color(0xFFF7D02C),
  'grass': Color(0xFF7AC74C),
  'ice': Color(0xFF96D9D6),
  'fighting': Color(0xFFC22E28),
  'poison': Color(0xFFA33EA1),
  'ground': Color(0xFFE2BF65),
  'flying': Color(0xFFA98FF3),
  'psychic': Color(0xFFF95587),
  'bug': Color(0xFFA6B91A),
  'rock': Color(0xFFB6A136),
  'ghost': Color(0xFF735797),
  'dragon': Color(0xFF6F35FC),
  'dark': Color(0xFF705746),
  'steel': Color(0xFFB7B7CE),
  'fairy': Color(0xFFD685AD),
};

Color _colorFor(String type) => _typeColors[type] ?? Colors.grey;

class PokemonCard extends StatelessWidget {
  const PokemonCard({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mainColor = _colorFor(pokemon.types.first);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: mainColor.withValues(alpha: 0.25),
            padding: const EdgeInsets.all(16),
            child: Image.network(
              pokemon.imageUrl,
              height: 220,
              loadingBuilder: (_, image, progress) => progress == null
                  ? image
                  : const SizedBox(
                      height: 220,
                      child: Center(child: CircularProgressIndicator()),
                    ),
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.image_not_supported, size: 120),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(pokemon.number, style: textTheme.titleMedium),
                Text(
                  pokemon.displayName,
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final type in pokemon.types)
                      Chip(
                        label: Text(type.toUpperCase()),
                        labelStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        backgroundColor: _colorFor(type),
                        side: BorderSide.none,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _Info(label: 'Altura', value: '${pokemon.height} m'),
                    _Info(label: 'Peso', value: '${pokemon.weight} kg'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(value, style: textTheme.titleLarge),
        Text(label, style: textTheme.bodySmall),
      ],
    );
  }
}
