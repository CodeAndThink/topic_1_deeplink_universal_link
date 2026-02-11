import 'package:equatable/equatable.dart';
import '../../../domain/entities/pokemon_entity.dart';

///State for DetailCubit
abstract class DetailState extends Equatable {
  const DetailState();

  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {}

class DetailLoading extends DetailState {}

class DetailLoaded extends DetailState {
  final PokemonEntity pokemon;

  const DetailLoaded(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}

class DetailError extends DetailState {
  final String message;

  const DetailError(this.message);

  @override
  List<Object?> get props => [message];
}
