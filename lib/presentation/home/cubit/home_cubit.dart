import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topic_1_deeplink_universal_link/domain/usecases/get_pokemon_list_usecase.dart';
import '../../../domain/entities/pokemon_entity.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetPokemonListUseCase getPokemonListUseCase;

  // Keep track of internal state for pagination
  int _offset = 0;
  final int _limit = 50;
  bool _isFetching = false;

  HomeCubit({required this.getPokemonListUseCase}) : super(HomeInitial());

  Future<void> loadPokemon({bool refresh = false}) async {
    if (_isFetching) return;

    // Determine the current list based on state
    final currentList = state is HomeLoaded
        ? (state as HomeLoaded).pokemonList
        : (state is HomeError
              ? (state as HomeError).currentList
              : <PokemonEntity>[]);

    if (refresh) {
      _offset = 0;
      emit(HomeLoading(currentList: [], isFirstLoad: true));
    } else {
      if (currentList.isEmpty) {
        emit(HomeLoading(currentList: [], isFirstLoad: true));
      } else {
        // Don't emit loading if we already have data (for infinite scroll),
        // effectively handled by UI showing a spinner at bottom,
        // but explicit loading state can be useful.
        // For simplicity, let's just mark fetching flag.
        // Or we can emit a state with same data but loading status?
        // Let's stick to simple "Loaded" state updates or specific loading state if needed.
        // Actually, typical pattern is: stay in Loaded but show indicator.
        // But to make UI reactive to "loading more", we might want a property in Loaded?
        // Let's use HomeLoading with existing data for "loading more".
        emit(HomeLoading(currentList: currentList, isFirstLoad: false));
      }
    }

    _isFetching = true;

    try {
      final newPokemon = await getPokemonListUseCase(
        offset: _offset,
        limit: _limit,
      );

      final updatedList = refresh
          ? newPokemon
          : [...currentList, ...newPokemon];

      _offset += newPokemon.length;
      _isFetching = false;

      // If we got fewer items than limit, we might have reached max,
      // but PokeAPI total count is high. Simple logic: empty list = max.
      final hasReachedMax = newPokemon.isEmpty;

      emit(HomeLoaded(pokemonList: updatedList, hasReachedMax: hasReachedMax));
    } catch (e) {
      _isFetching = false;
      emit(HomeError(e.toString(), currentList: currentList));
    }
  }
}
