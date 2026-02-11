import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topic_1_deeplink_universal_link/domain/usecases/get_pokemon_detail_usecase.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final GetPokemonDetailUseCase getPokemonDetailUseCase;

  DetailCubit({required this.getPokemonDetailUseCase}) : super(DetailInitial());

  Future<void> loadPokemonDetail(int id) async {
    emit(DetailLoading());

    try {
      final pokemon = await getPokemonDetailUseCase(id);
      emit(DetailLoaded(pokemon));
    } catch (e) {
      emit(DetailError(e.toString()));
    }
  }
}
