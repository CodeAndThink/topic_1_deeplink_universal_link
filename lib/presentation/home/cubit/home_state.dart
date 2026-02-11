import 'package:equatable/equatable.dart';
import '../../../domain/entities/pokemon_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {
  final List<PokemonEntity> currentList;
  final bool isFirstLoad;

  const HomeLoading({this.currentList = const [], this.isFirstLoad = false});

  @override
  List<Object?> get props => [currentList, isFirstLoad];
}

class HomeLoaded extends HomeState {
  final List<PokemonEntity> pokemonList;
  final bool hasReachedMax;

  const HomeLoaded({required this.pokemonList, this.hasReachedMax = false});

  @override
  List<Object?> get props => [pokemonList, hasReachedMax];
}

class HomeError extends HomeState {
  final String message;
  final List<PokemonEntity> currentList;

  const HomeError(this.message, {this.currentList = const []});

  @override
  List<Object?> get props => [message, currentList];
}
