import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'screens/pokedex_screen.dart';
import 'services/pokeapi_service.dart';
import 'services/pokedex_cubit.dart';

void main() => runApp(const PokedexApp());

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokédex',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ),
      ),
      // Disponibiliza o Cubit para a tela e para todos os widgets abaixo dela.
      home: BlocProvider(
        create: (_) => PokedexCubit(PokeApiService()),
        child: const PokedexScreen(),
      ),
    );
  }
}
