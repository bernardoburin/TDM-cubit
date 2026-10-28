import 'package:flutter_test/flutter_test.dart';
import 'package:tdm_cubit/model/pokedex_state.dart';
import 'package:tdm_cubit/model/pokemon.dart';
import 'package:tdm_cubit/services/pokeapi_service.dart';
import 'package:tdm_cubit/services/pokedex_cubit.dart';

const pikachu = Pokemon(
  id: 25,
  name: 'pikachu',
  imageUrl: 'https://example.com/25.png',
  types: ['electric'],
  height: 0.4,
  weight: 6.0,
);

/// Serviço falso para testar o Cubit sem acessar a internet.
class FakePokeApiService extends PokeApiService {
  @override
  Future<Pokemon> fetchPokemon(String nameOrId) async {
    if (nameOrId == 'pikachu' || nameOrId == '25') return pikachu;
    throw PokemonNotFoundException(nameOrId);
  }
}

void main() {
  late PokedexCubit cubit;

  setUp(() => cubit = PokedexCubit(FakePokeApiService()));
  tearDown(() => cubit.close());

  test('começa no estado inicial', () {
    expect(cubit.state, const PokedexInitial());
  });

  test('emite Loading e depois Loaded ao encontrar o Pokémon', () async {
    // Graças ao Equatable, um PokedexLoaded novo é igual ao emitido
    // pelo Cubit, pois a comparação é feita pelos valores.
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([const PokedexLoading(), const PokedexLoaded(pikachu)]),
    );

    await cubit.search('  Pikachu ');
    await expectation;
  });

  test('emite Error quando o Pokémon não existe', () async {
    final expectation = expectLater(
      cubit.stream,
      emitsInOrder([
        const PokedexLoading(),
        const PokedexError('Pokémon "digimon" não encontrado.'),
      ]),
    );

    await cubit.search('digimon');
    await expectation;
  });

  test('ignora buscas vazias', () async {
    await cubit.search('   ');
    expect(cubit.state, const PokedexInitial());
  });
}
