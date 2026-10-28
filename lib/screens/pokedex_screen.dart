import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/pokedex_state.dart';
import '../model/pokemon.dart';
import '../services/pokedex_cubit.dart';
import 'widgets/pokemon_card.dart';

class PokedexScreen extends StatelessWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Nome ou número (ex.: pikachu, 25)',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: context.read<PokedexCubit>().search,
            ),
          ),
          Expanded(
            // Reconstrói só esta parte da tela quando o estado muda.
            child: BlocBuilder<PokedexCubit, PokedexState>(
              builder: (context, state) => switch (state) {
                PokedexInitial() => const _Message(
                    icon: Icons.catching_pokemon,
                    text: 'Busque um Pokémon pelo nome ou número.',
                  ),
                PokedexLoading() =>
                  const Center(child: CircularProgressIndicator()),
                PokedexLoaded(:final pokemon) => _PokemonView(pokemon),
                PokedexError(:final message) =>
                  _Message(icon: Icons.error_outline, text: message),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PokemonView extends StatelessWidget {
  const _PokemonView(this.pokemon);

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PokedexCubit>();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          PokemonCard(pokemon: pokemon),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilledButton.tonalIcon(
                onPressed: pokemon.id > 1 ? cubit.previous : null,
                icon: const Icon(Icons.chevron_left),
                label: const Text('Anterior'),
              ),
              FilledButton.tonalIcon(
                onPressed: cubit.next,
                icon: const Icon(Icons.chevron_right),
                label: const Text('Próximo'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
